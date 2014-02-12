Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaBLWAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:00:25 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39401 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaBLWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:00:21 -0500
Date: Wed, 12 Feb 2014 14:00:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: fix two sparse warnings in early boot string
 handling
In-Reply-To: <52FB9807.40706@windriver.com>
Message-ID: <alpine.DEB.2.02.1402121357450.27082@chino.kir.corp.google.com>
References: <1392143619-11453-1-git-send-email-paul.gortmaker@windriver.com> <alpine.DEB.2.02.1402111425430.32020@chino.kir.corp.google.com> <20140212020010.GB21033@windriver.com> <alpine.DEB.2.02.1402111821510.13509@chino.kir.corp.google.com>
 <52FB8BEB.5020506@windriver.com> <52FB9807.40706@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Paul Gortmaker wrote:

> Actually no v2 pending.  The original v1 patch was/is correct as-is.
> 
> While x86-64 defconfig passed, it turns out that both strcmp and strstr
> have to stay, else we will get this on i386 allyesconfig builds:
> 
> arch/x86/boot/compressed/eboot.o: In function `handle_cmdline_files.isra.5.constprop.6':
> eboot.c:(.text+0x4cf): undefined reference to `strstr'
> eboot.c:(.text+0x601): undefined reference to `strstr'
> make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
> 

This means there is a strstr() prototype that is visible to 
drivers/firmware/efi/efi-stub-helper.c but fails at linkage because you've 
removed the definition.  So, again, why would you add a duplicate 
prototype with your patch?

> arch/x86/boot/edd.o: In function `query_edd':
> arch/x86/boot/edd.c:136: undefined reference to `strcmp'
> arch/x86/boot/edd.c:136: undefined reference to `strcmp'
> arch/x86/boot/edd.c:140: undefined reference to `strcmp'
> arch/x86/boot/edd.c:142: undefined reference to `strcmp'
> make[1]: *** [arch/x86/boot/setup.elf] Error 1
> 
> So my gut feeling was right after all.  ;)
> 

I'm not sure what strcmp has to do with this.
