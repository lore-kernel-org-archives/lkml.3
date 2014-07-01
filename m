Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbaGANvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:51:47 -0400
Received: from mail001.aei.ca ([206.123.6.130]:40601 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbaGANvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:51:45 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [PATCH 5/5] drm/i915: Kick out vga console
Date: Tue, 01 Jul 2014 09:51:42 -0400
Message-ID: <2103506.7Srdik8cGn@grover>
Organization: me
User-Agent: KMail/4.13.2 (Linux/3.16.0-1-git; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140630065955.GD7687@nuc-i3427.alporthouse.com>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch> <3945293.Jtp4nyZMfX@grover> <20140630065955.GD7687@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

I had to rediff to get a patch that applies...  I am not hanging with this applied - it
does look like the i915 is starting is initialization later boot the new kernel.

[    2.389796] [drm] Radeon Display Connectors
[    2.389798] [drm] Connector 0:
[    2.389799] [drm]   DP-1
[    2.389799] [drm]   HPD2
[    2.389801] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
[    2.389802] [drm]   Encoders:
[    2.389803] [drm]     DFP1: INTERNAL_UNIPHY2
[    2.389804] [drm] Connector 1:
[    2.389805] [drm]   HDMI-A-1
[    2.389805] [drm]   HPD3
[    2.389806] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
[    2.389807] [drm]   Encoders:
[    2.389808] [drm]     DFP2: INTERNAL_UNIPHY2
[    2.389809] [drm] Connector 2:
[    2.389810] [drm]   DVI-D-1
[    2.389811] [drm]   HPD1
[    2.389812] [drm]   DDC: 0x6560 0x6560 0x6564 0x6564 0x6568 0x6568 0x656c 0x656c
[    2.389813] [drm]   Encoders:
[    2.389814] [drm]     DFP3: INTERNAL_UNIPHY1
[    2.389815] [drm] Connector 3:
[    2.389815] [drm]   DVI-I-1
[    2.389816] [drm]   HPD6
[    2.389817] [drm]   DDC: 0x6580 0x6580 0x6584 0x6584 0x6588 0x6588 0x658c 0x658c
[    2.389818] [drm]   Encoders:
[    2.389819] [drm]     DFP4: INTERNAL_UNIPHY
[    2.389820] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    2.435689] raid6: avx2x2   24564 MB/s
[    2.435691] Switched to clocksource tsc
[    2.489087] usb 1-8: new low-speed USB device number 7 using xhci_hcd
[    2.492403] raid6: avx2x4   34887 MB/s
[    2.492404] raid6: using algorithm avx2x4 (34887 MB/s)
[    2.492405] raid6: using avx2x2 recovery algorithm
[    2.492789] xor: automatically using best checksumming function:
[    2.502557] Adding 5779452k swap on /dev/sdb2.  Priority:-2 extents:1 across:5779452k FS
[    2.511532] [drm] fb mappable at 0xE098E000
[    2.511536] [drm] vram apper at 0xE0000000
[    2.511538] [drm] size 9216000
[    2.511539] [drm] fb depth is 24
[    2.511541] [drm]    pitch is 7680
[    2.511590] fbcon: radeondrmfb (fb0) is primary device
[    2.516691] nct6775: Found NCT6776D/F or compatible chip at 0x2e:0x290
[    2.525778]    avx       : 41474.400 MB/sec
[    2.532408] Console: switching to colour frame buffer device 240x75
[    2.535567] radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
[    2.535567] radeon 0000:01:00.0: registered panic notifier
[    2.544968] Btrfs loaded
[    2.545276] BTRFS: device fsid 9d4254aa-6715-4fa8-986a-1af0d51768ad devid 1 transid 308068 /dev/sdc1
[    2.545739] BTRFS: device fsid 9d4254aa-6715-4fa8-986a-1af0d51768ad devid 2 transid 308068 /dev/sdb1
[    2.552946] [drm] Initialized radeon 2.39.0 20080528 for 0000:01:00.0 on minor 0
[    2.553248] [drm] Memory usable by graphics device = 2048M
[    2.553273] [drm] Replacing VGA console driver
[    2.572539] i915 0000:00:02.0: irq 46 for MSI/MSI-X
[    2.572546] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.572565] [drm] Driver supports precise vblank timestamp query.

If you are happy with this you can give this patch my tested by.

Thanks
Ed Tomlinson

On Monday 30 June 2014 07:59:55 Chris Wilson wrote:
> On Sat, Jun 28, 2014 at 11:55:19PM -0400, Ed Tomlinson wrote:
> > On Saturday 28 June 2014 15:28:22 Ed Tomlinson wrote:
> > 
> > Resend without html krud which causes list to bounce the message.
> > 
> > > Hi
> > > 
> > > This commit ( a4de05268e674e8ed31df6348269e22d6c6a1803 ) hangs my boot with 3.16-git.  Reverting it lets the boot proceed. 
> > > 
> > > I have an i7 with a built-in i915 and an pcie r7 260x.  The R7 is the primary console.  The i915 is initialized
> > > but does not have a physical display attached.
> > > 
> > > With the patch applied the boot stops at the messages:
> > > 
> > > [drm] Memory usable by graphics device = 2048M
> > > [drm] Replacing VGA console driver
> 
> The issue looks like that we are ripping out the radeon fb_con whilst it
> is active and that upsets everyone. In which case, I think the
> compromise is:
> 
> 
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 5f44581..4915f1d 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1439,18 +1439,20 @@ static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
>  #else
>  static int i915_kick_out_vgacon(struct drm_i915_private *dev_priv)
>  {
> -       int ret;
> +       int ret = 0;
>  
>         DRM_INFO("Replacing VGA console driver\n");
>  
>         console_lock();
> -       ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
> -       if (ret == 0) {
> -               ret = do_unregister_con_driver(&vga_con);
> -
> -               /* Ignore "already unregistered". */
> -               if (ret == -ENODEV)
> -                       ret = 0;
> +       if (con_is_bound(&vga_con)) {
> +               ret = do_take_over_console(&dummy_con, 0, MAX_NR_CONSOLES - 1, 1);
> +               if (ret == 0) {
> +                       ret = do_unregister_con_driver(&vga_con);
> +
> +                       /* Ignore "already unregistered". */
> +                       if (ret == -ENODEV)
> +                               ret = 0;
> +               }
>         }
>         console_unlock();
> 
> -Chris
> 
> 

