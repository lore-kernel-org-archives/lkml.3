Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaKLNHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:07:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55299 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbaKLNHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:07:42 -0500
Date: Wed, 12 Nov 2014 13:07:35 +0000
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: core: export function to check if regulator
	always on
Message-ID: <20141112130735.GA16426@opensource.wolfsonmicro.com>
References: <20141112111835.GA12635@opensource.wolfsonmicro.com> <20141112113541.GD3815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112113541.GD3815@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:35:41AM +0000, Mark Brown wrote:
> On Wed, Nov 12, 2014 at 11:18:35AM +0000, Richard Fitzgerald wrote:
> > Export a function to allow a consumer to check if its supply
> > regulator is always on. Drivers might wish to take different
> > action based on this - for example skipping time-consuming
> > power-saving preparations that are irrelevant if the regulator
> > cannot be disabled.
> 
> I'd like to see a user here,

The user will be the Arizona codec drivers but I wanted to upstream
this patch first for discussion.


> and I'd also like to understand why this is
> a better approach than using a callback to postpone these expensive
> operations until the regulator is actually powered off like we already
> do for some things like register cache resyncs.  That is normally better
> since it also avoids the work in cases where the regulator isn't always
> on like reenabling during a delayed powerdown or shared regulators.
> 

The runtime_suspend() for the Arizona drivers has to do a bunch of
preparation before disabling the DCVDD regulator (and there's more
preparation steps that need to be upstreamed). There's no point doing
any of this if at the end the regulator isn't going to switch off.

> You're also missing a !CONFIG_REGULATOR stub.

It's there at the end of the patch, returning 1.
