Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaJQOzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 10:55:19 -0400
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:21504
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753313AbaJQOzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 10:55:17 -0400
Date: Fri, 17 Oct 2014 09:48:39 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Guenter Roeck <linux@roeck-us.net>
CC: <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v6 3/4] pmbus: add regulator support
In-Reply-To: <20141016202045.GA23966@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1410170944240.13511@atx-linux-37>
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com> <1413399310-19277-4-git-send-email-atull@opensource.altera.com> <20141016183501.GA21253@roeck-us.net> <alpine.DEB.2.02.1410161339450.28663@atx-linux-37>
 <20141016202045.GA23966@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR0201CA0012.namprd02.prod.outlook.com (25.160.191.150)
 To BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(164054003)(189002)(199003)(24454002)(51704005)(66066001)(23726002)(64706001)(110136001)(19580405001)(19580395003)(69596002)(21056001)(85852003)(4396001)(47776003)(20776003)(76482002)(42186005)(107046002)(53416004)(120916001)(99396003)(86362001)(92566001)(86152002)(122386002)(575784001)(93886004)(85306004)(102836001)(87976001)(80022003)(83506001)(46102003)(50466002)(92726001)(101416001)(33716001)(50986999)(76176999)(54356999)(105586002)(40100003)(106356001)(97736003)(77096002)(95666004)(46406003)(81156004)(31966008)(276003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014, Guenter Roeck wrote:

> On Thu, Oct 16, 2014 at 01:40:23PM -0500, atull wrote:
> > On Thu, 16 Oct 2014, Guenter Roeck wrote:
> > 
> > > On Wed, Oct 15, 2014 at 01:55:09PM -0500, atull@opensource.altera.com wrote:
> > > > From: Alan Tull <atull@opensource.altera.com>
> > > > 
> > > > Add support for simple on/off control of each channel.
> > > > 
> > > > To add regulator support, the pmbus part driver needs to add
> > > > regulator_desc information and number of regulators to its
> > > > pmbus_driver_info struct.
> > > > 
> > > > regulator_desc can be declared using default macro for a
> > > > regulator (PMBUS_REGULATOR) that is in pmbus.h
> > > > 
> > > > The regulator_init_data can be initialized from either
> > > > platform data or the device tree.
> > > > 
> > > > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > > > Reviewed-by: Mark Brown <broonie@kernel.org>
> > > > Cc: Guenter Roeck <linux@roeck-us.net>
> > > 
> > > Hi Alan,
> > > 
> > > I am still seeing lots of the following:
> > > 
> > > vout0: Failed to create debugfs directory
> > > vout1: Failed to create debugfs directory
> > > vout2: Failed to create debugfs directory
> > > vout3: Failed to create debugfs directory
> > > vout4: Failed to create debugfs directory
> > > vout5: Failed to create debugfs directory
> > > vout6: Failed to create debugfs directory
> > > vout7: Failed to create debugfs directory
> > > 
> > > I thought there was a problem in the regulator core, but after looking
> > > into it concluded that the regulator core _should_ prepend the names
> > > with the device name when creating the debugfs entries, unless no device
> > > name is specified. So something must be missing. We'll need to sort
> > > this out before I can accept the code.
> > > 
> > > Thanks,
> > > Guenter
> > > 
> > 
> > Hi Guenter,
> > 
> > OK, I will look into it.
> > 
> 
> Can you try the following patch ? It may not be perfect, but it does
> the job for me.
> 
> Mark, would that patch be acceptable ?
> 
> Thanks,
> Guenter
> ---
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Thu, 16 Oct 2014 13:08:35 -0700
> Subject: [PATCH] regulator: Ensure unique regulator debugfs directory names
> 
> If multiple regulator devices of the same type exist in a system,
> the regulator driver assigns generic names for the regulators it
> provides, and debugfs is enabled, the regulator subsystem attempts
> to create multiple entries with the same name in the regulator debugfs
> directory. This fails for all but the first regulator, resulting in
> multiple "Failed to create debugfs directory" log entries.
> 
> To avoid the problem, prepend the debugfs directory name for a regulator
> with its parent device name if available, but only if no explicit
> regulator name was provided.
> 
> Cc: Alan Tull <atull@opensource.altera.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/regulator/core.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index cd87c0c..92f7a53 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -3538,7 +3538,18 @@ static int add_regulator_attributes(struct regulator_dev *rdev)
>  
>  static void rdev_init_debugfs(struct regulator_dev *rdev)
>  {
> -	rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
> +	struct device *parent = rdev->dev.parent;
> +	const char *rname = rdev_get_name(rdev);
> +	char name[NAME_MAX];
> +
> +	/* Avoid duplicate debugfs directory names */
> +	if (parent && rname == rdev->desc->name) {
> +		snprintf(name, sizeof(name), "%s-%s", dev_name(parent),
> +			 rname);
> +		rname = name;
> +	}
> +
> +	rdev->debugfs = debugfs_create_dir(rname, debugfs_root);
>  	if (!rdev->debugfs) {
>  		rdev_warn(rdev, "Failed to create debugfs directory\n");
>  		return;
> -- 
> 1.9.1
> 

Hi Guenter,
 
I tried it out on a board with two ltc2978's.  It looked really good to 
me.  It solves the debugfs issue without affecting the DT.

root@socfpga_cyclone5:~# ls /sys/kernel/debug/regulator/
0-005c-vout0               0-005c-vout6               0-005e-vout7
0-005c-vout1               0-005c-vout7               FPGA-1.1V
0-005c-vout2               0-005e-vout1               FPGA-1.5V
0-005c-vout3               0-005e-vout3               FPGA-2.5V
0-005c-vout4               0-005e-vout5               
reg-dummy-regulator-dummy
0-005c-vout5               0-005e-vout6               supply_map

Alan
