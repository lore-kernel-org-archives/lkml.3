Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946Ab3HSODQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:03:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab3HSODO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:03:14 -0400
Date: Mon, 19 Aug 2013 10:02:45 -0400
From: Peter Jones <pjones@redhat.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] Release efifb's colormap in efifb_destroy()
Message-ID: <20130819140244.GD32575@fenchurch.internal.datastacks.com>
References: <CAHkRjk4Ansh+Xr+cPQNacwx=aOb65_hW_MNRx5QVtatJCz5tqg@mail.gmail.com>
 <1374767291-2874-1-git-send-email-pjones@redhat.com>
 <CANq1E4Sf7o2ct3np0F11k0B=03UL0P=qZOUCUBM2fKuRDrHXbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANq1E4Sf7o2ct3np0F11k0B=03UL0P=qZOUCUBM2fKuRDrHXbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 03:51:34PM +0200, David Herrmann wrote:
> Hi
> 
> On Thu, Jul 25, 2013 at 5:48 PM, Peter Jones <pjones@redhat.com> wrote:
> > This was found by Alexandra Kossovsky, who noted this traceback from
> > kmemleak:
> >
> >> unreferenced object 0xffff880216fcfe00 (size 512):
> >>   comm "swapper/0", pid 1, jiffies 4294895429 (age 1415.320s)
> >>   hex dump (first 32 bytes):
> >>     00 00 00 00 00 00 00 00 aa aa aa aa aa aa aa aa  ................
> >>     55 55 55 55 55 55 55 55 ff ff ff ff ff ff ff ff  UUUUUUUU........
> >>   backtrace:
> >>     [<ffffffff813e415c>] kmemleak_alloc+0x21/0x3e
> >>     [<ffffffff8111c17f>]
> >>     kmemleak_alloc_recursive.constprop.57+0x16/0x18
> >>     [<ffffffff8111e63b>] __kmalloc+0xf9/0x144
> >>     [<ffffffff8123d9cf>] fb_alloc_cmap_gfp+0x47/0xe1
> >>     [<ffffffff8123da77>] fb_alloc_cmap+0xe/0x10
> >>     [<ffffffff81aff40a>] efifb_probe+0x3e9/0x48f
> >>     [<ffffffff812c566f>] platform_drv_probe+0x34/0x5e
> >>     [<ffffffff812c3e6d>] driver_probe_device+0x98/0x1b4
> >>     [<ffffffff812c3fd7>] __driver_attach+0x4e/0x6f
> >>     [<ffffffff812c25bf>] bus_for_each_dev+0x57/0x8a
> >>     [<ffffffff812c3984>] driver_attach+0x19/0x1b
> >>     [<ffffffff812c362b>] bus_add_driver+0xde/0x201
> >>     [<ffffffff812c453f>] driver_register+0x8c/0x110
> >>     [<ffffffff812c510d>] platform_driver_register+0x41/0x43
> >>     [<ffffffff812c5127>] platform_driver_probe+0x18/0x8a
> >>     [<ffffffff81aff002>] efifb_init+0x276/0x295
> 
> (CC'ing fbdev maintainers)
> 
> Your signed-off-by is missing. Apart from that:
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Indeed it is.  With that in mind:

Signed-off-by: Peter Jones <pjones@redhat.com>

> 
> Regards
> David
> 
> > ---
> >  drivers/video/efifb.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
> > index 390b61b..1f3eab3 100644
> > --- a/drivers/video/efifb.c
> > +++ b/drivers/video/efifb.c
> > @@ -289,6 +289,7 @@ static void efifb_destroy(struct fb_info *info)
> >         if (request_mem_succeeded)
> >                 release_mem_region(info->apertures->ranges[0].base,
> >                                    info->apertures->ranges[0].size);
> > +       fb_dealloc_cmap(&info->cmap);
> >         framebuffer_release(info);
> >  }
> >
> > --
> > 1.8.3.1
> >
> > --

-- 
        Peter
