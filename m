Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaJAW0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:26:31 -0400
Received: from mail-bl2on0061.outbound.protection.outlook.com ([65.55.169.61]:40096
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751720AbaJAW0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:26:30 -0400
Date: Wed, 1 Oct 2014 17:20:14 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 4/4] pmbus: ltc2978: add regulator support
In-Reply-To: <20141001213613.GA29312@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1410011713150.5194@atx-linux-37>
References: <20141001213613.GA29312@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0051.namprd08.prod.outlook.com (10.242.217.179) To
 DM2PR03MB320.namprd03.prod.outlook.com (10.141.54.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB320;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(51704005)(199003)(107046002)(66066001)(77096002)(95666004)(86152002)(42186005)(86362001)(46406003)(76176999)(97736003)(21056001)(54356999)(50986999)(20776003)(47776003)(64706001)(80022003)(33716001)(46102003)(99396003)(85306004)(105586002)(23726002)(4396001)(81156004)(53416004)(50466002)(85852003)(83506001)(101416001)(31966008)(87976001)(110136001)(92726001)(76482002)(92566001)(10300001)(69596002)(19580395003)(19580405001)(120916001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB320;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, Guenter Roeck wrote:

> On Wed, Oct 01, 2014 at 03:18:20PM -0500, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add simple on/off regulator support for ltc2978 and
> > other pmbus parts supported by ltc2978.c
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > 
> > v2: Remove '#include <linux/regulator/machine.h>'
> >     Only one regulator per pmbus device
> >     Get regulator_init_data from pdata or device tree
> > 
> > v3: Support multiple regulators for each chip
> >     Move most code to pmbus_core.c
> >     fixed values for on/off
> > 
> > v4: fix a #endif comment
> >     simplify probe code, remove added switch statement
> >     remove BUG_ON(), add error message and fix num_regulators
> > ---
> >  drivers/hwmon/pmbus/Kconfig   |    7 +++++++
> >  drivers/hwmon/pmbus/ltc2978.c |   37 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 44 insertions(+)
> > 
> > diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
> > index 6e1e493..79117b7 100644
> > --- a/drivers/hwmon/pmbus/Kconfig
> > +++ b/drivers/hwmon/pmbus/Kconfig
> > @@ -56,6 +56,13 @@ config SENSORS_LTC2978
> >  	  This driver can also be built as a module. If so, the module will
> >  	  be called ltc2978.
> >  
> > +config SENSORS_LTC2978_REGULATOR
> > +	boolean "Regulator support for LTC2974, LTC2978, LTC3880, and LTC3883"
> 
> We will need to update this and SENSORS_LTC2978 and add LTC2977 as well as
> LTM4646 to the list of supported chips.
> 
> Guenter

I will add the whole list to the 'help' sections of SENSORS_LTC2978 and
SENSORS_LTC2978_REGULATOR.

For the tristate/boolean lines, I can't fit the whole list, so I will
leave them as they are.  Or I could change to 'LTC2978 and compatibles' as
many others in this Kconfig have.

Alan

> 
> > +	depends on SENSORS_LTC2978 && REGULATOR
> > +	help
> > +	  If you say yes here you get regulator support for Linear
> > +	  Technology LTC2974, LTC2978, LTC3880, and LTC3883.
> > +
