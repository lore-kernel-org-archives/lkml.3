Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaJ1Qhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:37:47 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57698 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbaJ1Qhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:37:43 -0400
Date: Tue, 28 Oct 2014 09:37:34 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: fsl_asrc: Add reg_defaults for regmap to fix
 kernel dump
Message-ID: <20141028163733.GA6480@Asurada>
References: <1414202637-18929-1-git-send-email-nicoleotsuka@gmail.com>
 <20141028001904.GH18557@sirena.org.uk>
 <20141028042603.GA5548@Asurada>
 <20141028104742.GP18557@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028104742.GP18557@sirena.org.uk>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:47:42AM +0000, Mark Brown wrote:
> On Mon, Oct 27, 2014 at 09:26:26PM -0700, Nicolin Chen wrote:
> > On Tue, Oct 28, 2014 at 12:19:04AM +0000, Mark Brown wrote:
> 
> > > It's not a bug, it's not reasonable to default allocations to atomic and
> > > we can't really tell what context we're in.  Anything used inside a
> > > heavily locked path should either have a default provided or arrange for
> > > a prior write to set up the cache.
> 
> > I've a little trouble to understand the prior write over here. Inside my
> > probe() there's a register_init() call which has a set of regmap_write().
> > And then the first regmap_write() results the dump. Does that mean this
> > regmap_write() isn't prior write? If so, how should I do if not setting
> 
> Oh, bother.  We fixed things so that we're now always running with the
> spinlock held...  never mind.

Okay...so only one choice left.

> > default values here -- Some IPs may have default value 0 for registers.
> > And this would make reg_defaults tedious since there's nothing special
> > to assign.
> 
> Write a small script then, or a little bit of code to create the
> defaults dynamically.

It actually doesn't bother me at all. I just thought there might be
a simpler way. :)

Thank you
Nicolin
