Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab3K3V2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 16:28:21 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:55404 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750975Ab3K3V2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 16:28:20 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Sat, 30 Nov 2013 21:28:10 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jan Engelhardt <jengelh@inai.de>
Cc: daniel.vetter@ffwll.ch, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915: pipe state still does not match
Message-ID: <20131130212810.GA12866@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jan Engelhardt <jengelh@inai.de>, daniel.vetter@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LSU.2.11.1311271156060.20996@nerf07.vanv.qr>
 <20131127110836.GA6087@nuc-i3427.alporthouse.com>
 <alpine.LSU.2.11.1311282017400.4098@nerf07.vanv.qr>
 <20131129104825.GE27806@nuc-i3427.alporthouse.com>
 <alpine.LSU.2.11.1311301727440.31825@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1311301727440.31825@nerf07.vanv.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 05:31:34PM +0100, Jan Engelhardt wrote:
> 
> On Friday 2013-11-29 11:48, Chris Wilson wrote:
> >> What I could collect so far:
> >
> >Thanks, I broke the handling of cropped XvImages along the fast paths.
> >It should be fixed by:
> >
> >commit fd007d9d465b9b3ddbbaf769931ec921a6f5ecb8
> >Author: Chris Wilson <chris@chris-wilson.co.uk>
> >Date:   Thu Nov 28 21:13:33 2013 +0000
> >
> >    sna/video: Correct handling of cropped images along packed fast path
> 
> I didn't manage to crash X within an hour, so that's commit is looking 
> good.
> 
> The kernel error message for i915 pipe state however still appears -
> namely, whenever the X server is terminating, including "reasonably
> proper" terminations induced with sending SIGTERM to the X process.
> Could it be that the i915 module does not handle sudden shutdowns
> (which however can occur at any time) of the /dev/dri/cardN file
> descriptor well enough?

I'd say it was just the KMS transition from the X mode to the fbcon mode
that triggers the inconsistent state warning. The warning is just that
the hardware state after the mode change does not match our expectations
- often this is a result of a buggy state readback, but sometimes it
does indicate a more severe bug in our mode programming.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
