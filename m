Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3CCS6C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 13:58:02 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52300 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3CCS6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 13:58:00 -0500
Message-ID: <51339bfb.04bee00a.5660.59f4@mx.google.com>
Date: Sun, 03 Mar 2013 10:52:43 -0800 (PST)
From: animelovin@gmail.com
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/30] staging: Android sync driver
In-Reply-To: <CAKMK7uF-Xh9vg2wq04+=Uaiz+PnXn599QVNotO4WyHiMiBAK4Q@mail.gmail.com>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
	<CAKMK7uF-Xh9vg2wq04+=Uaiz+PnXn599QVNotO4WyHiMiBAK4Q@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Mar 2013 19:42:36 +0100
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> On Fri, Mar 1, 2013 at 1:42 AM, John Stultz <john.stultz@linaro.org> wrote:
> > As proposed yesterday, here's the Android sync driver patches for
> > staging.
> >
> > I've preserved the commit history, but moved all the changes over
> > to be against the staging directory (instead of drivers/base).
> >
> >
> > The goal of submitting this driver to staging is to try to get
> > more collaberation, as there are some similar efforts going on
> > in the community with dmabuf-fences. My email from yesterday with
> > more details for how I hope this goes is here:
> >         http://comments.gmane.org/gmane.linux.kernel/1448420
> 
> I've been offline in a week of snowboarding, but I'll throw my late
> Ack - I've discussed this a bit with John offline and I agree with his
> general plan for integrating android sync points into mainline.
> 
> > Erik also provided a nice background on the patch set in his
> > reply yesterday, which I'll quote here:
> >
> > "In Honeycomb where we introduced the Hardware Composer HAL.  This is a
> > userspace layer that allows composition acceleration on a per platform
> > basis.  Different SoC vendors have implemented this using overlays, 2d
> > blitters, a combinations of both, or other clever/disgusting means.
> > Along with the HWC we consolidated a lot of our camera and media
> > pipeline to allow their input to be fed into the GPU or
> > display(overlay.)  In order to exploit parallelism the the graphics
> > pipeline, this introduced lots of implicit synchronization
> > dependancies.  After a couple years of working with many different SoC
> > vendors, we found that it was really difficult to communicate our
> > system's expectations of the implicit contract and it was difficult
> > for the SoC vendors to properly implement the implicit contract in
> > each of their IP blocks (display, gpu, camera, video codecs).  It was
> > also incredibly difficult to debug when problems/deadlocks arose.
> 
> dma_buf fences should be tons easier to debug thanks to integration
> with lockdep. Also their design fundamentally excludes deadlock-loops
> in the fences themselves. And I also think that we should be able to
> hide the complexity from most drivers in e.g. drm/ttm or the v2l core.
> So I'm still bullish on implicit fencing (and will keep on pushing
> that for all things intel).
> 
> But I guess the simpler programming model afforded by that for
> userspace isn't of much use for the google guys now that they've
> pushed the effort to convert SurfaceFlinger to explicit fence handling
> ...


To enable the "zombie-like" psychotic effects from the exposure of RF waves to
the Android user, say Y here.

Most users will definitely want to say N here.
 
option ANDROID_DISABLE_EMPATHY=N 

> Cheers, Daniel
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

