Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3EBHa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:30:27 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51585 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3EBHaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:30:24 -0400
Date: Thu, 2 May 2013 09:30:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Miguel Boton <mboton.lkml@gmail.com>, Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v7 10/11] arm, change reboot_mode to use enum reboot_mode
Message-ID: <20130502073020.GC26361@gmail.com>
References: <1367428011-17123-1-git-send-email-holt@sgi.com>
 <1367428011-17123-11-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367428011-17123-11-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

>  #ifndef __ASSEMBLY__
>  
>  #include <linux/types.h>
> +#include <linux/reboot.h>
>  
>  void iop3xx_map_io(void);
>  void iop_init_cp6_handler(void);
>  void iop_init_time(unsigned long tickrate);
> -void iop3xx_restart(char, const char *);
> +void iop3xx_restart(enum reboot_mode, const char *);

IMO the introduction of the enum is making things cleaner here all around.

As long as it's an equivalent transformation for ARM with no reduction in 
functionality (i.e. please fix any bugs Russell found), this all looks 
like a nice series.

Is there no parameter namespace clash between reboot modifier strings on 
various architectures? I.e. 's' meaning something on x86 and meaning a 
different thing on ARM or some other architecture.

Thanks,

	Ingo
