Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaFLUzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:55:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35904 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbaFLUzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:55:37 -0400
Date: Wed, 11 Jun 2014 11:59:26 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>, sameo@linux.intel.com,
        lee.jones@linaro.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: arizona-ldo1: Do not control clocking
	from regulator
Message-ID: <20140611105926.GB12074@opensource.wolfsonmicro.com>
References: <20140609150013.GA5229@opensource.wolfsonmicro.com> <20140609150435.GE5229@opensource.wolfsonmicro.com> <20140609184314.GB5099@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609184314.GB5099@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 07:43:14PM +0100, Mark Brown wrote:
> On Mon, Jun 09, 2014 at 04:04:35PM +0100, Richard Fitzgerald wrote:
> > Using the driver for the internal regulator to also control
> > the clock frequency of blocks inside the codec is an
> > unexpected side-effect for a regulator, and also means that
> > the core clocks won't be changed as expected if an external
> > regulator is used to power the codec.
> 
> IIRC this was deliberately coded in this fashion on advice from the
> hardware engineers - there was more going on with that register than
> there might at first appear and some actual sync with the LDO.  I
> believe there was some different process to follow (possibly just
> setting this mode all the time) when using an external regulator, though
> it's also possible the hardware guys were just unsure at the time.

I have had a good chat with the hardware engineers here and they
are pretty adamant that the only constraint here is that we
should never enable SUBSYS without 1.8V being supplied to the
core.

They also believe that the external case should be handled the
same as the internal one, although admittedly I haven't tested
that personally.

This series needs a slight rebase and fixing up for my comment on
one of the patches, but otherwise I think should be good in my
opinion.

Thanks,
Charles
