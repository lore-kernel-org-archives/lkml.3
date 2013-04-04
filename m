Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763713Ab3DDHfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:35:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49079 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763457Ab3DDHf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:35:29 -0400
Message-ID: <515D2D30.3000306@ti.com>
Date: Thu, 4 Apr 2013 10:35:12 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <b-cousson@ti.com>, <linux@arm.linux.org.uk>, <rnayak@ti.com>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, "Menon, Nishanth" <nm@ti.com>
Subject: Re: [RFC][PATCH 1/2] ARM: OMAP4: clock: Add device tree support for
 AUXCLKs
References: <1363703220-4777-1-git-send-email-rogerq@ti.com> <1363703220-4777-2-git-send-email-rogerq@ti.com> <20130403234242.GE10155@atomide.com>
In-Reply-To: <20130403234242.GE10155@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/04/2013 02:42 AM, Tony Lindgren wrote:
> Hi,
> 
> * Roger Quadros <rogerq@ti.com> [130319 07:31]:
>> Register a device tree clock provider for AUX clocks
>> on the OMAP4 SoC. Also provide the binding information.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  .../devicetree/bindings/clock/omap4-clock.txt      |   32 ++++++++++++++++++
>>  arch/arm/boot/dts/omap4.dtsi                       |    5 +++
>>  arch/arm/mach-omap2/board-generic.c                |    2 +-
>>  arch/arm/mach-omap2/cclock44xx_data.c              |   35 ++++++++++++++++++++
>>  arch/arm/mach-omap2/clock44xx.h                    |    1 +
>>  arch/arm/mach-omap2/common.h                       |    9 +++++
>>  arch/arm/mach-omap2/io.c                           |    6 +++
>>  7 files changed, 89 insertions(+), 1 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/clock/omap4-clock.txt
>>
> ...
> 
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/clock/omap4-clock.txt
> 
> Is this really specific to omap4 and auxclk only?
> 
> Shouldn't it be just omap-clock.txt?

Yes, I've fixed this up in v2 of this patch.

> 
>> --- a/arch/arm/mach-omap2/cclock44xx_data.c
>> +++ b/arch/arm/mach-omap2/cclock44xx_data.c
>> @@ -27,6 +27,7 @@
>>  #include <linux/clk-private.h>
>>  #include <linux/clkdev.h>
>>  #include <linux/io.h>
>> +#include <linux/of.h>
>>  
>>  #include "soc.h"
>>  #include "iomap.h"
>> @@ -1663,6 +1664,40 @@ static struct omap_clk omap44xx_clks[] = {
>>  	CLK(NULL,	"cpufreq_ck",	&dpll_mpu_ck,	CK_443X),
>>  };
>>  
>> +static struct clk *scrm_clks[] = {
>> +	&auxclk0_ck,
>> +	&auxclk1_ck,
>> +	&auxclk2_ck,
>> +	&auxclk3_ck,
>> +	&auxclk4_ck,
>> +	&auxclk5_ck,
>> +};
> 
> Hmm I don't like the idea of specifying the auxclk both in the
> cclock44xx_data.c and in DT..

Right, but till we have all clocks moved to DT we only need this
approach for general purpose clocks that are not mapped to devices
by hwmod.

e.g. auxclk are required to be specified in DT nodes for USB PHY.
Without this we can't get USB host working on Panda.

As Rajendra points out, it seems moving entire clock data to DT is not
going to happen soon. So this is the simplistic way things can work.

cheers,
-roger
