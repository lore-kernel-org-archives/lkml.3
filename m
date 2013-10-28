Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3J1GSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:18:13 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40548 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3J1GSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:18:11 -0400
Date: Sun, 27 Oct 2013 23:18:08 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kim, Milo" <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: Re: [PATCH 1/7] power_supply: Add charger control properties
Message-ID: <20131028061807.GA31266@teo>
References: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
 <1379959445-28207-2-git-send-email-jenny.tc@intel.com>
 <20131027234535.GA23523@teo>
 <20ADAB092842284E95860F279283C5640AA99A32@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C5640AA99A32@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 03:36:36AM +0000, Tc, Jenny wrote:
> > But do we really want to control the chargers through the power_supply's user-visible
> > interface? It makes the whole power supply thing so complicated that I'm already losing
> > track of it. Right now I think I would prefer to move all the charger logic out of the psy
> > class.
> >
> 
> I think exposing properties make the logic generic, otherwise it may end up in having callback
> functions.
>
> Also there are some scenarios where the charging algorithm has to be in the
> user space.

Which scenarios?

Plus, I am more questioning if the power supply framework is the right
thing to control the *chargers*. Chargers are not the power supply to the
system or any device (well, except for the batteries themselves).

> Using the patch https://lkml.org/lkml/2013/7/25/204,
> the power supply change notification can be broadcasted. We can add notifier events
> for power_supply_register and thermal throttling. This way power_supply_charger.c can
> be a separate driver and it can listen to psy notifications to take actions.

If you ever need this particular notifier, I am OK with it (but I'll
consider applying it only together with some its users).

Basically, I am more against these three patches:

[PATCH 3/7] power_supply: add throttle state
[PATCH 2/7] power_supply: add charger cable properties
[PATCH 1/7] power_supply: Add charger control properties (enable_charger part)

These three add too much "charger" specifics to the power_supply stuff. I
think they deserve their own subsystem/class/whatever.

Also, the battid framework is written without any notion of device/driver
separation, uses global variables, and I suspect it should not exist at
all (psy_get_batt_prop function makes me think that you should just
register the i2c/spi/w1 battery with the power_supply and not use the
ad-hoc stuff).

Anton
