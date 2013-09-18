Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3IRO7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:59:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46844 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3IRO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:59:14 -0400
Message-ID: <5239BFB8.4020304@infradead.org>
Date: Wed, 18 Sep 2013 07:59:04 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Jeff P. Zacher" <ad_sicks@yahoo.com>
CC: linux-kernel@vger.kernel.org, linux-media <linux-media@vger.kernel.org>
Subject: Re: Dependency bug in the uvcvideo Kconfig
References: <1828294.VXnhqsmrEo@localhost>
In-Reply-To: <1828294.VXnhqsmrEo@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding linux-media mailing list]


On 09/18/13 06:18, Jeff P. Zacher wrote:
> Not subscribed, please CC'me in replies:
> 
> There seems to be a dependency bug in the Kconfig for the uvcvideo kernel 
> module.  If uvcvideo is built in and usb support is built as a module, the 
> kernel build will fail with the obviously missing dependanies.
> 
> 
> Error logs:
> 
> * ERROR: Failed to compile the "bzImage" target...
> * 
> * -- Grepping log... --
> * 
> *  SHIPPED scripts/genksyms/keywords.hash.c
> *  SHIPPED scripts/genksyms/parse.tab.h
> *  SHIPPED scripts/genksyms/parse.tab.c
> *  HOSTCC  scripts/genksyms/lex.lex.o
> *scripts/genksyms/lex.lex.c_shipped: In function ‘yylex1’:
> *scripts/genksyms/lex.lex.c_shipped:904:1: warning: ignoring return value of 
> ‘fwrite’, declared with attribute warn_unused_result [-Wunused-result]
> *--
> *  CC      drivers/video/console/font_8x16.o
> *  CC      drivers/video/console/softcursor.o
> *  CC      sound/core/seq/seq_memory.o
> *  CC      drivers/video/console/fbcondecor.o
> *  CC      sound/core/seq/seq_queue.o
> *drivers/video/console/fbcondecor.c:511:6: warning: function declaration isn’t 
> a prototype [-Wstrict-prototypes]
> *--
> *(.text+0xf8fb1): undefined reference to `usb_submit_urb'
> *drivers/built-in.o: In function `uvc_init':
> *uvc_driver.c:(.init.text+0x908a): undefined reference to 
> `usb_register_driver'
> *drivers/built-in.o: In function `uvc_cleanup':
> *uvc_driver.c:(.exit.text+0x67e): undefined reference to `usb_deregister'
> *make: *** [vmlinux] Error 1
> *--
> * Running with options: --lvm --menuconfig all
> * Using genkernel.conf from /etc/genkernel.conf
> * Sourcing arch-specific config.sh from 
> /usr/share/genkernel/arch/x86_64/config.sh ..
> * Sourcing arch-specific modules_load from 
> /usr/share/genkernel/arch/x86_64/modules_load ..
> *
> * ERROR: Failed to compile the "bzImage" target...
> * 
> * -- End log... --
> 
> Compiling uvc as a module allows the compilation to complete.
> 
> Platform x86_64
> 
> Ref: http://forums.gentoo.org/viewtopic-p-7398782.html#7398782
> 
> 
> -- Jeff P. Zacher
> ad_sicks@yahoo.com


-- 
~Randy
