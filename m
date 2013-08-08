Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966280Ab3HHUAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:00:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36859 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966063Ab3HHUAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:00:20 -0400
Date: Thu, 8 Aug 2013 13:00:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Wei Ni <wni@nvidia.com>, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-tegra@vger.kernel.org, MLongnecker@nvidia.com,
        khali@linux-fr.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
Message-ID: <20130808200026.GA18226@roeck-us.net>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1375944991-29182-2-git-send-email-wni@nvidia.com>
 <20130808110136.GA6427@sirena.org.uk>
 <52038035.7030803@roeck-us.net>
 <20130808130840.GC6427@sirena.org.uk>
 <5203B78C.7010101@roeck-us.net>
 <20130808171554.GI6427@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808171554.GI6427@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 06:15:54PM +0100, Mark Brown wrote:
> On Thu, Aug 08, 2013 at 08:21:48AM -0700, Guenter Roeck wrote:
> > On 08/08/2013 06:08 AM, Mark Brown wrote:
> 
> > >I'd be most surprised if the device worked without power, if the driver
> > >fails to get and enable a regulator for it then that's not great
> > >(especially if it does so silently).
> 
> > Correct, but it appears that the driver magically worked for a long time
> > without it.
> 
> Sure, it'll work in systems that have always on regulators.
> 
> > Is it guaranteed that the driver keeps working for all cases where
> > regulator support is enabled in the kernel, and where it used to work
> > so far without mandating the existence of this specific regulator ?
> > My main concern is having to deal with complaints that the driver stopped
> > working for no good reason.
> 
> Sure, that's the transition issues I mentioned - the regulator API does
> have stubbing facilities which should cover things and it's very easy to
> define stub regulators if you need to.  Like I say I expect this to be a
> lot easier after the next merge window as another way of doing stubs is
> being added which should make this even easier by avoiding disrupting
> drivers that do genuinely want to check for absent supplies and handle
> that better.
> 
We will need to make sure that all dts files using any of the compatible chips
are updated accordingly. There are several entries in various dts files for
adm1032, adt7461, lm90, and nct1008.

> > In this context, is it common practice to name such regulators "vdd"
> > or similar ? What if there are multiple LM90 or compatible chips
> > in a system, connected to different power rails ? Who determines
> > if the regulator is supposed to be named "vdd" or "vcc" or anything
> > else, and to which power rails it is actually connected ? How can
> > and does one guarantee that "vdd" is the correct regulator to use
> > for all systems ? What if some other driver requests "vdd", but the chip
> > it supports happens to be connected to a different power rail ?
> 
> That's not what the name means - they are nothing to do with the board.

Ok, makes sense.

> The names requested by a driver are defined with regard to the device
> and should be the names used by the chip itself as defined in the

9 votes for vdd, 11 votes for vcc, one undecided (no datasheet available).
Guess one is as good as the other ;-).

Guenter

> datasheet.  A board that uses regulators then maps these onto specific
> regulators in the system, the driver doesn't need to know anything about
> this process.
