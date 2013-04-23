Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3DWFIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 01:08:17 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:19729 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab3DWFIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 01:08:16 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [NEW DRIVER V6 1/7] drivers/mfd: DA9058 MFD core driver
Thread-Topic: [NEW DRIVER V6 1/7] drivers/mfd: DA9058 MFD core driver
Thread-Index: AQHOPSKWnGUmuwKwFEW3L7L6FJ6q1JjiMSQAgADzT1A=
Date: Tue, 23 Apr 2013 05:08:12 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB514191F6B6@NB-EX-MBX02.diasemi.com>
References: <201304191722.r3JHMGqA019124@latitude>
 <20130422133417.GN30351@opensource.wolfsonmicro.com>
In-Reply-To: <20130422133417.GN30351@opensource.wolfsonmicro.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.95.24.79]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: 22 April 2013 14:34
> To: Opensource [Anthony Olech]
> Cc: Samuel Ortiz; Arnd Bergmann; Mauro Carvalho Chehab; Steven Toth;
> Michael Krufky; LKML; David Dajun Chen
> Subject: Re: [NEW DRIVER V6 1/7] drivers/mfd: DA9058 MFD core driver
> 
> On Fri, Apr 19, 2013 at 05:56:24PM +0100, Anthony Olech wrote:
> 
> > +static struct da9058_regulator_pdata buck1_pdata = {
> > +	.init.constraints.name = "DA9058_BUCK1",
> > +	.regulator_id = DA9058_BUCK_1,
> > +	.init.constraints.min_uV = DA9058_BUCK12_VOLT_LOWER * 1000,
> > +	.init.constraints.max_uV = DA9058_BUCK12_VOLT_UPPER * 1000,
> > +	.control_voltage_step = DA9058_BUCK_VOLT_STEP * 1000,
> > +	.control_register = DA9058_BUCK1_REG,
> > +	.control_step_mask = DA9058_MAX_VSEL,
> > +	.control_enable_mask = DA9058_BUCK_LDO_EN,
> > +	.ramp_register = DA9058_SUPPLY_REG,
> > +	.ramp_enable_mask = DA9058_SUPPLY_VBUCK1GO,
> > +	.init.constraints.valid_ops_mask = REGULATOR_CHANGE_VOLTAGE |
> > +			REGULATOR_CHANGE_MODE |
> REGULATOR_CHANGE_STATUS,
> > +	.init.constraints.valid_modes_mask = REGULATOR_MODE_NORMAL,
> > +	.init.constraints.boot_on = 1,
> 
> No, you're totally missing the point here.  Your regulator driver needs
> to be generic and work on any machine using the device.  This means you
> can't specify any constraints, the constraints need to come from the
> system integration.
> 
[...]

thanks Mark for your helpful comments.

As far as I can see there are two types of constraints:-
1) the absolute max/min that the PMIC itself is designed for.
2) the max/min that the board is designed for, ie system integration.

Thus constraints type (1) must come from the driver and constraints type (2)
must come from the machine driver, which for my testing is the mach-smdk6410.

Also, I believe that two further principles apply:
A) the machine driver should only specify a constraint if it restricts a value from (1) above.
B) sensible defaults should be specified in the driver so that a system should have some
   chance of operating in the case that the machine driver provides no constraints/overrides.

Thus, in the case of this PMIC, the big BUCK is designed to provide power to the processor,
so the only possible sensible default can be "boot_on == 1". It then makes sense that if a
PMIC is to be used in the situation it is designed for, then the number of system integration 
constraints should be almost zero.

>From your comment it seems that I have missed a point, but what?

Tony Olech

