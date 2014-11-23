Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaKWT5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:57:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49868 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaKWT5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:57:11 -0500
Date: Sun, 23 Nov 2014 20:57:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Clayton <chris2553@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Junjie Mao <eternal.n08@gmail.com>, Kees Cook <keescook@chromium.org>,
        x86-ml <x86@kernel.org>
Subject: Re: [PATCH]: cross-compiling x86_64 kernel on i386 user-space fails
Message-ID: <20141123195708.GA7355@pd.tnic>
References: <54705C8E.1080400@googlemail.com>
 <20141122111444.GA12445@pd.tnic>
 <alpine.DEB.2.11.1411232020020.6439@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411232020020.6439@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 08:27:24PM +0100, Thomas Gleixner wrote:
> While that works, this wants to be:
> 
> +RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \

Ah, true:

$ git grep OBJDUMP Makefile
Makefile:363:OBJDUMP            = $(CROSS_COMPILE)objdump
Makefile:420:export CPP AR NM STRIP OBJCOPY OBJDUMP
Makefile:1483:  $(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
