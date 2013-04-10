Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935834Ab3DJMZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:25:32 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:46884 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3DJMZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:25:31 -0400
Date: Wed, 10 Apr 2013 14:25:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4] x86: FPU detection in C
Message-ID: <20130410122527.GB8686@gmail.com>
References: <1365436666-9837-1-git-send-email-bp@alien8.de>
 <20130410110840.GA29752@gmail.com>
 <20130410122411.GE13394@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410122411.GE13394@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Wed, Apr 10, 2013 at 01:08:40PM +0200, Ingo Molnar wrote:
> > Config attached.
> 
> How do you even build this? I tried tip:x86/cpu but it fails here:
> 
> drivers/misc/lkdtm.c: In function ???recursive_loop.constprop.3???:
> drivers/misc/lkdtm.c:276:1: warning: the frame size of 1028 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> In file included from /w/kernel/linux-2.6/arch/x86/include/asm/uaccess.h:537:0,
>                  from include/linux/uaccess.h:5,
>                  from include/linux/highmem.h:8,
>                  from include/linux/pagemap.h:10,
>                  from fs/binfmt_misc.c:27:
> /w/kernel/linux-2.6/arch/x86/include/asm/uaccess_32.h: In function ???parse_command.part.2???:
> /w/kernel/linux-2.6/arch/x86/include/asm/uaccess_32.h:211:26: error: call to ???copy_from_user_overflow??? declared with attribute error: copy_from_user() buffer size is not provably correct
> make[1]: *** [fs/binfmt_misc.o] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [fs] Error 2
> make: *** Waiting for unfinished jobs....
> 
> because of CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y.

In my builds I disable that. So I'd suggest to disable that bit in the .config and 
retry.

Thanks,

	Ingo
