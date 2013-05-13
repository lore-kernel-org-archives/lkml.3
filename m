Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab3EMKoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:44:04 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62423 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab3EMKoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:44:02 -0400
Date: Mon, 13 May 2013 12:43:51 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
Message-ID: <20130513104351.GA32308@balto.lan>
References: <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
 <20130508114216.GB29130@balto.lan>
 <20130508123225.GK7478@sirena.org.uk>
 <20130508131020.GA30503@balto.lan>
 <20130508135413.GR7478@sirena.org.uk>
 <20130508141723.GA12155@balto.lan>
 <20130508142938.GS7478@sirena.org.uk>
 <20130508154805.GA12970@balto.lan>
 <20130509094103.GA7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130509094103.GA7478@sirena.org.uk>
X-Operating-System: Linux balto 3.9.0-10518-gd7ab730 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 10:41:03AM +0100, Mark Brown wrote:
> On Wed, May 08, 2013 at 05:48:05PM +0200, Fabio Baltieri wrote:
> > On Wed, May 08, 2013 at 03:29:38PM +0100, Mark Brown wrote:
> 
> > > So if these pins are being shared between the instances then surely
> > > there are other interdependencies that need to be taken care of Is that
> > > happening?  For example if the clocks are shared then is the code
> > > currently stopping the interfaces being configured with incompatible
> > > sample rates or word sizes?
> 
> > That's an interesting point.  Mixed format, rate and channel counts
> > seems to work just fine, but that's probably because the supported rate
> > and format is locked by the codec to 48k + S16_LE.  This is in line with
> > what is specified on the ab8500 datasheet:
> > 
> > ---
> > The AB8500 audio module exchanges audio data through the two digital
> > interfaces at a fixed 48 kHz rate in different formats with up to 8
> > channels per interface.
> > ---
> 
> That sounds like there's still some potential problems with the channel
> count, though?

Ok I'll try to figure out how to properly handle this. Right now the
timeslot mapping is exposed to the userspace with a series of dapm
widgets at codec level, and the same bits are set in the tdm api
depending on the channel counts.

> > On the other side, I don't think anybody is using the ux500 with
> > anything else than the ab8500, so I don't even know how would I test and
> > fix this.
> 
> The fix should simply be a case of setting constraints when opening
> additional interfaces based on the configuration of the primary
> interface.  You can test this sort of thing by simply verifying that it
> doesn't break the existing cases.

Ok.

> > > Well, most things would probably be able to get some small benefit from
> > > doing this, it's just that we've not had any real support for managing
> > > pin muxing - one of the goals of adding pinctrl is to make it easier to
> > > deploy this sort of thing.
> 
> > Pin muxing is handled transparently.  The real problem is sleep mode
> > switching, but that's really not needed if the codec has a proper low
> > power mode.
> 
> I'm not following that at all I'm afraid - I don't understand the
> relevance of the CODEC?

My understanding is that ASoC may not need explicit pinctrl support
because default pin assignments is already handled at pinctrl framework
level, and pinctrl sleep mode may not be necessary at all, unless
someone else can come out with a good reason for that.

Fabio

-- 
Fabio Baltieri
