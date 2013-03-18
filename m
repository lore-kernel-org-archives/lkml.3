Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3CRSgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:36:12 -0400
Received: from relay2.mail.vrmd.de ([81.28.224.28]:48980 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3CRSgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:36:09 -0400
X-Greylist: delayed 1023 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2013 14:36:09 EDT
Date: Mon, 18 Mar 2013 18:18:58 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] alpha: makefile: don't enforce small data model for
 kernel builds
Message-ID: <20130318181858.GB899@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: dl8bcu@dl8bcu.de, Will Deacon <will.deacon@arm.com>,
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
	Richard Henderson <rth@twiddle.net>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Matt Turner <mattst88@gmail.com>
References: <1363556926-21097-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363556926-21097-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Relay-User: dl8bcu@dl8bcu.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 09:48:46PM +0000, Will Deacon wrote:
> Due to all of the goodness being packed into today's kernels, the
> resulting image isn't as slim as it once was.
> 
> In light of this, don't pass -msmall-data to the tools, which results in
> link failures due to impossible relocations when compiling anything but
> the most trivial configurations.

I use the same patch locally for quite some time, so

Tested-by: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>

> 
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  arch/alpha/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
> index 4759fe7..2cc3cc5 100644
> --- a/arch/alpha/Makefile
> +++ b/arch/alpha/Makefile
> @@ -12,7 +12,7 @@ NM := $(NM) -B
>  
>  LDFLAGS_vmlinux	:= -static -N #-relax
>  CHECKFLAGS	+= -D__alpha__ -m64
> -cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
> +cflags-y	:= -pipe -mno-fp-regs -ffixed-8
>  cflags-y	+= $(call cc-option, -fno-jump-tables)
>  
>  cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4

-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
