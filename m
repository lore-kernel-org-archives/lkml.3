Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaAGQCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:02:46 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46838 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaAGQCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:02:37 -0500
Date: Tue, 7 Jan 2014 08:02:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frodo Looijaard <frodol@dds.nl>,
        lm-sensors@lm-sensors.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] hwmon/sensors: fix SENSORS_LM75 dependencies
Message-ID: <20140107160236.GA24018@roeck-us.net>
References: <20140106204020.b47e53cc3ead8f90164ef5b7@canb.auug.org.au>
 <52CB0948.6030702@infradead.org>
 <20140106203209.GA21630@roeck-us.net>
 <52CB53DC.4030901@infradead.org>
 <52CB65DA.2010103@roeck-us.net>
 <20140107130401.23bffcd2@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107130401.23bffcd2@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 01:04:01PM +0100, Jean Delvare wrote:
> Hi Guenter, Randy,
> 
> On Mon, 06 Jan 2014 18:26:34 -0800, Guenter Roeck wrote:
> > On 01/06/2014 05:09 PM, Randy Dunlap wrote:
> > > From: Randy Dunlap <rdunlap@infradead.org>
> > >
> > > Fix SENSORS_LM75 dependencies to eliminate build errors:
> > >
> > > drivers/built-in.o: In function `lm75_remove':
> > > lm75.c:(.text+0x12bd8c): undefined reference to `thermal_zone_of_sensor_unregister'
> > > drivers/built-in.o: In function `lm75_probe':
> > > lm75.c:(.text+0x12c123): undefined reference to `thermal_zone_of_sensor_register'
> > >
> > > Add depends on THERMAL_OF since that is what provides the
> > > register/unregister functions above.
> > >
> > > Add depends on THERMAL since THERMAL is a tristate (while THERMAL_OF
> > > is a bool) and SENSORS_LM75 (tristate) needs to be limited to modular
> > > builds when THERMAL=m.
> > >
> > > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > > ---
> > >   drivers/hwmon/Kconfig |    2 ++
> > >   1 file changed, 2 insertions(+)
> > >
> > > --- linux-next-20140106.orig/drivers/hwmon/Kconfig
> > > +++ linux-next-20140106/drivers/hwmon/Kconfig
> > > @@ -650,6 +650,8 @@ config SENSORS_LM73
> > >   config SENSORS_LM75
> > >   	tristate "National Semiconductor LM75 and compatibles"
> > >   	depends on I2C
> > > +	depends on THERMAL
> > > +	depends on THERMAL_OF
> > >   	help
> > >   	  If you say yes here you get support for one common type of
> > >   	  temperature sensor chip, with models including:
> > >
> > >
> > NACK. The driver does not and must not depend on THERMAL.
> 
> Correct.
> 
> > This needs to be addressed
> > in the thermal code, for example with dummy declarations if THERMAL=m but
> > SENSORS_LM75=y. The functions are already declared as dummies if THERMAL_OF=n.
> 
> This won't fly I'm afraid, the number of hwmon drivers affected will
> grow in the future and you certainly don't want to have to change the
> generic thermal code every time a new driver is added/converted.
> 
That is not really necessary - see the patch fragment I sent as response to
the other patch.

Guenter
