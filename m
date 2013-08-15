Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335Ab3HOGa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:30:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3HOGaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:30:25 -0400
Date: Wed, 14 Aug 2013 23:31:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.4.58-stable review
Message-ID: <20130815063158.GB25754@kroah.com>
References: <20130813063501.728847844@linuxfoundation.org>
 <520A1D56.2050507@roeck-us.net>
 <20130813175858.GC7336@kroah.com>
 <20130813201936.GA18358@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813201936.GA18358@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 01:19:36PM -0700, Guenter Roeck wrote:
> I copied the individual log files for the 3.4 build to http://roeck-us.net/linux/logs
> in case you want to browse through it.
> 
> Here is a summary.
> 
> mips/allmodconfig:
> drivers/net/ethernet/3com/3c59x.c: In function 'vortex_init_one':
> drivers/net/ethernet/3com/3c59x.c:1031:2: error: implicit declaration of function 'pci_iomap' 
> 
> We have seen that before in 3.10. Commit 78857614104 (MIPS: Expose
> missing pci_io{map,unmap} declarations) fixes it.

Now applied.

> sound/oss/soundcard.c:69:31: error: 'MAX_DMA_CHANNELS' undeclared here (not in a function)
> 
> This requires 
> d4702b189c sound: Fix make allmodconfig on MIPS
> a62ee234a5 sound: Fix make allmodconfig on MIPS correctly

Now applied.

> Unfortunately, after applying those patches the build still fails with
> 
> ERROR: "min_low_pfn" [drivers/net/wireless/ath/ath6kl/ath6kl_sdio.ko] undefined!
> 
> This has been fixed upstream with commit 8b9232141b (MIPS: Rewrite pfn_valid to work
> in modules, too), which applies but results in build failures.

What failures?  I've applied this now, as it makes sense.

> There is a patch from Ben Hutchings which removes the use of
> virt_addr_valid() (which causes the problem) from the ath6kl driver,
> but that is not in mainline.

Ok, I think I'll stop there for MIPS, that's a good start...

> microblaze/mmu_defconfig:
> build/scripts/gen_initramfs_list.sh: Cannot open 'rootfs.cpio'
> make[1]: *** [usr/initramfs_data.cpio.gz] Error 1
> make: *** [usr] Error 2
> 
> CONFIG_INITRAMFS_SOURCE=rootfs.cpio in the config file probably
> isn't such a good idea.
> 
> Upstream commit d0e045401f26 (microblaze: Update microblaze defconfigs)
> addresses this problem, but it can not be applied directly. It defines
> CONFIG_HIGHMEM=y, CONFIG_PCI=y, and CONFIG_PCI_XILINX=y, which do
> not build in 3.4. It builds successfully if I apply d0e045401f26
> and remove those three definitions.

I've now done that, thanks.

greg k-h
