Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3AWQmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:42:16 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:37766 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3AWQmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:42:14 -0500
Date: Wed, 23 Jan 2013 17:42:04 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-3.7.[1,4]: kmemleak in i801_probe
Message-ID: <20130123174204.00463f98@endymion.delvare>
In-Reply-To: <50FFC659.1090402@fold.natur.cuni.cz>
References: <50FFC659.1090402@fold.natur.cuni.cz>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Wed, 23 Jan 2013 12:15:37 +0100, Martin Mokrejs wrote:
> Hi,
>   I already reported this to lkml recently with linux-3.7.1 but this is to let you know
> that with 3.7.4 I am still getting this kmemleak reported by the kernel.

I don't read LKML.

> unreferenced object 0xffff88040b614690 (size 256):
>   comm "swapper/0", pid 1, jiffies 4294937573 (age 133834.550s)
>   hex dump (first 32 bytes):
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>     ff ff ff ff ff ff ff ff 08 7f 5d 82 ff ff ff ff  ..........].....
>   backtrace:
>     [<ffffffff815b4aad>] kmemleak_alloc+0x21/0x3e
>     [<ffffffff81110352>] slab_post_alloc_hook+0x28/0x2a
>     [<ffffffff8111288a>] __kmalloc+0xf2/0x104
>     [<ffffffff81305165>] kzalloc.constprop.14+0xe/0x10
>     [<ffffffff813055c6>] device_private_init+0x14/0x63
>     [<ffffffff813076a0>] dev_set_drvdata+0x19/0x2f
>     [<ffffffff815c4f5e>] i801_probe+0x5e/0x451
>     [<ffffffff81280e40>] local_pci_probe+0x39/0x61
>     [<ffffffff81281f53>] pci_device_probe+0xc6/0xf3
>     [<ffffffff81307c5d>] driver_probe_device+0xa9/0x1c1
>     [<ffffffff81307dcf>] __driver_attach+0x5a/0x7e
>     [<ffffffff8130650a>] bus_for_each_dev+0x57/0x83
>     [<ffffffff81307806>] driver_attach+0x19/0x1b
>     [<ffffffff813073d8>] bus_add_driver+0xa8/0x1fa
>     [<ffffffff81308241>] driver_register+0x8c/0x106
>     [<ffffffff81281b4e>] __pci_register_driver+0x59/0x5d

I am using the i2c-i801 driver, enabled kmemleak, but I don't get this
leak. Did you have to do anything special to get it? Didn't you get a
similar leak with older kernels? Do you get a similar leak (with
reference to dev_set_drvdata)?

I can see that dev_set_drvdata may allocate memory (which I didn't
know) and I admit I don't see where it gets released, however this is
all happening in the driver core and isn't specific to the i2c-i801
driver, so if there really is a leak there, you should see it in all
drivers.

-- 
Jean Delvare
