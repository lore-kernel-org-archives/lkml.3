Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3JCQLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:11:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55451 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731Ab3JCQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:11:16 -0400
Date: Thu, 3 Oct 2013 17:11:14 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [RFC PATCH] regulator: core: Add ability to create a lookup
	alias for supply
Message-ID: <20131003161114.GA3635@opensource.wolfsonmicro.com>
References: <1380716219-32039-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20131002195029.GH27287@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002195029.GH27287@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 08:50:29PM +0100, Mark Brown wrote:
> Bulk versions of the API would also make sense - it's likely that more
> than one supply will need to be mapped - and please also add managed
> versions so people don't have to write cleanup code.

For the bulk API would you prefer taking a single src and alias
device and a list of supplies, or lists for all three?

I would go for a list just for the supplies, as lists of devices
would probably need to be filled in by a loop on the user end
anyway negating the point of the bulk API some what and a lot of
the use-cases will like have the same device on both sides for
all the supplies.

> > I have a couple of patches that update the Arizona driver to
> > use this that I will send in if you think this looks along
> > the lines of what you were suggesting.
> 
> This seems like someting that should be in the MFD core, or at least
> that there should be helpers in the core.  Something like a set of
> mappings in the mfd_cell so it's all data to the drivers.

Looks like a simple enough addition to the MFD core, I will
submit a patch doing it this way and see where we get to.

> Please use a more meaningful name for dev.  It might also be worth
> allowing rewriting of the supply name since we'll probably find other
> applications for things like modular board designs where name rewriting
> is useful; since it's a function call with a parameter list it's harder
> to add later than it would be with a struct.

Seems that it could be useful to change the supply name, I will
add this in as well.

Thanks,
Charles

