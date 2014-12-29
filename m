Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaL2Tcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 14:32:54 -0500
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:55078
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751542AbaL2Tcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 14:32:52 -0500
X-WSS-ID: 0NHCZMK-08-E44-02
X-M-MSG: 
Message-ID: <54A1AC5C.7000903@amd.com>
Date: Mon, 29 Dec 2014 13:32:44 -0600
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com>
 <2148776.X8NPqiYA6S@wuerfel>
 <20141023091309.GF25302@e106497-lin.cambridge.arm.com>
 <2355100.WsW1DXh57P@wuerfel>
In-Reply-To: <2355100.WsW1DXh57P@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(199003)(51704005)(164054003)(189002)(479174004)(20776003)(50466002)(80316001)(105586002)(64706001)(19580395003)(106466001)(31966008)(92566001)(83506001)(99396003)(86362001)(23746002)(120916001)(65816999)(47776003)(101416001)(54356999)(46102003)(68736005)(64126003)(87936001)(33656002)(84676001)(97736003)(2950100001)(21056001)(36756003)(65806001)(107046002)(65956001)(93886004)(50986999)(77096005)(53416004)(77156002)(62966003)(87266999)(4396001)(76176999)(41533002)(554374003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB196;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR02MB196;
X-Forefront-PRVS: 0440AC9990
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB196;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 19:32:48.8910
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR02MB196
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am not sure if this thread is still alive. I'm trying to see what I 
can do to help clean up/convert to make the PCI GHC also works for arm64 
w/ zero or minimal ifdefs.

Please let me know if someone is already working on this. I noticed that 
Lorenzo's patches has already been in 3.19-rc1, and in Bjorn's 
pci/domain branch. Otherwise, I'll try to continue the work based on the 
sample patch from Arnd here.

On 10/23/14 08:33, Arnd Bergmann wrote:
> [...]
> diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
> index 3d2076f59911..3542a7b740e5 100644
> --- a/drivers/pci/host/pci-host-generic.c
> +++ b/drivers/pci/host/pci-host-generic.c
> @@ -40,16 +40,20 @@ struct gen_pci_cfg_windows {
>
>   struct gen_pci {
>   	struct pci_host_bridge			host;
> +	struct pci_sys_data			sys;
>   	struct gen_pci_cfg_windows		cfg;
> -	struct list_head			resources;
>   };

Arnd, based on the patch here, if we are trying to use the 
pci-host-generic driver on arm64, this means that we are going to have 
to introduce struct pci_sys_data for the arm64 as well (e.g move the 
struct from include/asm/mach/pci.h to include/linux/pci.h). Is this also 
your intention?

Thanks,

Suravee

>
> +static inline struct gen_pci *gen_pci_from_sys(struct pci_sys_data *sys)
> +{
> +	return container_of(sys, struct gen_pci, sys);
> +}
> +
>   static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
>   					     unsigned int devfn,
>   					     int where)
>   {
> -	struct pci_sys_data *sys = bus->sysdata;
> -	struct gen_pci *pci = sys->private_data;
> +	struct gen_pci *pci = gen_pci_from_sys(bus->sysdata);
>   	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
>
>   	return pci->cfg.win[idx] + ((devfn << 8) | where);
> @@ -64,8 +68,7 @@ static void __iomem *gen_pci_map_cfg_bus_ecam(struct pci_bus *bus,
>   					      unsigned int devfn,
>   					      int where)
>   {
> -	struct pci_sys_data *sys = bus->sysdata;
> -	struct gen_pci *pci = sys->private_data;
> +	struct gen_pci *pci = gen_pci_from_sys(bus->sysdata);
>   	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
>
>   	return pci->cfg.win[idx] + ((devfn << 12) | where);
> @@ -80,8 +83,7 @@ static int gen_pci_config_read(struct pci_bus *bus, unsigned int devfn,
>   				int where, int size, u32 *val)
>   {
>   	void __iomem *addr;
> -	struct pci_sys_data *sys = bus->sysdata;
> -	struct gen_pci *pci = sys->private_data;
> +	struct gen_pci *pci = gen_pci_from_sys(bus->sysdata);
>
>   	addr = pci->cfg.ops->map_bus(bus, devfn, where);
>
> @@ -103,8 +105,7 @@ static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
>   				 int where, int size, u32 val)
>   {
>   	void __iomem *addr;
> -	struct pci_sys_data *sys = bus->sysdata;
> -	struct gen_pci *pci = sys->private_data;
> +	struct gen_pci *pci = gen_pci_from_sys(bus->sysdata);
>
>   	addr = pci->cfg.ops->map_bus(bus, devfn, where);
>
> @@ -181,10 +182,10 @@ static void gen_pci_release_of_pci_ranges(struct gen_pci *pci)
>   {
>   	struct pci_host_bridge_window *win;
>
> -	list_for_each_entry(win, &pci->resources, list)
> +	list_for_each_entry(win, &pci->sys.resources, list)
>   		release_resource(win->res);
>
> -	pci_free_resource_list(&pci->resources);
> +	pci_free_resource_list(&pci->sys.resources);
>   }
>
>   static int gen_pci_parse_request_of_pci_ranges(struct gen_pci *pci)
> @@ -237,7 +238,7 @@ static int gen_pci_parse_request_of_pci_ranges(struct gen_pci *pci)
>   		if (err)
>   			goto out_release_res;
>
> -		pci_add_resource_offset(&pci->resources, res, offset);
> +		pci_add_resource_offset(&pci->sys.resources, res, offset);
>   	}
>
>   	if (!res_valid) {
> @@ -306,17 +307,10 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
>   	}
>
>   	/* Register bus resource */
> -	pci_add_resource(&pci->resources, bus_range);
> +	pci_add_resource(&pci->sys.resources, bus_range);
>   	return 0;
>   }
>
> -static int gen_pci_setup(int nr, struct pci_sys_data *sys)
> -{
> -	struct gen_pci *pci = sys->private_data;
> -	list_splice_init(&pci->resources, &sys->resources);
> -	return 1;
> -}
> -
>   static int gen_pci_probe(struct platform_device *pdev)
>   {
>   	int err;
> @@ -326,17 +320,12 @@ static int gen_pci_probe(struct platform_device *pdev)
>   	struct device *dev = &pdev->dev;
>   	struct device_node *np = dev->of_node;
>   	struct gen_pci *pci = devm_kzalloc(dev, sizeof(*pci), GFP_KERNEL);
> -	struct hw_pci hw = {
> -		.nr_controllers	= 1,
> -		.private_data	= (void **)&pci,
> -		.setup		= gen_pci_setup,
> -		.map_irq	= of_irq_parse_and_map_pci,
> -		.ops		= &gen_pci_ops,
> -	};
>
>   	if (!pci)
>   		return -ENOMEM;
>
> +	pci->sys.map_irq	= of_irq_parse_and_map_pci,
> +
>   	type = of_get_property(np, "device_type", NULL);
>   	if (!type || strcmp(type, "pci")) {
>   		dev_err(dev, "invalid \"device_type\" %s\n", type);
> @@ -355,7 +344,7 @@ static int gen_pci_probe(struct platform_device *pdev)
>   	pci->cfg.ops = of_id->data;
>   	pci->host.dev.parent = dev;
>   	INIT_LIST_HEAD(&pci->host.windows);
> -	INIT_LIST_HEAD(&pci->resources);
> +	INIT_LIST_HEAD(&pci->sys.resources);
>
>   	/* Parse our PCI ranges and request their resources */
>   	err = gen_pci_parse_request_of_pci_ranges(pci);
> @@ -369,8 +358,12 @@ static int gen_pci_probe(struct platform_device *pdev)
>   		return err;
>   	}
>
> -	pci_common_init_dev(dev, &hw);
> -	return 0;
> +	pci_add_flags(PCI_REASSIGN_ALL_RSRC);
> +	err = pci_init_single(dev, &pci->sys, NULL, &gen_pci_ops);
> +	if (err)
> +		gen_pci_release_of_pci_ranges(pci);
> +
> +	return err;
>   }
>
>   static struct platform_driver gen_pci_driver = {
> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
> index b1315e197ffb..e1381c0699be 100644
> --- a/drivers/pci/host/pci-mvebu.c
> +++ b/drivers/pci/host/pci-mvebu.c
> @@ -99,6 +99,7 @@ struct mvebu_pcie_port;
>   struct mvebu_pcie {
>   	struct platform_device *pdev;
>   	struct mvebu_pcie_port *ports;
> +	struct pci_sys_data sysdata;
>   	struct msi_chip *msi;
>   	struct resource io;
>   	char io_name[30];
> @@ -611,7 +612,7 @@ static int mvebu_sw_pci_bridge_write(struct mvebu_pcie_port *port,
>
>   static inline struct mvebu_pcie *sys_to_pcie(struct pci_sys_data *sys)
>   {
> -	return sys->private_data;
> +	return container_of(sys, struct mvebu_pcie, sysdata);
>   }
>
>   static struct mvebu_pcie_port *mvebu_pcie_find_port(struct mvebu_pcie *pcie,
> @@ -718,11 +719,26 @@ static struct pci_ops mvebu_pcie_ops = {
>   	.write = mvebu_pcie_wr_conf,
>   };
>
> -static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
> +/* FIXME: move the code around to avoid these */
> +static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys);
> +static void mvebu_pcie_add_bus(struct pci_bus *bus);
> +static resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
> +						 const struct resource *res,
> +						 resource_size_t start,
> +						 resource_size_t size,
> +						 resource_size_t align);
> +
> +static int mvebu_pcie_enable(struct mvebu_pcie *pcie)
>   {
> -	struct mvebu_pcie *pcie = sys_to_pcie(sys);
>   	int i;
>   	int domain = 0;
> +	struct pci_sys_data *sys = &pcie->sysdata;
> +
> +	pcie->sysdata = (struct pci_sys_data) {
> +		.map_irq        = of_irq_parse_and_map_pci,
> +		.align_resource = mvebu_pcie_align_resource,
> +		.add_bus        = mvebu_pcie_add_bus,
> +	};
>
>   #ifdef CONFIG_PCI_DOMAINS
>   	domain = sys->domain;
> @@ -738,11 +754,13 @@ static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
>   	if (request_resource(&iomem_resource, &pcie->mem))
>   		return 0;
>
> +	INIT_LIST_HEAD(&sys->resources);
>   	if (resource_size(&pcie->realio) != 0) {
>   		if (request_resource(&ioport_resource, &pcie->realio)) {
>   			release_resource(&pcie->mem);
>   			return 0;
>   		}
> +
>   		pci_add_resource_offset(&sys->resources, &pcie->realio,
>   					sys->io_offset);
>   	}
> @@ -756,7 +774,9 @@ static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
>   		mvebu_pcie_setup_hw(port);
>   	}
>
> -	return 1;
> +	pci_add_flags(PCI_REASSIGN_ALL_RSRC);
> +	return pci_init_single(&pcie->pdev->dev, &pcie->sysdata,
> +			       mvebu_pcie_scan_bus, &mvebu_pcie_ops);
>   }
>
>   static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys)
> @@ -810,24 +830,6 @@ static resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
>   		return start;
>   }
>
> -static void mvebu_pcie_enable(struct mvebu_pcie *pcie)
> -{
> -	struct hw_pci hw;
> -
> -	memset(&hw, 0, sizeof(hw));
> -
> -	hw.nr_controllers = 1;
> -	hw.private_data   = (void **)&pcie;
> -	hw.setup          = mvebu_pcie_setup;
> -	hw.scan           = mvebu_pcie_scan_bus;
> -	hw.map_irq        = of_irq_parse_and_map_pci;
> -	hw.ops            = &mvebu_pcie_ops;
> -	hw.align_resource = mvebu_pcie_align_resource;
> -	hw.add_bus        = mvebu_pcie_add_bus;
> -
> -	pci_common_init(&hw);
> -}
> -
>   /*
>    * Looks up the list of register addresses encoded into the reg =
>    * <...> property for one that matches the given port/lane. Once
> @@ -1066,9 +1068,7 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
>   		pci_ioremap_io(i, pcie->io.start + i);
>
>   	mvebu_pcie_msi_enable(pcie);
> -	mvebu_pcie_enable(pcie);
> -
> -	return 0;
> +	return mvebu_pcie_enable(pcie);
>   }
>
>   static const struct of_device_id mvebu_pcie_of_match_table[] = {
>
