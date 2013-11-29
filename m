Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3K2Ksj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:48:39 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:53043 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753813Ab3K2Ksf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:48:35 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Fri, 29 Nov 2013 10:48:25 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jan Engelhardt <jengelh@inai.de>
Cc: daniel.vetter@ffwll.ch, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915: pipe state still does not match
Message-ID: <20131129104825.GE27806@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jan Engelhardt <jengelh@inai.de>, daniel.vetter@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LSU.2.11.1311271156060.20996@nerf07.vanv.qr>
 <20131127110836.GA6087@nuc-i3427.alporthouse.com>
 <alpine.LSU.2.11.1311282017400.4098@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1311282017400.4098@nerf07.vanv.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 09:08:45PM +0100, Jan Engelhardt wrote:
> On Wednesday 2013-11-27 12:08, Chris Wilson wrote:
> >On Wed, Nov 27, 2013 at 11:59:56AM +0100, Jan Engelhardt wrote:
> >> 
> >> Despite the i915/drm fixes added in v3.11.8, the X server still 
> >> terminates due to some pipe state bug in 3.11.9.
> >
> >X terminating is entirely unconnected with that *ERROR*.
> 
> Are you sure? Whenever X crashed, that inteldrv kernel message
> was showing up in dmesg.
> Affected versions:
> 	xorg-x11-server-1.14.3.901
> 	xf86-video-intel-2.99.906-4.1.x86_64
> Working versions:
> 	xorg-x11-server-1.13.2
> 	xf86-video-intel-2.20.19
> 
> >Can you please attach your Xorg.0.log with the crash information?
> 
> What I could collect so far:

Thanks, I broke the handling of cropped XvImages along the fast paths.
It should be fixed by:

commit fd007d9d465b9b3ddbbaf769931ec921a6f5ecb8
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Nov 28 21:13:33 2013 +0000

    sna/video: Correct handling of cropped images along packed fast path
    
    In particular, it was offseting the read from the source image, but not
    correcting the length to read - causing a read from beyond the end of
    the source and a segfault.
    
    Reported-by: Jan Engelhardt <jengelh@inai.de>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
