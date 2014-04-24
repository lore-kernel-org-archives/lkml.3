Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaDXFvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:51:00 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:62825 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbaDXFu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:50:57 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 24 Apr 2014 06:50:23 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@jikos.cz>
Subject: Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
Message-ID: <20140424055023.GA31221@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Pavel Machek <pavel@ucw.cz>, Daniel Vetter <daniel.vetter@ffwll.ch>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jiri Kosina <jikos@jikos.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
 <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
 <20140423220952.GA3627@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423220952.GA3627@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 12:09:52AM +0200, Pavel Machek wrote:
> Hi!
> 
> > > After update to 3.15-rc2, only top 20% of screen works on X.
> > >
> > > 00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset
> > > Integrated Graphics Controller (rev 03)
> > >
> > > 00:02.1 Display controller: Intel Corporation 4 Series Chipset
> > > Integrated Graphics Controller (rev 03)
> > >            Subsystem: Intel Corporation Device d614
> > >            Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > >            ParErr- Stepping- SERR- FastB2B- DisINTx-
> > >            Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast
> > >            >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> > >            Latency: 0
> > >            Region 0: Memory at d0400000 (64-bit, non-prefetchable)
> > >            [size=1M]
> > >            Capabilities: <access denied>
> > >
> > > This worked before. I believe it worked in 3.14. It definitely works
> > > in 3.11-rc2.
> > 
> > Screenshot or more detailed description of what "only top 20% of
> > screen works in X" means?
> > Anything in dmesg?
> 
> Actually yes, dmesg suggests it is quite
> sick. drivers/gpu/drm/drm_mm.c:767 warning triggered
> repeatedly. Also.. initial framebuffer does not work ; I don't seem to
> see anything before X start up. (This is Debian 6.0.9)

That says that i915.ko failed to initialise the GPU (or rather the GPU
wasn't responding) and bailed during module load. The key line here is

[drm:init_ring_common] *ERROR* render ring initialization failed ctl
0001f001 head 00002034 tail 00000000 start 0012f000

Jiri has been seeing a similar issue creep in during resume, but it is
not reliable enough to bisect. Is your boot failure reliable enough to
bisect? Also drm-intel-nightly should mitigate this failure and allow
i915.ko to continue to load and run X, which would be worth testing to
make sure that works as intended.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
