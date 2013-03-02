Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3CBXqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 18:46:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44914 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3CBXqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 18:46:36 -0500
Date: Sun, 3 Mar 2013 00:46:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, len.brown@intel.com
Subject: Re: [PATCH] x86: fix 32-bit *_cpu_data initializers
Message-ID: <20130302234623.GB15498@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Krzysztof Mazur <krzysiek@podlesie.net>, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	hpa@zytor.com, len.brown@intel.com
References: <1362266082-2227-1-git-send-email-krzysiek@podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362266082-2227-1-git-send-email-krzysiek@podlesie.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 12:14:42AM +0100, Krzysztof Mazur wrote:
> The commit 27be457000211a6903968dfce06d5f73f051a217
> (x86 idle: remove 32-bit-only "no-hlt" parameter, hlt_works_ok flag)
> removed the hlt_works_ok flag from struct cpuinfo_x86, but
> boot_cpu_data and new_cpu_data initializers were not changed causing
> setting f00f_bug flag, instead of fdiv_bug. If CONFIG_X86_F00F_BUG
> is not set the f00f_bug flag is never cleared.
> 
> To avoid such problems in future C99-style initialization is now used.
> 
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>

Good catch.

Acked-by: Borislav Petkov <bp@suse.de>

> ---
> $ cat < /proc/cpuinfo
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 13
> model name	: Intel(R) Pentium(R) M processor 1.73GHz
> stepping	: 8
> microcode	: 0x20
> cpu MHz		: 800.000
> cache size	: 2048 KB
> fdiv_bug	: no
> f00f_bug	: yes
> ...
>
> By the way now in struct cpuinfo_x86 for 32-bit systems pad0
> should be extended to 2 bytes or removed, because now 32-bit
> specific bugs area have now 6 bytes + pad0.

It's good that you bring this up - I have a patchset which removes all
those *_bug fields in cpuinfo_x86 which means the padding goes away too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
