Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbaJVW3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 18:29:35 -0400
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:5776
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932962AbaJVW3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 18:29:32 -0400
X-Greylist: delayed 8214 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 18:29:31 EDT
Date: Wed, 22 Oct 2014 17:22:18 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 3/3] fpga manager: bus driver
In-Reply-To: <1414007405-32186-4-git-send-email-atull@opensource.altera.com>
Message-ID: <alpine.DEB.2.02.1410221716270.9996@atx-linux-37>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com> <1414007405-32186-4-git-send-email-atull@opensource.altera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SG2PR03CA0036.apcprd03.prod.outlook.com (25.160.233.46) To
 BLUPR03MB312.namprd03.prod.outlook.com (10.141.48.28)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB312;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 037291602B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(22564002)(199003)(189002)(87976001)(15975445006)(105586002)(46102003)(76176999)(77096002)(53416004)(19580395003)(42186005)(19580405001)(107046002)(106356001)(81156004)(83506001)(69596002)(76482002)(31966008)(95666004)(120916001)(80022003)(99396003)(33716001)(92726001)(92566001)(50986999)(102836001)(575784001)(2201001)(54356999)(85306004)(86362001)(21056001)(46406003)(101416001)(97736003)(23726002)(85852003)(122386002)(86152002)(40100003)(50466002)(4396001)(15202345003)(64706001)(66066001)(47776003)(20776003)(2004002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB312;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, atull@opensource.altera.com wrote:

> From: Alan Tull <atull@opensource.altera.com>
> 
> Support programming the fpga from device tree overlays.
> 
> This patch adds one exported function to the core
> (fpga-mgr.c): of_fpga_mgr_dev_lookup
>   Get pointer to fpga manager struct given a phandle.
> 
> This code is dependent on Pantelis Antoniou's current work
> on Device Tree overlays, a method of dynamically altering
> the kernel's live Device Tree.  The rest of the patchset was
> tested with recent for-next, but this 'bus driver' patch was
> tested with Pantelis's and Grant Likely's stuff that is in git
> (his git repo https://github.com/pantoniou/linux-beagle-track-mainline
>  v3.17-rc2-115-gbc778b8 == dt-ng/bbb) plus some dtc fixups
> for compiling overlays.
> 

Since this patch is dependent on a branch that would be hard
to put together, I have pushed a branch.  If you happen to
have a cyclone5 board sitting around, you should be able to
load a FPGA from DT overlays using the steps below.

The branch name is 'dt-ng-overlays-v2.2'.  The repo is at:
git://git.rocketboards.org/linux-socfpga-next.git

Alan

> Here's a simple example. Start with:
>   * the altera-gpio driver built in to the kernel but not in the
>     device tree.
>   * raw fpga image at /lib/firmware/soc_system.rbf
>   * Load appropriate device tree overlay in configfs by doing
>     $ mkdir /config/device-tree/overlays/1
>     $ echo socfpga_overlay.dtbo > /config/device-tree/overlays/1/path
>   * This results in the FPGA getting programmed and the altera
>     gpio driver getting probed.
>   * To remove/clear FPGA image by putting the FPGA in reset,
>     remove device tree overlay by doing:
>     $ rmdir /config/device-tree/overlays/1
> 
> Device tree overlay looks like this:
> /dts-v1/;
> /plugin/;
> / {
> 	fragment@0 {
> 		target-path="/soc";
> 		__overlay__ {
> 			#address-cells = <1>;
> 	                #size-cells = <1>;
> 
> 			bridge@0xff200000 {
> 				compatible = "fpga-mgr-bus", "simple-bus";
> 				reg = <0xff200000 0x200000>;
> 				clocks = <0x2 0x2>;
> 				clock-names = "h2f_lw_axi_clock", "f2h_sdram0_clock";
> 				#address-cells = <0x2>;
> 				#size-cells = <0x1>;
> 				ranges = <0x1 0x10040 0xff210040 0x20>;
> 
> 				fpgamgr = <&hps_0_fpgamgr>;
> 				fpga-firmware = "soc_system.rbf";
> 
> 				gpio@0x100010040 {
> 					compatible = "altr,pio-14.0", "altr,pio-1.0";
> 					reg = <0x1 0x10040 0x20>;
> 					clocks = <0x2>;
> 					altr,gpio-bank-width = <0x4>;
> 					resetvalue = <0x0>;
> 					#gpio-cells = <0x2>;
> 					gpio-controller;
> 					linux,phandle = <0x2d>;
> 				};
> 			};
> 		};
> 	};
> };
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> 
> v2: simplify of_fpga_mgr_dev_lookup to return NULL on failure
>     move suspend/resume to fpga-mgr.c core
>     support 'rmdir' to remove overlay
> ---
>  drivers/fpga/Kconfig     |    7 +++
>  drivers/fpga/Makefile    |    1 +
>  drivers/fpga/bus.c       |  124 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/fpga/fpga-mgr.c  |   23 +++++++++
>  include/linux/fpga-mgr.h |    2 +
>  5 files changed, 157 insertions(+)
>  create mode 100644 drivers/fpga/bus.c
> 
> diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
> index e775b17..2bd6c83 100644
> --- a/drivers/fpga/Kconfig
> +++ b/drivers/fpga/Kconfig
> @@ -18,4 +18,11 @@ config FPGA_MGR_SYSFS
>  	help
>  	  FPGA Manager SysFS interface.
>  
> +config FPGA_MGR_BUS
> +	bool "FPGA Manager Bus"
> +	depends on FPGA
> +	help
> +	  FPGA Manager Bus interface.  Allows loading FPGA images
> +	  from Device Tree or from other drivers.
> +
>  endmenu
> diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
> index c8a676f..e39911f 100644
> --- a/drivers/fpga/Makefile
> +++ b/drivers/fpga/Makefile
> @@ -6,5 +6,6 @@ fpga-mgr-core-y += fpga-mgr.o
>  
>  # Core FPGA Manager Framework
>  obj-$(CONFIG_FPGA)			+= fpga-mgr-core.o
> +obj-$(CONFIG_FPGA_MGR_BUS)		+= bus.o
>  
>  # FPGA Manager Drivers
> diff --git a/drivers/fpga/bus.c b/drivers/fpga/bus.c
> new file mode 100644
> index 0000000..999346e
> --- /dev/null
> +++ b/drivers/fpga/bus.c
> @@ -0,0 +1,124 @@
> +/*
> + * FPGA Manager Bus Driver
> + *
> + *  Copyright (C) 2013-2014 Altera Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/completion.h>
> +#include <linux/fs.h>
> +#include <linux/fpga-mgr.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#include <linux/pm.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
> +
> +struct fpga_mgr_bus_priv {
> +	struct device *dev;
> +	struct device_node *np;
> +	struct fpga_manager *mgr;
> +	const char *path;
> +};
> +
> +static int fpga_mgr_bus_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device *dev = &pdev->dev;
> +	struct fpga_mgr_bus_priv *priv;
> +	const char *path;
> +	struct fpga_manager *mgr;
> +	int ret = 0;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	/* Find the FPGA Manager to associate with */
> +	mgr = of_fpga_mgr_dev_lookup(np, "fpgamgr");
> +	if (!mgr) {
> +		dev_err(mgr->dev, "%s could not find fpga mgr\n", __func__);
> +		return -ENODEV;
> +	}
> +
> +	/* Find the FPGA image on the firmware path */
> +	of_property_read_string(np, "fpga-firmware", &path);
> +
> +	ret = fpga_mgr_firmware_write(mgr, path);
> +	if (ret != 0) {
> +		dev_err(mgr->dev, "%s fpga mgr write failure\n", __func__);
> +		return -EIO;
> +	}
> +
> +	priv->dev = dev;
> +	priv->np = np;
> +	priv->mgr = mgr;
> +	priv->path = path;
> +	platform_set_drvdata(pdev, priv);
> +
> +	return 0;
> +}
> +
> +/* Called when the Device Tree overlay is removed */
> +static int fpga_mgr_bus_remove(struct platform_device *pdev)
> +{
> +	struct fpga_mgr_bus_priv *priv = platform_get_drvdata(pdev);
> +	struct fpga_manager *mgr = priv->mgr;
> +
> +	return fpga_mgr_reset(mgr);
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id fpga_mgr_bus_of_match[] = {
> +	{ .compatible = "fpga-mgr-bus", },
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, fpga_mgr_bus_of_match);
> +#endif
> +
> +static struct platform_driver fpga_mgr_bus_driver = {
> +	.probe = fpga_mgr_bus_probe,
> +	.remove = fpga_mgr_bus_remove,
> +	.driver = {
> +		.name	= "fpga_manager_bus",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(fpga_mgr_bus_of_match),
> +	},
> +};
> +
> +static int __init fpga_mgr_bus_init(void)
> +{
> +	return platform_driver_register(&fpga_mgr_bus_driver);
> +}
> +
> +static void __exit fpga_mgr_bus_exit(void)
> +{
> +	platform_driver_unregister(&fpga_mgr_bus_driver);
> +}
> +
> +module_init(fpga_mgr_bus_init);
> +module_exit(fpga_mgr_bus_exit);
> +
> +MODULE_AUTHOR("Alan Tull <atull@opensource.altera.com>");
> +MODULE_DESCRIPTION("Altera FPGA Manager Bus");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
> index 0c7236a..fed13a6 100644
> --- a/drivers/fpga/fpga-mgr.c
> +++ b/drivers/fpga/fpga-mgr.c
> @@ -350,6 +350,29 @@ const struct attribute_group *fpga_mgr_groups[] = {
>  #define fpga_mgr_groups NULL
>  #endif /* CONFIG_FPGA_MGR_SYSFS */
>  
> +/* Find the fpga manager that is pointed to by a phandle */
> +struct fpga_manager *of_fpga_mgr_dev_lookup(struct device_node *node,
> +					    const char *mgr_property)
> +{
> +	struct fpga_manager *mgr;
> +	struct device_node *mgr_node;
> +
> +	mgr_node = of_parse_phandle(node, mgr_property, 0);
> +	if (!mgr_node)
> +		return NULL;
> +
> +	list_for_each_entry(mgr, &fpga_manager_list, list)
> +		if (mgr_node == mgr->np) {
> +			of_node_put(mgr_node);
> +			return mgr;
> +		}
> +
> +	of_node_put(mgr_node);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(of_fpga_mgr_dev_lookup);
> +
>  static int fpga_mgr_suspend(struct device *dev)
>  {
>  	struct fpga_manager *mgr = dev_get_drvdata(dev);
> diff --git a/include/linux/fpga-mgr.h b/include/linux/fpga-mgr.h
> index 97c7e0b..abf2699 100644
> --- a/include/linux/fpga-mgr.h
> +++ b/include/linux/fpga-mgr.h
> @@ -110,6 +110,8 @@ int fpga_mgr_register(struct platform_device *pdev,
>  		      struct fpga_manager_ops *mops,
>  		      const char *name, void *priv);
>  void fpga_mgr_remove(struct platform_device *pdev);
> +struct fpga_manager *of_fpga_mgr_dev_lookup(struct device_node *node,
> +					    const char *mgr_property);
>  
>  #endif /* CONFIG_FPGA */
>  #endif /*_LINUX_FPGA_MGR_H */
> -- 
> 1.7.9.5
> 
> 
