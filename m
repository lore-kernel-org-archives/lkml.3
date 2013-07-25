Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3GYPsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab3GYPsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:48:31 -0400
Date: Thu, 25 Jul 2013 11:47:46 -0400
From: Peter Jones <pjones@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemleak warning in efifb_probe
Message-ID: <20130725154745.GB25717@fenchurch.internal.datastacks.com>
References: <20130721151151.GK24717@sanechka.spb.ru>
 <CAHkRjk4Ansh+Xr+cPQNacwx=aOb65_hW_MNRx5QVtatJCz5tqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHkRjk4Ansh+Xr+cPQNacwx=aOb65_hW_MNRx5QVtatJCz5tqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 01:18:31PM +0100, Catalin Marinas wrote:
> On 21 July 2013 16:11, Alexandra N. Kossovsky
> <Alexandra.Kossovsky@oktetlabs.ru> wrote:
> > I am running linux-3.10.0 with kmemleak and see following warnings
> > in /sys/kernel/debug/kmemleak:
> >
> > unreferenced object 0xffff880216fcfe00 (size 512):
> >   comm "swapper/0", pid 1, jiffies 4294895429 (age 1415.320s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 aa aa aa aa aa aa aa aa  ................
> >     55 55 55 55 55 55 55 55 ff ff ff ff ff ff ff ff  UUUUUUUU........
> >   backtrace:
> >     [<ffffffff813e415c>] kmemleak_alloc+0x21/0x3e
> >     [<ffffffff8111c17f>] kmemleak_alloc_recursive.constprop.57+0x16/0x18
> >     [<ffffffff8111e63b>] __kmalloc+0xf9/0x144
> >     [<ffffffff8123d9cf>] fb_alloc_cmap_gfp+0x47/0xe1
> >     [<ffffffff8123da77>] fb_alloc_cmap+0xe/0x10
> >     [<ffffffff81aff40a>] efifb_probe+0x3e9/0x48f
> >     [<ffffffff812c566f>] platform_drv_probe+0x34/0x5e
> >     [<ffffffff812c3e6d>] driver_probe_device+0x98/0x1b4
> >     [<ffffffff812c3fd7>] __driver_attach+0x4e/0x6f
> >     [<ffffffff812c25bf>] bus_for_each_dev+0x57/0x8a
> >     [<ffffffff812c3984>] driver_attach+0x19/0x1b
> >     [<ffffffff812c362b>] bus_add_driver+0xde/0x201
> >     [<ffffffff812c453f>] driver_register+0x8c/0x110
> >     [<ffffffff812c510d>] platform_driver_register+0x41/0x43
> >     [<ffffffff812c5127>] platform_driver_probe+0x18/0x8a
> >     [<ffffffff81aff002>] efifb_init+0x276/0x295
> 
> Does the efifb driver has any way to deallocate the cmap? I don't see
> any explicit call to fb_dealloc_cmap() apart from the error handling.
> My theory is that the efifb driver gets deregistered via
> do_remove_conflicting_framebuffers(). I'm not familiar with this code,
> just commenting from a kmemleak perspective.

You're right, that's the typical deregister path.  I'll follow up with a
patch to test.

-- 
        Peter
