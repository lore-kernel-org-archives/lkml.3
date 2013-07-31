Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688Ab3GaScS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:32:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47542 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3GaScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:32:13 -0400
Date: Wed, 31 Jul 2013 13:31:50 -0500
From: Nishanth Menon <nm@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Bill Huang <bilhuang@nvidia.com>, <sameo@linux.intel.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ian.campbell@citrix.com>, <rob@landley.net>,
        <lee.jones@linaro.org>, <broonie@linaro.org>, <j-keerthy@ti.com>,
        <grant.likely@linaro.org>, <ian@slimlogic.co.uk>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH v2 1/1] mfd: palmas: Add power off control
Message-ID: <20130731183149.GA6050@kahuna>
References: <1375255037-10024-1-git-send-email-bilhuang@nvidia.com>
 <51F8FBC4.1040009@ti.com>
 <51F94744.40301@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51F94744.40301@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:20-20130731, Stephen Warren wrote:
> On 07/31/2013 05:57 AM, Nishanth Menon wrote:
> > On 07/31/2013 02:17 AM, Bill Huang wrote:
> >> Hook up "pm_power_off" to palmas power off routine if there is DT
> >> property "ti,system-power-controller" defined, so platform which is
> >> powered by this regulator can be powered off properly.
> >>
> >> Based on work by:
> >> Mallikarjun Kasoju <mkasoju@nvidia.com>
> >>
> >> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> >> cc: Mallikarjun Kasoju <mkasoju@nvidia.com>
> >> ---
> >>   .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++
> >>   drivers/mfd/palmas.c                               |   33
> >> ++++++++++++++++++--
> > 
> > Since the specific question on v1 was not answered, I will ask again,
> > any reason why it wont fit in drivers/power/reset/ is'nt it the right
> > place to add this?
> 
> I think it makes sense to put simple standalone reset drivers into
> drivers/power/reset. However, where reset is just one tiny function of a
> larger device that already has a driver, it's fine for one driver to
Yes, this will probably increase in logic when we add stuff like USB IRQ
enable.. :(
> implement multiple features or essentially expose multiple subsystems.
I would generally agree to the same, but given we seem to now have
isolated it out to it's own subsystem, /me shrugs.

> 
> (besides this is system power off not system reset; which is
> drivers/power/reset?)

[1] seems to indicate that "or shut it down, by manipulating the main
power supply on the board." which seems to be precisely what we are
doing here, unless, ofcourse, my understanding of Palmas is wrong at
this point..

[1]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/power/reset/Kconfig
-- 
Regards,
Nishanth Menon
