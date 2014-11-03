Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaKCKK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:10:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46168 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaKCKK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:10:56 -0500
Date: Mon, 3 Nov 2014 11:10:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Cc: Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Kosina <trivial@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86, cpu: trivial printk formatting fixes
Message-ID: <20141103101049.GA27384@pd.tnic>
References: <1414929402-13377-1-git-send-email-stevenhoneyman@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1414929402-13377-1-git-send-email-stevenhoneyman@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 11:56:42AM +0000, Steven Honeyman wrote:
> A 2 line printk makes dmesg output messy, because the second line does not get a timestamp.
> For example:
> 
> [    0.012863] CPU0: Thermal monitoring enabled (TM1)
> [    0.012869] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> [    0.012958] Freeing SMP alternatives memory: 28K (ffffffff81d86000 - ffffffff81d8d000)
> [    0.014961] dmar: Host address width 39
> 
> V2: Revert change to log level, only fix the newline formatting issue
> 
> Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>

Yeah, patch is fine. I'm sorry that I forgot to ask you to add the
reasoning *why* this change is needed, i.e., all the details about dmesg
accessing /dev/kmsg directly and so on.

I think we want to explain why *really* this change is being done as
some old dmesg, as we saw, do work because they're using syslog(2) and
so on...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
