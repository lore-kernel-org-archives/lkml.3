Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaGTTnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:43:31 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58714 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008AbaGTTn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:43:29 -0400
X-Sasl-enc: Pah2aG4GaubSdUbi9Q0o5do7JTcITvxSD/BsYi1mJdKM 1405885408
Date: Sun, 20 Jul 2014 12:43:27 -0700
From: Greg KH <gregkh@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: davem@davemloft.net, sachin.kamat@linaro.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: staging/8821ae driver breaks allyes build in 3.16-rc*
Message-ID: <20140720194327.GA11230@kroah.com>
References: <20140720190523.GL18735@two.firstfloor.org>
 <20140720192511.GA3120@kroah.com>
 <20140720193821.GA12357@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720193821.GA12357@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 12:38:21PM -0700, Greg KH wrote:
> On Sun, Jul 20, 2014 at 12:25:11PM -0700, Greg KH wrote:
> > On Sun, Jul 20, 2014 at 09:05:23PM +0200, Andi Kleen wrote:
> > > 
> > > Hi,
> > > 
> > > I cannot build make allyesconfig in current Linus mainline, because 
> > > drivers/staging/rtl8821ae has a lot of compile errors.
> > 
> > allyesconfig should turn off the staging drivers, how did you turn it
> > on?

Ok, that's odd, I thought we didn't build staging drivers for
allyesconfig, but you are right, we do.

Anyway...

> > > Please fix it in some way, allyesconfig should build!
> > 
> > It builds here for me, or at least I thought it did, let me go check...
> > 
> 
> I can't reproduce this here:
> 
> $ make M=drivers/staging/rtl8821ae/ clean
> $ make -j16
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CHK     kernel/config_data.h
>   LD      drivers/staging/rtl8821ae/built-in.o
>   CC [M]  drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.o
>   CC [M]  drivers/staging/rtl8821ae/btcoexist/halbtc8723b1ant.o
>   CC [M]  drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.o
>   CC [M]  drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.o
>   CC [M]  drivers/staging/rtl8821ae/btcoexist/rtl_btc.o
>   CC [M]  drivers/staging/rtl8821ae/base.o
>   CC [M]  drivers/staging/rtl8821ae/rc.o
>   CC [M]  drivers/staging/rtl8821ae/debug.o
>   CC [M]  drivers/staging/rtl8821ae/regd.o
>   CC [M]  drivers/staging/rtl8821ae/efuse.o
>   CC [M]  drivers/staging/rtl8821ae/cam.o
>   CC [M]  drivers/staging/rtl8821ae/ps.o
>   CC [M]  drivers/staging/rtl8821ae/core.o
>   CC [M]  drivers/staging/rtl8821ae/stats.o
>   CC [M]  drivers/staging/rtl8821ae/pci.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/hw.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/table.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/sw.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/trx.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/led.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/fw.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/phy.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/dm.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/pwrseq.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/rf.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/pwrseqcmd.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/hal_btc.o
>   CC [M]  drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.o
>   LD [M]  drivers/staging/rtl8821ae/rtl8821ae.o
>   CHK     include/generated/uapi/linux/version.h
>   Building modules, stage 2.
> Kernel: arch/x86/boot/bzImage is ready  (#46)
>   MODPOST 687 modules
>   CC      drivers/staging/rtl8821ae/rtl8821ae.mod.o
>   LD [M]  drivers/staging/rtl8821ae/rtl8821ae.ko
> 
> 
> Now that's with the "normal" config I build with, I'll go try a 'allyesconfig'
> now...

allyesconfig builds the staging directory just fine for me here, with
Linus's current tree:

$ git branch
 * master d057190925d9 Merge branch 'locking-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip


And gcc version:
$ gcc --version | head -n 1
gcc (GCC) 4.9.0 20140604 (prerelease)


Are you sure your tree is "clean" at the moment?

thanks,

greg k-h
