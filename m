Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaKDW5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:57:37 -0500
Received: from mail-by2on0092.outbound.protection.outlook.com ([207.46.100.92]:34971
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751604AbaKDW5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:57:34 -0500
Message-ID: <545959E8.2040005@opensource.altera.com>
Date: Tue, 4 Nov 2014 16:57:44 -0600
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <dougthompson@xmission.com>, <m.chehab@samsung.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <dinguyen@opensource.altera.com>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <tthayer.linux@gmail.com>
Subject: Re: [PATCHv3 4/5] edac: altera: Add Altera L2 Cache and OCRAM EDAC
 Support
References: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com> <1414683131-20786-5-git-send-email-tthayer@opensource.altera.com> <20141104151214.GD9570@pd.tnic>
In-Reply-To: <20141104151214.GD9570@pd.tnic>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: HKXPR03CA0023.apcprd03.prod.outlook.com (10.141.129.13) To
 BY2PR03MB127.namprd03.prod.outlook.com (10.242.36.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB127;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(479174003)(24454002)(199003)(377454003)(189002)(51704005)(83506001)(65816999)(4396001)(76176999)(46102003)(86362001)(107046002)(33656002)(77096003)(122386002)(19580405001)(77156002)(40100003)(19580395003)(59896002)(54356999)(99136001)(105586002)(106356001)(80316001)(50986999)(87266999)(62966003)(95666004)(23676002)(20776003)(47776003)(102836001)(64706001)(101416001)(21056001)(120916001)(31966008)(65956001)(110136001)(64126003)(97736003)(66066001)(87976001)(92726001)(50466002)(42186005)(92566001)(99396003)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB127;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris!

On 11/04/2014 09:12 AM, Borislav Petkov wrote:
> On Thu, Oct 30, 2014 at 10:32:10AM -0500, tthayer@opensource.altera.com wrote:
>> From: Thor Thayer <tthayer@opensource.altera.com>
>>
>> Adding L2 Cache and On-Chip RAM EDAC support for the
>> Altera SoCs using the EDAC device  model. The SDRAM
>> controller is using the Memory Controller model. All
>> Altera EDAC functions live in altera_edac.c.
>>
>> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
>> ---
>> v2: Fix L2 dependency comments.
>>
>> v3: Move OCRAM and L2 cache EDAC functions into altera_edac.c
>>      instead of separate files.
>> ---
>>   drivers/edac/Kconfig       |   14 ++
>>   drivers/edac/Makefile      |    5 +-
>>   drivers/edac/altera_edac.c |  475 +++++++++++++++++++++++++++++++++++++++++++-
>>   3 files changed, 492 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
>> index 1719975..b145a52 100644
>> --- a/drivers/edac/Kconfig
>> +++ b/drivers/edac/Kconfig
>> @@ -385,4 +385,18 @@ config EDAC_ALTERA_MC
>>   	  preloader must initialize the SDRAM before loading
>>   	  the kernel.
>>   
>> +config EDAC_ALTERA_L2C
>> +	bool "Altera L2 Cache EDAC"
>> +	depends on EDAC_MM_EDAC=y && ARCH_SOCFPGA && CACHE_L2X0
>> +	help
>> +	  Support for error detection and correction on the
>> +	  Altera L2 cache Memory for Altera SoCs.
>> +
>> +config EDAC_ALTERA_OCRAM
>> +	bool "Altera On-Chip RAM EDAC"
>> +	depends on EDAC_MM_EDAC=y && ARCH_SOCFPGA && SRAM && GENERIC_ALLOCATOR
>> +	help
>> +	  Support for error detection and correction on the
>> +	  Altera On-Chip RAM Memory for Altera SoCs.
> Why are those separate config items? Why not switch on EDAC_ALTERA_MC
> and get it all?
>
> We can always split them out later, if needed but I don't think
> we should burden the user with unnecessary questions if it is not
> absolutely necessary.
We want to at least separate L2/OCRAM ECC from the SDRAM ECC because
1) the SDRAM preparation can take almost 2 seconds on boot and some 
customers need a faster boot time.
2) the SDRAM has an ECC initialization dependency on the preloader which 
is outside the kernel. It is desirable to be able to turn the SDRAM on & 
off separately.

You bring up a good point about the L2 and OCRAM being combined though.

If we do want granular control, maybe I should use a submenu? Or isn't 
that desirable either?
>> +
>>   endif # EDAC
>> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
>> index 359aa49..fa8aebc 100644
>> --- a/drivers/edac/Makefile
>> +++ b/drivers/edac/Makefile
>> @@ -66,4 +66,7 @@ obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
>>   obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
>>   obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
>>   
>> -obj-$(CONFIG_EDAC_ALTERA_MC)		+= altera_edac.o
>> +alt_edac-y				:= altera_edac.o
>> +obj-$(CONFIG_EDAC_ALTERA_MC)		+= alt_edac.o
>> +obj-$(CONFIG_EDAC_ALTERA_L2C)		+= alt_edac.o
>> +obj-$(CONFIG_EDAC_ALTERA_OCRAM)		+= alt_edac.o
>> diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
>> index 3c4929f..1ee8d94 100644
>> --- a/drivers/edac/altera_edac.c
>> +++ b/drivers/edac/altera_edac.c
>> @@ -17,8 +17,10 @@
>>    * Adapted from the highbank_mc_edac driver.
>>    */
>>   
>> +#include <asm/cacheflush.h>
>>   #include <linux/ctype.h>
>>   #include <linux/edac.h>
>> +#include <linux/genalloc.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/kernel.h>
>>   #include <linux/mfd/syscon.h>
>> @@ -33,6 +35,7 @@
>>   
>>   #define EDAC_MOD_STR		"altera_edac"
>>   #define EDAC_VERSION		"1"
>> +#define EDAC_DEVICE		"DEVICE"
> That name is not very descriptive.
I will change to using "Altera EDAC Device"
>>   /* SDRAM Controller CtrlCfg Register */
>>   #define CTLCFG_OFST             0x00
>> @@ -107,6 +110,30 @@ struct altr_sdram_mc_data {
>>   	struct regmap *mc_vbase;
>>   };
>>   
>> +/************************** EDAC Device Defines **************************/
>> +
>> +/* OCRAM ECC Management Group Defines */
>> +#define ALTR_MAN_GRP_OCRAM_ECC_OFFSET   0x04
>> +#define ALTR_OCR_ECC_EN_MASK            0x00000001
>> +#define ALTR_OCR_ECC_INJS_MASK          0x00000002
>> +#define ALTR_OCR_ECC_INJD_MASK          0x00000004
>> +#define ALTR_OCR_ECC_SERR_MASK          0x00000008
>> +#define ALTR_OCR_ECC_DERR_MASK          0x00000010
>> +
>> +/* MPU L2 Register Defines */
>> +#define ALTR_MPUL2_CONTROL_OFFSET       0x100
>> +#define ALTR_MPUL2_CTL_CACHE_EN_MASK    0x00000001
>> +
>> +/* L2 ECC Management Group Defines */
>> +#define ALTR_MAN_GRP_L2_ECC_OFFSET      0x00
>> +#define ALTR_L2_ECC_EN_MASK             0x00000001
>> +#define ALTR_L2_ECC_INJS_MASK           0x00000002
>> +#define ALTR_L2_ECC_INJD_MASK           0x00000004
> You can use BIT() for those.
Thanks. I will change this.
>> +
>> +/*********************** EDAC Memory Controller Functions ****************/
>> +
>> +/* The SDRAM controller uses the EDAC Memory Controller framework.       */
>> +
>>   static irqreturn_t altr_sdram_mc_err_handler(int irq, void *dev_id)
>>   {
>>   	struct mem_ctl_info *mci = dev_id;
>> @@ -405,6 +432,452 @@ static struct platform_driver altr_sdram_edac_driver = {
>>   
>>   module_platform_driver(altr_sdram_edac_driver);
>>   
>> +/************************* EDAC Device Functions *************************/
>> +
>> +/*
>> + * EDAC Device Functions (shared between various IPs).
>> + * The discrete memories use the EDAC Device framework. The probe
>> + * and error handling functions are very similar between memories
>> + * so they are shared. The memory allocation and free for EDAC trigger
>> + * testing are different for each memory.
>> + */
>> +
>> +const struct edac_device_prv_data ocramecc_data;
>> +const struct edac_device_prv_data l2ecc_data;
>> +
>> +struct edac_device_prv_data {
>> +	int (*setup)(struct platform_device *pdev, void __iomem *base);
>> +	int ce_clear_mask;
>> +	int ue_clear_mask;
>> +#ifdef CONFIG_EDAC_DEBUG
>> +	struct edac_dev_sysfs_attribute *eccmgr_sysfs_attr;
>> +	void * (*alloc_mem)(size_t size, void **other);
>> +	void (*free_mem)(void *p, size_t size, void *other);
>> +	int ecc_enable_mask;
>> +	int ce_set_mask;
>> +	int ue_set_mask;
>> +	int trig_alloc_sz;
>> +#endif
>> +};
>> +
>> +struct altr_edac_device_dev {
>> +	void __iomem *base;
>> +	int sb_irq;
>> +	int db_irq;
>> +	const struct edac_device_prv_data *data;
>> +	char *edac_dev_name;
>> +};
>> +
>> +static irqreturn_t altr_edac_device_handler(int irq, void *dev_id)
>> +{
>> +	struct edac_device_ctl_info *dci = dev_id;
>> +	struct altr_edac_device_dev *drvdata = dci->pvt_info;
>> +	const struct edac_device_prv_data *priv = drvdata->data;
>> +
>> +	if (irq == drvdata->sb_irq) {
>> +		if (priv->ce_clear_mask)
>> +			writel(priv->ce_clear_mask, drvdata->base);
>> +		edac_device_handle_ce(dci, 0, 0, drvdata->edac_dev_name);
>> +	}
>> +	if (irq == drvdata->db_irq) {
>> +		if (priv->ue_clear_mask)
>> +			writel(priv->ue_clear_mask, drvdata->base);
>> +		edac_device_handle_ue(dci, 0, 0, drvdata->edac_dev_name);
>> +		panic("\nEDAC:ECC_DEVICE[Uncorrectable errors]\n");
>> +	}
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +#ifdef CONFIG_EDAC_DEBUG
>> +ssize_t altr_edac_device_trig(struct edac_device_ctl_info *edac_dci,
>> +			      const char *buffer, size_t count)
>> +{
>> +	u32 *ptemp, i, error_mask;
>> +	int result = 0;
>> +	unsigned long flags;
>> +	struct altr_edac_device_dev *drvdata = edac_dci->pvt_info;
>> +	const struct edac_device_prv_data *priv = drvdata->data;
>> +	void *generic_ptr = edac_dci->dev;
>> +
>> +	if (!priv->alloc_mem)
>> +		return -ENOMEM;
>> +
>> +	/* Note that generic_ptr is initialized to the device * but in
>> +	 * some init_functions, this is overridden and returns data    */
> Kernel comment style:
>
> 	/*
> 	 * Blabla.
> 	 * More Bla.
> 	 */
Whoops. Sorry - I should have caught this. Weird that checkpatch.pl 
didn't notice...
>> +	ptemp = priv->alloc_mem(priv->trig_alloc_sz, &generic_ptr);
>> +	if (!ptemp) {
>> +		edac_printk(KERN_ERR, EDAC_DEVICE,
>> +			    "Inject: Buffer Allocation error\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	if (count == 3)
> Magic number 3.
>
> /me needs crystal ball :)
Will fix.
>> +		error_mask = priv->ue_set_mask;
>> +	else
>> +		error_mask = priv->ce_set_mask;
>> +
>> +	edac_printk(KERN_ALERT, EDAC_DEVICE,
>> +		    "Trigger Error Mask (0x%X)\n", error_mask);
>> +
>> +	local_irq_save(flags);
>> +	/* write ECC corrupted data out. */
>> +	for (i = 0; i < (priv->trig_alloc_sz/sizeof(*ptemp)); i++) {
>> +		/* Read data so we're in the correct state */
>> +		rmb();
>> +		if (ACCESS_ONCE(ptemp[i]))
>> +			result = -1;
>> +		/* Toggle Error bit (it is latched), leave ECC enabled */
>> +		writel(error_mask, drvdata->base);
>> +		writel(priv->ecc_enable_mask, drvdata->base);
>> +		ptemp[i] = i;
>> +	}
>> +	/* Ensure it has been written out */
>> +	wmb();
>> +	local_irq_restore(flags);
> Doesn't the interrupt reenabling on ARM already cause outstanding writes
> to commit so that you don't really need the memory barrier?
I wasn't aware of this but it would make sense.

When I looked at the inline assembly of the irq_restore(), it didn't 
have a memory barrier instruction in it (DSB). It did have the : 
"memory" for the clobbered register but I don't think that is the same 
thing. I will continue looking into this.
>> +
>> +	if (result)
>> +		edac_printk(KERN_ERR, EDAC_DEVICE, "Mem Not Cleared\n");
>> +
>> +	/* Read out written data. ECC error caused here */
>> +	for (i = 0; i < 16; i++)
> Magic number 16. Where's my ball again?! :)
Thanks. I will fix it.
>> +		if (ACCESS_ONCE(ptemp[i]) != i)
>> +			edac_printk(KERN_ERR, EDAC_DEVICE,
>> +				    "Mem Doesn't match\n");
> I guess injectors should know what this printk means? I can assume
> it says something about inject data written doesn't match what we're
> reading?
You are correct and I will make the message more descriptive.
>> +
>> +	if (priv->free_mem)
>> +		priv->free_mem(ptemp, priv->trig_alloc_sz, generic_ptr);
>> +
>> +	return count;
>> +}
>> +
>> +static void altr_set_sysfs_attr(struct edac_device_ctl_info *edac_dci,
>> +				const struct edac_device_prv_data *priv)
>> +{
>> +	struct edac_dev_sysfs_attribute *ecc_attr = priv->eccmgr_sysfs_attr;
>> +
>> +	if (ecc_attr) {
>> +		edac_dci->sysfs_attributes =  ecc_attr;
>> +		edac_printk(KERN_ERR, EDAC_DEVICE, "Set SysFS trigger\n");
> Why do we have to say this here? Debugging leftovers maybe?
Yes, thank you. I will remove.
>> +	}
>> +}
>> +#else
>> +static void altr_set_sysfs_attr(struct edac_device_ctl_info *edac_dci,
>> +				const struct edac_device_prv_data *priv)
>> +{}
>> +#endif	/* #ifdef CONFIG_EDAC_DEBUG */
>> +
>> +static const struct of_device_id altr_edac_device_of_match[] = {
>> +#ifdef CONFIG_EDAC_ALTERA_L2C
>> +	{ .compatible = "altr,l2-edac", .data = (void *)&l2ecc_data },
>> +#endif
>> +#ifdef CONFIG_EDAC_ALTERA_OCRAM
>> +	{ .compatible = "altr,ocram-edac", .data = (void *)&ocramecc_data },
>> +#endif
> If you enable l2c and ocram by default, you can save yourself the ugly
> ifdeffery here too.
Yes. I just need to confirm the granularity needed to determine if I can 
combine these as you suggest.
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, altr_edac_device_of_match);
>> +
>> +/*
>> + * altr_edac_device_probe()
>> + *	This is a generic EDAC device driver that will support
>> + *	various Altera memory devices such as the L2 cache ECC and
>> + *	OCRAM ECC as well as the memories for other peripherals.
>> + *	Module specific initialization is done by passing the
>> + *	function index in the device tree.
>> + */
>> +static int altr_edac_device_probe(struct platform_device *pdev)
>> +{
>> +	struct edac_device_ctl_info *dci;
>> +	struct altr_edac_device_dev *drvdata;
>> +	struct resource *r;
>> +	int res = 0;
>> +	struct device_node *np = pdev->dev.of_node;
>> +	char *ecc_name = (char *)np->name;
>> +	static int dev_instance;
>> +
>> +	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
>> +		return -ENOMEM;
>> +
>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!r) {
>> +		edac_printk(KERN_ERR, EDAC_DEVICE,
>> +			    "Unable to get mem resource\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (!devm_request_mem_region(&pdev->dev, r->start, resource_size(r),
>> +				     dev_name(&pdev->dev))) {
>> +		edac_printk(KERN_ERR, EDAC_DEVICE,
>> +			    "%s:Error requesting mem region\n", ecc_name);
>> +		return -EBUSY;
>> +	}
>> +
>> +	dci = edac_device_alloc_ctl_info(sizeof(*drvdata), ecc_name,
>> +					 1, ecc_name, 1, 0, NULL, 0,
>> +					 dev_instance++);
>> +
>> +	if (!dci)
>> +		return -ENOMEM;
>> +
>> +	drvdata = dci->pvt_info;
>> +	dci->dev = &pdev->dev;
>> +	platform_set_drvdata(pdev, dci);
>> +	drvdata->edac_dev_name = ecc_name;
>> +
>> +	drvdata->base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
>> +	if (!drvdata->base) {
>> +		edac_printk(KERN_ERR, EDAC_DEVICE,
>> +			    "%s:Unable to map regs\n", ecc_name);
>> +		return -ENOMEM;
> This should be goto err, no? To unwind what edac_device_alloc_ctl_info()
> allocated.
Yes. Thank you.
>> +	}
>> +
>> +	/* Get driver specific data for this EDAC device */
>> +	drvdata->data = of_match_node(altr_edac_device_of_match, np)->data;
>> +
>> +	/* Check specific dependencies for the module */
>> +	if (drvdata->data->setup) {
>> +		res = drvdata->data->setup(pdev, drvdata->base);
>> +		if (res < 0)
>> +			goto err;
>> +	}
>> +
>> +	drvdata->sb_irq = platform_get_irq(pdev, 0);
>> +	res = devm_request_irq(&pdev->dev, drvdata->sb_irq,
>> +			       altr_edac_device_handler,
>> +			       0, dev_name(&pdev->dev), dci);
>> +	if (res < 0)
>> +		goto err;
>> +
>> +	drvdata->db_irq = platform_get_irq(pdev, 1);
>> +	res = devm_request_irq(&pdev->dev, drvdata->db_irq,
>> +			       altr_edac_device_handler,
>> +			       0, dev_name(&pdev->dev), dci);
>> +	if (res < 0)
>> +		goto err;
>> +
>> +	dci->mod_name = "EDAC_DEVICE";
> Maybe more descriptive name with "ALTERA" in it?
OK. Changing to "Altera EDAC Memory". Still generic since it is shared 
with L2 and OCRAM.
>> +	dci->dev_name = drvdata->edac_dev_name;
>> +
>> +	altr_set_sysfs_attr(dci, drvdata->data);
>> +
>> +	if (edac_device_add_device(dci))
>> +		goto err;
>> +
>> +	devres_close_group(&pdev->dev, NULL);
>> +
>> +	return 0;
>> +err:
>> +	devres_release_group(&pdev->dev, NULL);
>> +	edac_device_free_ctl_info(dci);
>> +
>> +	return res;
>> +}
>> +
>> +static int altr_edac_device_remove(struct platform_device *pdev)
>> +{
>> +	struct edac_device_ctl_info *dci = platform_get_drvdata(pdev);
>> +
>> +	edac_device_del_device(&pdev->dev);
>> +	edac_device_free_ctl_info(dci);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver altr_edac_device_driver = {
>> +	.probe =  altr_edac_device_probe,
>> +	.remove = altr_edac_device_remove,
>> +	.driver = {
>> +		.name = "altr_edac_device",
>> +		.of_match_table = altr_edac_device_of_match,
>> +	},
>> +};
>> +module_platform_driver(altr_edac_device_driver);
>> +
>> +/*********************** OCRAM EDAC Device Functions *********************/
>> +
>> +#ifdef CONFIG_EDAC_ALTERA_OCRAM
>> +
>> +#ifdef CONFIG_EDAC_DEBUG
>> +static void *ocram_alloc_mem(size_t size, void **other)
>> +{
>> +	struct device_node *np;
>> +	struct gen_pool *gp;
>> +	void *sram_addr;
>> +
>> +	np = of_find_compatible_node(NULL, NULL, "altr,ocram-edac");
>> +	if (!np)
>> +		return NULL;
>> +
>> +	gp = of_get_named_gen_pool(np, "iram", 0);
>> +	if (!gp)
>> +		return NULL;
>> +	*other = gp;
> There's this assignment here to the supplied pointer...
>
>> +
>> +	sram_addr = (void *)gen_pool_alloc(gp, size);
>> +	if (!sram_addr)
>> +		return NULL;
> ... and when we fail here, caller still gets to play with it. Perhaps do
> the assignment after all calls here have succeeded first...?
>
The caller tests the return value which is set properly on an error 
condition (NULL). However, this is better and I will make the change. 
Thank you.
>> +
>> +	memset(sram_addr, 0, size);
>> +	wmb();	/* Ensure data is written out */
>> +
>> +	return sram_addr;
>> +}
>> +
>> +static void ocram_free_mem(void *p, size_t size, void *other)
>> +{
>> +	gen_pool_free((struct gen_pool *)other, (u32)p, size);
>> +}
>> +
>> +static struct edac_dev_sysfs_attribute altr_ocr_sysfs_attributes[] = {
>> +	{
>> +		.attr = { .name = "altr_ocram_trigger",
>> +			  .mode = (S_IRUGO | S_IWUSR) },
>> +		.show = NULL,
>> +		.store = altr_edac_device_trig
>> +	},
>> +	{
>> +		.attr = {.name = NULL }
>> +	}
>> +};
>> +#endif	/* #ifdef CONFIG_EDAC_DEBUG */
>> +
>> +/*
>> + * altr_ocram_dependencies()
>> + *	Test for OCRAM cache ECC dependencies upon entry because
>> + *	platform specific startup should have initialized the
>> + *	On-Chip RAM memory and enabled the ECC.
>> + *	Can't turn on ECC here because accessing un-initialized
>> + *	memory will cause CE/UE errors possibly causing an ABORT.
>> + */
>> +static int altr_ocram_dependencies(struct platform_device *pdev,
>> +				   void __iomem *base)
>> +{
>> +	u32 control;
>> +
>> +	control = readl(base) & ALTR_OCR_ECC_EN_MASK;
>> +	if (!control) {
>> +		dev_err(&pdev->dev,
>> +			"OCRAM: No ECC present or ECC disabled.\n");
>> +		return -ENODEV;
>> +	}
> Flip logic to save an indentation level:
>
> 	if (control)
> 		return 0;
>
> 	dev_err...
> 	return -ENODEV;
Thank you for reviewing. I will make the change.
>> +
>> +	return 0;
>> +}
>> +
>> +const struct edac_device_prv_data ocramecc_data = {
>> +	.setup = altr_ocram_dependencies,
>> +	.ce_clear_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_SERR_MASK),
>> +	.ue_clear_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_DERR_MASK),
>> +#ifdef CONFIG_EDAC_DEBUG
>> +	.eccmgr_sysfs_attr = altr_ocr_sysfs_attributes,
>> +	.alloc_mem = ocram_alloc_mem,
>> +	.free_mem = ocram_free_mem,
>> +	.ecc_enable_mask = ALTR_OCR_ECC_EN_MASK,
>> +	.ce_set_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_INJS_MASK),
>> +	.ue_set_mask = (ALTR_OCR_ECC_EN_MASK | ALTR_OCR_ECC_INJD_MASK),
>> +	.trig_alloc_sz = (32 * sizeof(u32)),
>> +#endif
>> +};
>> +
>> +#endif	/* #ifdef CONFIG_EDAC_ALTERA_OCRAM */
>> +
>> +/********************* L2 Cache EDAC Device Functions ********************/
>> +
>> +#ifdef CONFIG_EDAC_ALTERA_L2C
>> +
>> +#ifdef CONFIG_EDAC_DEBUG
>> +static void *l2_alloc_mem(size_t size, void **other)
>> +{
>> +	struct device *dev = *other;
>> +	void *ptemp = devm_kzalloc(dev, size, GFP_KERNEL);
>> +
>> +	if (!ptemp)
>> +		return NULL;
>> +
>> +	/* Make sure everything is written out */
>> +	wmb();
>> +	flush_cache_all();
>> +
>> +	return ptemp;
>> +}
>> +
>> +static void l2_free_mem(void *p, size_t size, void *other)
>> +{
>> +	struct device *dev = other;
>> +
>> +	if (dev && p)
>> +		devm_kfree(dev, p);
>> +}
>> +
>> +static struct edac_dev_sysfs_attribute altr_l2_sysfs_attributes[] = {
>> +	{
>> +		.attr = { .name = "altr_l2_trigger",
>> +			  .mode = (S_IRUGO | S_IWUSR) },
>> +		.show = NULL,
>> +		.store = altr_edac_device_trig
>> +	},
>> +	{
>> +		.attr = {.name = NULL }
>> +	}
>> +};
>> +#endif	/* #ifdef CONFIG_EDAC_DEBUG */
>> +
>> +/*
>> + * altr_l2_dependencies()
>> + *	Test for L2 cache ECC dependencies upon entry because
>> + *	platform specific startup should have initialized the L2
>> + *	memory and enabled the ECC.
>> + *	Can't turn on ECC here because accessing un-initialized
>> + *	memory will cause CE/UE errors possibly causing an ABORT.
>> + *	Bail if ECC is not on.
>> + *	Test For 1) L2 ECC is enabled and 2) L2 Cache is enabled.
>> + */
>> +static int altr_l2_dependencies(struct platform_device *pdev,
>> +				void __iomem *base)
>> +{
>> +	u32 control;
>> +	struct regmap *l2_vbase;
>> +
>> +	control = readl(base) & ALTR_L2_ECC_EN_MASK;
>> +	if (!control) {
>> +		dev_err(&pdev->dev, "L2: No ECC present, or ECC disabled\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	l2_vbase = syscon_regmap_lookup_by_compatible("arm,pl310-cache");
>> +	if (IS_ERR(l2_vbase)) {
>> +		dev_err(&pdev->dev,
>> +			"L2 ECC:regmap for arm,pl310-cache lookup failed.\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	regmap_read(l2_vbase, ALTR_MPUL2_CONTROL_OFFSET, &control);
>> +	if (!(control & ALTR_MPUL2_CTL_CACHE_EN_MASK)) {
>> +		dev_err(&pdev->dev, "L2: Cache disabled\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +const struct edac_device_prv_data l2ecc_data = {
>> +	.setup = altr_l2_dependencies,
>> +	.ce_clear_mask = 0,
>> +	.ue_clear_mask = 0,
>> +#ifdef CONFIG_EDAC_DEBUG
>> +	.eccmgr_sysfs_attr = altr_l2_sysfs_attributes,
>> +	.alloc_mem = l2_alloc_mem,
>> +	.free_mem = l2_free_mem,
>> +	.ecc_enable_mask = ALTR_L2_ECC_EN_MASK,
>> +	.ce_set_mask = (ALTR_L2_ECC_EN_MASK | ALTR_L2_ECC_INJS_MASK),
>> +	.ue_set_mask = (ALTR_L2_ECC_EN_MASK | ALTR_L2_ECC_INJD_MASK),
>> +	.trig_alloc_sz = 4 * 1024,
>> +#endif
>> +};
>> +
>> +#endif	/* #ifdef CONFIG_EDAC_ALTERA_L2C */
>> +
>>   MODULE_LICENSE("GPL v2");
>>   MODULE_AUTHOR("Thor Thayer");
>> -MODULE_DESCRIPTION("EDAC Driver for Altera SDRAM Controller");
>> +MODULE_DESCRIPTION("EDAC Driver for Altera Memories");
>> -- 
>> 1.7.9.5
>>
>>

