Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbaHVCao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 22:30:44 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37968 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbaHVCan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 22:30:43 -0400
Date: Thu, 21 Aug 2014 19:30:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: atull@opensource.altera.com, jdelvare@suse.de, lm-sensors@lm-sensors.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH 2/2] pmbus: ltc2978: add regulator gating
Message-ID: <20140822023038.GA17819@roeck-us.net>
References: <1408659686-29106-1-git-send-email-atull@opensource.altera.com>
 <1408659686-29106-3-git-send-email-atull@opensource.altera.com>
 <20140822003650.GQ24407@sirena.org.uk>
 <20140822011810.GA17461@roeck-us.net>
 <20140822012622.GS24407@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822012622.GS24407@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 08:26:22PM -0500, Mark Brown wrote:
> On Thu, Aug 21, 2014 at 06:18:10PM -0700, Guenter Roeck wrote:
> > On Thu, Aug 21, 2014 at 07:36:50PM -0500, Mark Brown wrote:
> > > On Thu, Aug 21, 2014 at 05:21:26PM -0500, atull@opensource.altera.com wrote:
> 
> > > This all looks very much like pmbus could use regmap and then the regmap
> > > helpers.  I'd not insist on it though.  What I would however suggest is
> 
> > Not unless regmap got extended recently to support quick, byte, and word
> > smbus accesses at the same time.
> 
> Depending on how you decide which it quite possibly does - if it's based
> on the register number that'd work.

Mostly per register, but also per chip (for manufacturing specific registers
the register size is determined by the chip type). Also, there are block
registers. Plus, the scope of each register (ie if it is paged or not)
is chip specific.  The same register may be paged on one chip, and unpaged
on another. I'll have another look to see if that all can be mapped into the
regmap model. If yes, it might actually be quite helpful and might simplify
the pmbus code quite a bit.

Either case, even if regmap now supports all the PMBus oddities, converting
the pmbus drivers to use regmap should be a separate patch set and not be
tied together.

Tnanks,
Guenter
