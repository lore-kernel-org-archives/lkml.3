Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3GTSCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 14:02:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37663 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901Ab3GTSCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 14:02:04 -0400
X-Sasl-enc: 7FJBIwiMLtzx0aF0cZJcP+DNZkj/nUs1Be+hQ3yGfNVF 1374343321
Date: Sat, 20 Jul 2013 11:02:10 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: compile error on 3.10.1
Message-ID: <20130720180210.GA6190@kroah.com>
References: <36183925.Z4AeQk3t4j@balsa>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36183925.Z4AeQk3t4j@balsa>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 09:59:57AM -0600, Thomas Fjellstrom wrote:
> Hi, just trying to compile a vanilla kernel and building using
> allmodconfig and using oldconfig with the debian 3.10.1 config as a base.
> 
> With the later config, I get the following:

Is this new to 3.10.1 and works fine for 3.10.0? 

>   CC [M]  drivers/net/wireless/ath/wil6210/debugfs.o
> drivers/net/wireless/ath/wil6210/debugfs.c: In function âwil_print_ringâ:
> drivers/net/wireless/ath/wil6210/debugfs.c:163:11: error: pointer targets in 
> passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-
> Werror=pointer-sign]
>            false);
>            ^
> In file included from include/linux/kernel.h:13:0,
>                  from include/linux/cache.h:4,
>                  from include/linux/time.h:4,
>                  from include/linux/stat.h:18,
>                  from include/linux/module.h:10,
>                  from drivers/net/wireless/ath/wil6210/debugfs.c:17:
> include/linux/printk.h:361:13: note: expected âchar *â but argument is of type 
> âunsigned char *â
>  extern void hex_dump_to_buffer(const void *buf, size_t len,
>              ^
> drivers/net/wireless/ath/wil6210/debugfs.c: In function 
> âwil_txdesc_debugfs_showâ:
> drivers/net/wireless/ath/wil6210/debugfs.c:429:10: error: pointer targets in 
> passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-
> Werror=pointer-sign]
>           sizeof(printbuf), false);
>           ^
> In file included from include/linux/kernel.h:13:0,
>                  from include/linux/cache.h:4,
>                  from include/linux/time.h:4,
>                  from include/linux/stat.h:18,
>                  from include/linux/module.h:10,
>                  from drivers/net/wireless/ath/wil6210/debugfs.c:17:
> include/linux/printk.h:361:13: note: expected âchar *â but argument is of type 
> âunsigned char *â
>  extern void hex_dump_to_buffer(const void *buf, size_t len,
>              ^
> cc1: all warnings being treated as errors
> make[5]: *** [drivers/net/wireless/ath/wil6210/debugfs.o] Error 1
> make[4]: *** [drivers/net/wireless/ath/wil6210] Error 2
> make[3]: *** [drivers/net/wireless/ath] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> There are also a bunch of warnings, most of the ones I could catch are
> signedness related.

Care to send this to the atheros wireless developers?  I'm sure they
would like to know about it.

greg k-h
