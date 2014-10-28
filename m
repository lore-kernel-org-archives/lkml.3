Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaJ1E0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:26:36 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35718 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbaJ1E0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:26:33 -0400
Date: Mon, 27 Oct 2014 21:26:26 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: fsl_asrc: Add reg_defaults for regmap to fix
 kernel dump
Message-ID: <20141028042603.GA5548@Asurada>
References: <1414202637-18929-1-git-send-email-nicoleotsuka@gmail.com>
 <20141028001904.GH18557@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028001904.GH18557@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 12:19:04AM +0000, Mark Brown wrote:
> On Fri, Oct 24, 2014 at 07:03:57PM -0700, Nicolin Chen wrote:
> > Kernel dump (WARN_ON) ocurred during system boot-up inside regmap_write():
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 47 at kernel/locking/lockdep.c:2744 lockdep_trace_alloc+0xe8/0x108()

> > Even though this may be a bug that should be fixed, I still try to send this
> > patch as a quick fix (work around) since it does no harm to assign default
> > values of every registers when using regcache.
> 
> It's not a bug, it's not reasonable to default allocations to atomic and
> we can't really tell what context we're in.  Anything used inside a
> heavily locked path should either have a default provided or arrange for
> a prior write to set up the cache.

I've a little trouble to understand the prior write over here. Inside my
probe() there's a register_init() call which has a set of regmap_write().
And then the first regmap_write() results the dump. Does that mean this
regmap_write() isn't prior write? If so, how should I do if not setting
default values here -- Some IPs may have default value 0 for registers.
And this would make reg_defaults tedious since there's nothing special
to assign.

And actually I remember I haven't seen any dump when I sent the initial
patch for the whole ASRC driver but it manifested last month. I thought
it might be a partially-merging issue and it would be fixed after merge
window's done.....

Thank you
Nicolin
