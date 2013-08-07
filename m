Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3HGGve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:51:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38216 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134Ab3HGGvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:51:33 -0400
Date: Wed, 7 Aug 2013 08:51:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86, AMD: Make cpu_has_amd_erratum() use the correct
 struct cpuinfo_x86
Message-ID: <20130807065119.GA17920@pd.tnic>
References: <20130723194049.59ee11bb@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130723194049.59ee11bb@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 07:40:49PM +0200, Torsten Kaiser wrote:
> cpu_has_amd_erratum() is buggy, because it uses the per-cpu cpu_info
> before it is filled by smp_store_boot_cpu_info() / smp_store_cpu_info().
> 
> If early microcode loading is enabled its collect_cpu_info_amd_early() will
> fill ->x86 and so the fallback to boot_cpu_data is not used.
> But ->x86_vendor was not filled and is still 0 == X86_VENDOR_INTEL resulting in 
> no errata fixes getting applied and my system hangs on boot.
> 
> Using cpu_info in cpu_has_amd_erratum() is wrong anyway: Its only caller
> init_amd() will have a struct cpuinfo_x86 as parameter and the set_cpu_bug()
> that is controlled by cpu_has_amd_erratum() also only uses that struct.
> 
> So pass the struct cpuinfo_x86 from init_amd() to cpu_has_amd_erratum() and
> the broken fallback can be dropped.
> 
> I also added an WARN_ON() into the vendor check because init_amd() can only
> be used by AMD CPUs and if the current failure hadn't been silent this bug
> would have been much more obvious.
> 
> V2: At request of Borislav Petkov: BUG_ON -> WARN_ON and subject change
> 
> Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
