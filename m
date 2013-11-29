Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab3K2Hzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 02:55:40 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34929 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3K2Hzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 02:55:37 -0500
Date: Fri, 29 Nov 2013 08:56:17 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915: pipe state still does not match
Message-ID: <20131129075616.GS27344@phenom.ffwll.local>
Mail-Followup-To: Jan Engelhardt <jengelh@inai.de>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	dri-devel@lists.freedesktop.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LSU.2.11.1311271156060.20996@nerf07.vanv.qr>
 <20131127110836.GA6087@nuc-i3427.alporthouse.com>
 <alpine.LSU.2.11.1311282017400.4098@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1311282017400.4098@nerf07.vanv.qr>
X-Operating-System: Linux phenom 3.12.0+
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

For the ERROR the kernel is the important part. I can be that it's
triggered by userspace doing something funny (and likely, sinc there's a
good chance you're hitting a less well tested path when crashing). But
it's a kernel issue.

To track the kernel issue down can you please boot with drm.debug=0xe
added to your bootline, reproduce the issue and then attach the complete
dmesg?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
