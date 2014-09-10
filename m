Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaIJTba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:31:30 -0400
Received: from mail-bn1on0067.outbound.protection.outlook.com ([157.56.110.67]:32256
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751044AbaIJTb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:31:27 -0400
Date: Wed, 10 Sep 2014 14:11:19 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Weike Chen <alvin.chen@intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4 v3] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
In-Reply-To: <1410286081-16653-2-git-send-email-alvin.chen@intel.com>
Message-ID: <alpine.DEB.2.02.1409101353500.2790@atx-linux-37>
References: <1410286081-16653-1-git-send-email-alvin.chen@intel.com> <1410286081-16653-2-git-send-email-alvin.chen@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA034.namprd04.prod.outlook.com (10.141.154.152) To
 BLUPR03MB310.namprd03.prod.outlook.com (10.141.48.25)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009019)(6009001)(24454002)(51704005)(189002)(199003)(33716001)(46102001)(105586002)(90102001)(4396001)(54356999)(21056001)(76176999)(50986999)(85306004)(85852003)(83072002)(101416001)(76482001)(83506001)(20776003)(87976001)(66066001)(80022001)(86362001)(97736003)(64706001)(47776003)(46406003)(81542001)(92726001)(110136001)(86152002)(92566001)(102836001)(107046002)(81156004)(106356001)(83322001)(19580405001)(19580395003)(69596002)(81342001)(23726002)(77096002)(50466002)(74502001)(74662001)(53416004)(99396002)(95666004)(31966008)(77982001)(42186005)(79102001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB310;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014, Weike Chen wrote:

> The Synopsys DesignWare APB GPIO driver only supports open firmware devices.
> But, like Intel Quark X1000 SOC, which has a single PCI function exporting
> a GPIO and an I2C controller, it is a Multifunction device. This patch is
> to enable the current Synopsys DesignWare APB GPIO driver to support the
> Multifunction device which exports the designware GPIO controller.
> 
> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> Signed-off-by: Weike Chen <alvin.chen@intel.com>

Hi Alvin,

I did a quick test and this looks like it works for me (with device tree).
I had a couple of small fixes below.

Alan

>  
> -	port->bgc.gc.ngpio = ngpio;
> -	port->bgc.gc.of_node = port_np;
> +#ifdef CONFIG_OF_GPIO
> +	port->bgc.gc.of_node = pp->node;
> +#endif

Please use 'if (IS_ENABLED(CONFIG_OF_GPIO)) as a conditional as you do
elsewhere.

>  static int dwapb_gpio_probe(struct platform_device *pdev)
>  {
> +	int i;
>  	struct resource *res;
>  	struct dwapb_gpio *gpio;
> -	struct device_node *np;
>  	int err;
> -	unsigned int offs = 0;
> +	struct device *dev = &pdev->dev;
> +	struct dwapb_platform_data *pdata = dev_get_platdata(dev);
> +	bool is_pdata_alloc = !pdata;

Please combine the int's in one line (int err, i;) and put them as
the last one on this list.  It looks the same to the compiler of
course, but more uniform for human eyes :)

