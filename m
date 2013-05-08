Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab3EHO1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:27:50 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62604 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3EHO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:27:45 -0400
Date: Wed, 8 May 2013 16:27:34 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
Message-ID: <20130508142734.GB12155@balto.lan>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
 <20130508114216.GB29130@balto.lan>
 <20130508123225.GK7478@sirena.org.uk>
 <20130508131020.GA30503@balto.lan>
 <20130508135413.GR7478@sirena.org.uk>
 <20130508141723.GA12155@balto.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508141723.GA12155@balto.lan>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 04:17:23PM +0200, Fabio Baltieri wrote:
> > > If I understood the problem correctly you do that when you want to cut
> > > power completely to some peripherals to avoid spurious current paths,
> > > and that should not be the case for the audio codec, especially in this
> > > case where it's part of a big multifuntion IC.
> > 
> > Being a MFD should have nothing to do with this?
> 
> Ok, what I'm trying to say is that the codec used in this platform
> should be able to handle sleep modes without requiring any
> reconfiguration of the digital interface on the SoC side.  In support of
> this the fact that the STE fork of the driver does not do that, and the
> same goes for all other ASoC drivers currently in mainline.

And by the way, if the current code is *really* setting the digital
audio bus pins in hi-z mode (without any pull-up/down/keeper) as it
claims, this is not just usless, it's plain wrong.  The bus should never
be left floating on both sides, right?

Fabio

-- 
Fabio Baltieri
