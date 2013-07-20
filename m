Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3GTSk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 14:40:27 -0400
Received: from mail.tomasu.net ([64.85.170.232]:36304 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab3GTSk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 14:40:26 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: compile error on 3.10.1
Date: Sat, 20 Jul 2013 12:39:34 -0600
Message-ID: <4042881.r0jf4IMbXO@balsa>
User-Agent: KMail/4.10.5 (Linux/3.9-1-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2288831.DxHLOohu6v@balsa>
References: <36183925.Z4AeQk3t4j@balsa> <20130720180210.GA6190@kroah.com> <2288831.DxHLOohu6v@balsa>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 20 July 2013 12:07:03 Thomas Fjellstrom wrote:
> On Sat 20 July 2013 11:02:10 you wrote:
> > On Sat, Jul 20, 2013 at 09:59:57AM -0600, Thomas Fjellstrom wrote:
> > > Hi, just trying to compile a vanilla kernel and building using
> > > allmodconfig and using oldconfig with the debian 3.10.1 config as a
> > > base.
> > 
> > > With the later config, I get the following:
> > Is this new to 3.10.1 and works fine for 3.10.0?
> 
> I'll check.
> 
> All I've tested so far is debian's 2.6.32, 3.9.8, 3.10.1, and a vanilla
> 3.10.1 (with allmodconfig and oldconfig+debian config).

I meant to say I only tried 3.10.1... I'm getting this and my last email 
confused a little.

Just tested the v3.10 tag from the stable repo and it exhibits the same 
problem.

> > >   CC [M]  drivers/net/wireless/ath/wil6210/debugfs.o
> > > 
> > > drivers/net/wireless/ath/wil6210/debugfs.c: In function
> > > âwil_print_ringâ:
> > > drivers/net/wireless/ath/wil6210/debugfs.c:163:11: error: pointer
> > > targets
> 
> in
> 
> > > passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-
> > > Werror=pointer-sign]
> > > 
> > >            false);
> > >            ^
> > > 
> > > In file included from include/linux/kernel.h:13:0,
> > > 
> > >                  from include/linux/cache.h:4,
> > >                  from include/linux/time.h:4,
> > >                  from include/linux/stat.h:18,
> > >                  from include/linux/module.h:10,
> > > 
> > >                  from drivers/net/wireless/ath/wil6210/debugfs.c:17:
> > > include/linux/printk.h:361:13: note: expected âchar *â but argument is
> > > of
> 
> type
> 
> > > âunsigned char *â
> > > 
> > >  extern void hex_dump_to_buffer(const void *buf, size_t len,
> > >  
> > >              ^
> > > 
> > > drivers/net/wireless/ath/wil6210/debugfs.c: In function
> > > âwil_txdesc_debugfs_showâ:
> > > drivers/net/wireless/ath/wil6210/debugfs.c:429:10: error: pointer
> > > targets
> 
> in
> 
> > > passing argument 5 of âhex_dump_to_bufferâ differ in signedness [-
> > > Werror=pointer-sign]
> > > 
> > >           sizeof(printbuf), false);
> > >           ^
> > > 
> > > In file included from include/linux/kernel.h:13:0,
> > > 
> > >                  from include/linux/cache.h:4,
> > >                  from include/linux/time.h:4,
> > >                  from include/linux/stat.h:18,
> > >                  from include/linux/module.h:10,
> > > 
> > >                  from drivers/net/wireless/ath/wil6210/debugfs.c:17:
> > > include/linux/printk.h:361:13: note: expected âchar *â but argument is
> > > of
> 
> type
> 
> > > âunsigned char *â
> > > 
> > >  extern void hex_dump_to_buffer(const void *buf, size_t len,
> > >  
> > >              ^
> > > 
> > > cc1: all warnings being treated as errors
> > > make[5]: *** [drivers/net/wireless/ath/wil6210/debugfs.o] Error 1
> > > make[4]: *** [drivers/net/wireless/ath/wil6210] Error 2
> > > make[3]: *** [drivers/net/wireless/ath] Error 2
> > > make[2]: *** [drivers/net/wireless] Error 2
> > > make[1]: *** [drivers/net] Error 2
> > > make: *** [drivers] Error 2
> > > 
> > > There are also a bunch of warnings, most of the ones I could catch are
> > > signedness related.
> > 
> > Care to send this to the atheros wireless developers?  I'm sure they
> > would like to know about it.
> 
> Can do.

Done.

> > greg k-h
-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net
