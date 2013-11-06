Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3KFVF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:05:28 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:35951 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3KFVF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:05:27 -0500
Date: Wed, 6 Nov 2013 22:05:21 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] avr32: Remove HAVE_KPROBES from avr32 Kconfig
Message-ID: <20131106210520.GA6825@samfundet.no>
References: <20131106124330.4d73d200@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106124330.4d73d200@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 06 Nov 2013 12:43:30 -0500 or thereabout, Steven Rostedt wrote:

Hello,

> Although there's a arch/avr32/kernel/kprobes.c file, this arch does not
> compile with kprobes enabled:
> 
>  In file included from cross-linux.git/arch/avr32/kernel/kprobes.c:14:
>  cross-linux.git/include/linux/kprobes.h: In function 'get_kprobe_ctlblk':
>  cross-linux.git/include/linux/kprobes.h:358: error: invalid use of undefined type 'struct kprobe_ctlblk'
>  cross-linux.git/include/linux/kprobes.h:358: error: dereferencing pointer to incomplete type
>  make[2]: *** [arch/avr32/kernel/kprobes.o] Error 1
> 
> This is because it does not define the required kprobe_ctlblk struct,
> and fails to compile when CONFIG_KPROBES is set.
> 
> Unfortunately, this also makes my testing of various configs for
> different archs to fail on avr32 as well.
> 
> If kprobes is not supported by avr32 than do not say that it is.

kprobes is supposed to be supported on AVR32, but it seems to have broken
somewhere down the road.

I re-discovered an old patch fixing this from Eirik, I have added this to my
for-linus branch instead of your proposed patch.

https://git.kernel.org/cgit/linux/kernel/git/egtvedt/linux-avr32.git/log/?h=for-linus

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
> index b6878eb..25bcc62 100644
> --- a/arch/avr32/Kconfig
> +++ b/arch/avr32/Kconfig
> @@ -5,7 +5,6 @@ config AVR32
>  	select EXPERT
>  	select HAVE_CLK
>  	select HAVE_OPROFILE
> -	select HAVE_KPROBES
>  	select VIRT_TO_BUS
>  	select GENERIC_IRQ_PROBE
>  	select GENERIC_ATOMIC64
-- 
mvh
Hans-Christian Egtvedt
