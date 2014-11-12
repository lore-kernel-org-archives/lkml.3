Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaKLQ7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:59:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55858 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957AbaKLQ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:59:03 -0500
Date: Wed, 12 Nov 2014 16:58:56 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: core: export function to check if regulator
	always on
Message-ID: <20141112165856.GA30010@opensource.wolfsonmicro.com>
References: <20141112111835.GA12635@opensource.wolfsonmicro.com> <20141112113541.GD3815@sirena.org.uk> <20141112130735.GA16426@opensource.wolfsonmicro.com> <20141112145802.GK3815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112145802.GK3815@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:58:02PM +0000, Mark Brown wrote:
> On Wed, Nov 12, 2014 at 01:07:35PM +0000, Richard Fitzgerald wrote:
> > On Wed, Nov 12, 2014 at 11:35:41AM +0000, Mark Brown wrote:
> 
> > > I'd like to see a user here,
> 
> > The user will be the Arizona codec drivers but I wanted to upstream
> > this patch first for discussion.
> 
> My point is that the code using the API is useful input to the
> discussion.
> 

Ok, I'll push up a patch showing what I'm intending to do with this
new function

> > > and I'd also like to understand why this is
> > > a better approach than using a callback to postpone these expensive
> > > operations until the regulator is actually powered off like we already
> > > do for some things like register cache resyncs.  That is normally better
> > > since it also avoids the work in cases where the regulator isn't always
> > > on like reenabling during a delayed powerdown or shared regulators.
> 
> > The runtime_suspend() for the Arizona drivers has to do a bunch of
> > preparation before disabling the DCVDD regulator (and there's more
> > preparation steps that need to be upstreamed). There's no point doing
> > any of this if at the end the regulator isn't going to switch off.
> 
> I'm not sure that this addresses my concern about postponing the
> expensive work until the regulator is actually powered off at all?
> 

The point is that the work we want to avoid has to happen while the
regulator is still powered up. We can't just rip power from the codec,
it has to be setup ready for the DCVDD to be turned off. So it's
pre-power down work we're avoiding by knowing that a power-down will
never actually happen, it's not post-power-down work.
But as you say the code that's going to use it will help explain.


> > > You're also missing a !CONFIG_REGULATOR stub.
> 
> > It's there at the end of the patch, returning 1.
> 
> Bah, so it is.


