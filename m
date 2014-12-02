Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaLBKwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:52:25 -0500
Received: from mail-bn1on0055.outbound.protection.outlook.com ([157.56.110.55]:6195
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752089AbaLBKwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:52:20 -0500
Date: Tue, 2 Dec 2014 11:52:08 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, <monstr@monstr.eu>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>, Jingoo Han <jg1.han@samsung.com>,
        Sandeep Nair <sandeep_n@ti.com>, Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>,
        Andy Gross <agross@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 6/7] ARM: zynq: Add OCM controller driver
References: <cover.1417440250.git.michal.simek@xilinx.com>
 <4788755d350890d81f1bac4bf237c5ddfb68b795.1417440250.git.michal.simek@xilinx.com>
 <4151221.1fPmelvPbd@wuerfel>
In-Reply-To: <4151221.1fPmelvPbd@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21144.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <cb2f95cd81334264af358b7ca0ac201b@BN1BFFO11FD021.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(377454003)(164054003)(24454002)(479174003)(189002)(51704005)(21056001)(104016003)(76176999)(62966003)(74316001)(20776003)(47776003)(102836001)(31966008)(99396003)(6806004)(95666004)(15975445006)(19580405001)(44976005)(19580395003)(83506001)(4396001)(106466001)(86362001)(64126003)(108616004)(23746002)(120916001)(33646002)(50466002)(54356999)(46102003)(107046002)(65956001)(92566001)(50986999)(77156002)(87936001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB053;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB053;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB053;
X-Forefront-PRVS: 0413C9F1ED
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB053;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 04:31 PM, Arnd Bergmann wrote:
> On Monday 01 December 2014 14:24:57 Michal Simek wrote:
>> The driver provide memory allocator which can
>> be used by others drivers to allocate memory inside OCM.
>> All locations for 64kB blocks are supported
>> and driver is trying to allocate the largest continuous
>> block of memory.
>>
>> Checking mpcore addressing filterring is not done here
>> but could be added in future.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> 
> The driver doesn't actually have any interface as far as I can tell,
> so I wonder how you expect it to be used.
> 
> Do you have a list of drivers that would be using it?

For supporting suspend you have to save content to OCM memory
and you need any driver which is providing generic functionality
to allocate that memory for it.

Here is example - it is not upstream because we need to get OCM driver
to mainline first.
https://github.com/Xilinx/linux-xlnx/blob/master/arch/arm/mach-zynq/pm.c

The second example is to use OCM memory for storing BD for ethernet controller.
OCM is fast memory accessible IRC in one cycle which increase bandwidth.

For all of these you need the driver which provide you the way how to allocate
memory from OCM.

> How does it relate to the generic "mmio-sram" binding? Is this
> meant as a specialization?

This driver was based on mmio-sram which does the same. Provide you a way
how to allocate memory space in any sram memory on chip.
It is design for static case but not for dynamic one like this one.

As I pointed in cover letter there could be an option to use mmio-sram driver
but there must be any way how to create DT description at run-time or choose
configuration at run-time.

>> +/**
>> + * zynq_ocmc_irq_handler - Interrupt service routine of the OCM controller
>> + * @irq:	IRQ number
>> + * @data:	Pointer to the zynq_ocmc_dev structure
>> + *
>> + * Return:     IRQ_HANDLED always
>> + */
>> +static irqreturn_t zynq_ocmc_irq_handler(int irq, void *data)
>> +{
>> +	u32 sts;
>> +	u32 err_addr;
>> +	struct zynq_ocmc_dev *zynq_ocmc = data;
>> +
>> +	/* check status */
>> +	sts = readl(zynq_ocmc->base + ZYNQ_OCMC_IRQ_STS);
>> +	if (sts & ZYNQ_OCMC_IRQ_STS_ERR_MASK) {
>> +		/* check error address */
>> +		err_addr = readl(zynq_ocmc->base + ZYNQ_OCMC_PARITY_ERRADDRESS);
>> +		pr_err("%s: OCM err intr generated at 0x%04x (stat: 0x%08x).",
>> +		       __func__, err_addr, sts & ZYNQ_OCMC_IRQ_STS_ERR_MASK);
>> +	}
>> +	pr_warn("%s: Interrupt generated by OCM, but no error is found.",
>> +		__func__);
>> +
>> +	return IRQ_HANDLED;
>> +}
> 
> I'm also puzzled by this: you don't really do anything here but print
> a message. What is the purpose of this interrupt? As this looks unrelated
> to the rest of the driver, maybe this should be part of drivers/edac
> instead?

yes - it is just showing that there is error in OCM.
It can be added to edac - no problem to do so but the driver will be
really simple that's why not sure if make sense to do it.

> 
>> +static int zynq_ocmc_probe(struct platform_device *pdev)
>> +{
>> +       int ret;
>> +       struct zynq_ocmc_dev *zynq_ocmc;
>> +       u32 i, ocm_config, curr;
>> +       struct resource *res;
>> +
>> +       ocm_config = zynq_slcr_get_ocm_config();
>> +
>> +       zynq_ocmc = devm_kzalloc(&pdev->dev, sizeof(*zynq_ocmc),
>> GFP_KERNEL);
>> +       if (!zynq_ocmc)
>> +               return -ENOMEM;
>> +
>> +       zynq_ocmc->pool = devm_gen_pool_create(&pdev->dev,
>> +                                              ilog2(ZYNQ_OCMC_GRANULARITY),
>> +                                              -1);
>> +       if (!zynq_ocmc->pool)
>> +               return -ENOMEM;
>> +
>> +       curr = 0; /* For storing current struct resource for OCM */
>> +       for (i = 0; i < ZYNQ_OCMC_BLOCKS; i++) {
>> +               u32 base, start, end;
>> +
>> +               /* Setup base address for 64kB OCM block */
>> +               if (ocm_config & BIT(i))
>> +                       base = ZYNQ_OCMC_HIGHADDR;
>> +               else
>> +                       base = ZYNQ_OCMC_LOWADDR;
> 
> You write in the introductory mail that you want to support detecting the
> address from the slcr, and possibly even allow changing it at runtime,
> but I don't understand what that would be good for.

Note: PL means programmable logic

On zynq you can use memory from fixed part which starts from 0 to ddr size.
That's one configuration.
The second is to add memory controller just to PL - the use case can be that
memory controller in PL will provide better bandwidth (because of customization)
for your application and this memory can't started from 0. Most of the time
it starts from 0x40000000. But you need to have memory at 0 for adding reset vectors
or standalone application running on the second ARM core that's why you can
place there OCM.

It means it is up to users what configuration they want/need to use that's why
OCM is divided to 4 64k blocks which you can place to any location you like.
it is 16 combinations.

Chip can be setup to use any of this combination without any capable bootloader
that's why relating on bootloader is not solution. Also problematic for upgrading
the system.

> It's not uncommon to describe in DT settings that one can also find
> out from hardware but that are set up by the boot loader in a particular
> way. Why not this one? 

It is 16 combinations how these 4 blocks can be placed together but only
one reliable way is to check SLCR configuration and based on reg setup.

I can add all these 16 combinations to DTS and detect configuration in SLCR
and then change any status property for that particular configuration
but it will be more ugly than this solution.

Note: Just place there 4/8 blocks with low and high locations is not good
because the maximum allocated size will be just 64k.

> For all I can tell, that would let you simply
> use one driver for the EDAC and the generic mmio-sram from the memory,
> without the need to do anything further.

EDAC driver - no problem to do it and make sense.
Using mmio-sram for one fixed configuration is easy but not sure if this is
the right thing to do.
Listing all combinations in DTS file is quite easy to do but mechanism
to select one combination is the key for it.

Thanks,
Michal

