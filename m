Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaJIQO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:14:57 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42781 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaJIQOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:14:49 -0400
Date: Thu, 9 Oct 2014 09:14:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, atull@opensource.altera.com
Subject: Re: [PATCH] regulator: of: Lower the severity of the error with no
 container
Message-ID: <20141009161444.GG31987@roeck-us.net>
References: <1412806199-5363-1-git-send-email-broonie@kernel.org>
 <20141008223403.GA24828@roeck-us.net>
 <20141008223601.GP4609@sirena.org.uk>
 <20141008225912.GA25134@roeck-us.net>
 <20141008234541.GQ4609@sirena.org.uk>
 <20141009000555.GA27476@roeck-us.net>
 <20141009001213.GS4609@sirena.org.uk>
 <20141009002531.GA27920@roeck-us.net>
 <20141009155440.GV4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009155440.GV4609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 04:54:40PM +0100, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 05:25:31PM -0700, Guenter Roeck wrote:
> > On Thu, Oct 09, 2014 at 01:12:13AM +0100, Mark Brown wrote:
> 
> > > We'll do something, just a question of what and what the default is.
> 
> > Ok. Note that a boot parameter would not work well for our use case,
> > so it would be great if we can find something else.
> 
> Could you explain why please?
> 
Some of the system are loaded from u-boot. We can technically change the
environment, but that would not be persistent. Product requirement is that the
default (hard-coded) environment has to be the one that is used. And changing
u-boot in those systems is more difficult than getting an audience with the
Pope - believe me, we went through that. Unless there is a fatal problem,
it simply won't be approved.

On x86 systems, which are booted through grub, we have a similar problem.
The boot menu is secured and for all practical purposes untouchable.

All that makes it much simpler to carry a one-line patch to remove the output
from the log. I may try to do without it and keep the message, but I am quite
sure that someone will complain and we'll have to do it.

> > > Shove a dev_name() on the front if we get a collision?  I have to say
> > > I've never cared, the debugfs isn't that important so it doesn't matter
> > > too much if it fails.
> 
> > Sure, but, again, I am getting lots and lots of those error messages.
> > I probably would not care either (and probably not even have noticed)
> > if not for those messages.
> 
> > Want me to submit a patch with the dev_name solution ?
> 
> Yes, please.

Ok, will do.

Thanks,
Guenter
