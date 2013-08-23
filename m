Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3HWURz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:17:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50898 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab3HWURy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:17:54 -0400
Date: Fri, 23 Aug 2013 22:17:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        H Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-32: Early microcode loading stumbles over disabled
 DYNAMIC_FTRACE
Message-ID: <20130823201751.GA16046@pd.tnic>
References: <5217908E.2040702@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5217908E.2040702@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 06:40:46PM +0200, Jan Kiszka wrote:
> Below some hunks to get it working again - at least in the absence of
> any microcode in the initrd. Marking all involved functions as __init
> is another option (as __init implies notrace). But I bet there is more
> hidden. I see e.g. a pr_warn() in find_cpio_init that should trigger
> the issue as well if we hit the error it reports (btw. printing at
> this point of the boot should not work anyway, should it?).

I guess we can do early_printk there instead as x86_64_start_kernel()
does it but I'm not sure for the 32-bit case where we call
load_ucode_bsp/ap before we've even enabled paging.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
