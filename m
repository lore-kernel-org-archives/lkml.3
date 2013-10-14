Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3JNJid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:38:33 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:49691 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab3JNJib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:38:31 -0400
Date: Mon, 14 Oct 2013 11:38:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, keescook@chromium.org,
        md@google.com, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kaslr] x86, relocs: Add more per-cpu gold special cases
Message-ID: <20131014093826.GA22177@gmail.com>
References: <20131011013954.GA28902@www.outflux.net>
 <tip-d751c169e9a6f0f853346f1184881422bd10b3c2@git.kernel.org>
 <20131014083035.GA20976@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014083035.GA20976@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> * tip-bot for Michael Davidson <tipbot@zytor.com> wrote:
> 
> > Commit-ID:  d751c169e9a6f0f853346f1184881422bd10b3c2
> > Gitweb:     http://git.kernel.org/tip/d751c169e9a6f0f853346f1184881422bd10b3c2
> > Author:     Michael Davidson <md@google.com>
> > AuthorDate: Thu, 10 Oct 2013 18:39:54 -0700
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Sun, 13 Oct 2013 03:11:57 -0700
> > 
> > x86, relocs: Add more per-cpu gold special cases
> 
> I'm quite sure that one of the recent x86/kaslr changes causes this 
> early x86-64 crash:

excluding tip:x86/kaslr fixes the crash. So it's one of these commits:

6e6a4932b0f5 x86, boot: Rename get_flags() and check_flags() to *_cpuflags()
6145cfe394a7 x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
f32360ef6608 x86, kaslr: Report kernel offset on panic
82fa9637a2ba x86, kaslr: Select random position from e820 maps
5bfce5ef55cb x86, kaslr: Provide randomness functions
8ab3820fd5b2 x86, kaslr: Return location from decompress_kernel
dd78b97367bd x86, boot: Move CPU flags out of cpucheck
d751c169e9a6 x86, relocs: Add more per-cpu gold special cases

One guess would be:

 dd78b97367bd x86, boot: Move CPU flags out of cpucheck

That commit is crazy large - it should be done in at least two steps:

 - first the movement to cpuflags.c
 - the PIC-safe refactoring

Also, checking:

 82fa9637a2ba x86, kaslr: Select random position from e820 maps

I see:

 +#ifdef CONFIG_X86_64
 +#define memptr long
 +#else
 +#define memptr unsigned
 +#endif

wtf? That should really be cleaned up while we are touching that code.

Thanks,

	Ingo
