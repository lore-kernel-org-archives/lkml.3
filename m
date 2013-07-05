Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3GEKqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:46:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59913 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab3GEKqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:46:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] pci: exynos: split into two parts such as Synopsys part and Exynos part
Date: Fri, 5 Jul 2013 12:45:51 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Mohit KUMAR <Mohit.KUMAR@st.com>, "'Sean Cross'" <xobs@kosagi.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        linux-kernel@vger.kernel.org
References: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
In-Reply-To: <000201ce7959$bf0fb150$3d2f13f0$@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307051245.52149.arnd@arndb.de>
X-Provags-ID: V02:K0:Ve7NxrjKHH56HNt524e/IiLZ5yh7GKabnjaL4KEMuFs
 mMvNVpG0x14/4NXunnzqzDbFMDXKqy+jEMUY08652Tlrctp5cj
 wa2KPwK5fTLxQDha2SqDYzvCkyB1VhisD7ZfEW5+F3U2CzgLgN
 g9c6h4LvPw5EjDFCrBm8iFQ0Ek4ueYKxsGdYpMuc8TVJCS7q6t
 FA2SXIVmc1ilqJco17s9ce66ej6ajvT9JxwqKG/I1S1XLOLDWB
 /+r2yQdokjgBXB3DNuhwm4ZfQFzgBY5uDPIKlpkrunlZ0+Hi0/
 3YFxXxa4ancsAWdaTctTLLUGCj2c7+8FvpfhPzEoUjFVfUsSLG
 hM8aaSYVFgXKVqk7KYxY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 July 2013, Jingoo Han wrote:

> --- /dev/null
> +++ b/drivers/pci/host/pcie-exynos.c

> +
> +/* PCIe ELBI registers */
> +#define PCIE_IRQ_PULSE			0x000
> +#define IRQ_INTA_ASSERT			(0x1 << 0)
> +#define IRQ_INTB_ASSERT			(0x1 << 2)
> +#define IRQ_INTC_ASSERT			(0x1 << 4)
> +#define IRQ_INTD_ASSERT			(0x1 << 6)
> +#define PCIE_IRQ_LEVEL			0x004
> +#define PCIE_IRQ_SPECIAL		0x008
> +#define PCIE_IRQ_EN_PULSE		0x00c
> +#define PCIE_IRQ_EN_LEVEL		0x010
> +#define PCIE_IRQ_EN_SPECIAL		0x014
> +#define PCIE_PWR_RESET			0x018
> +#define PCIE_CORE_RESET			0x01c
> +#define PCIE_CORE_RESET_ENABLE		(0x1 << 0)
> +#define PCIE_STICKY_RESET		0x020
> +#define PCIE_NONSTICKY_RESET		0x024
> +#define PCIE_APP_INIT_RESET		0x028
> +#define PCIE_APP_LTSSM_ENABLE		0x02c
> +#define PCIE_ELBI_RDLH_LINKUP		0x064
> +#define PCIE_ELBI_LTSSM_ENABLE		0x1
> +#define PCIE_ELBI_SLV_AWMISC		0x11c
> +#define PCIE_ELBI_SLV_ARMISC		0x120
> +#define PCIE_ELBI_SLV_DBI_ENABLE	(0x1 << 21)
> +
> +/* PCIe Purple registers */
> +#define PCIE_PHY_GLOBAL_RESET		0x000
> +#define PCIE_PHY_COMMON_RESET		0x004
> +#define PCIE_PHY_CMN_REG		0x008
> +#define PCIE_PHY_MAC_RESET		0x00c
> +#define PCIE_PHY_PLL_LOCKED		0x010
> +#define PCIE_PHY_TRSVREG_RESET		0x020
> +#define PCIE_PHY_TRSV_RESET		0x024
> +
> +/* PCIe PHY registers */
> +#define PCIE_PHY_IMPEDANCE		0x004
> +#define PCIE_PHY_PLL_DIV_0		0x008
> +#define PCIE_PHY_PLL_BIAS		0x00c
> +#define PCIE_PHY_DCC_FEEDBACK		0x014
> +#define PCIE_PHY_PLL_DIV_1		0x05c
> +#define PCIE_PHY_TRSV0_EMP_LVL		0x084
> +#define PCIE_PHY_TRSV0_DRV_LVL		0x088
> +#define PCIE_PHY_TRSV0_RXCDR		0x0ac
> +#define PCIE_PHY_TRSV0_LVCC		0x0dc
> +#define PCIE_PHY_TRSV1_EMP_LVL		0x144
> +#define PCIE_PHY_TRSV1_RXCDR		0x16c
> +#define PCIE_PHY_TRSV1_LVCC		0x19c
> +#define PCIE_PHY_TRSV2_EMP_LVL		0x204
> +#define PCIE_PHY_TRSV2_RXCDR		0x22c
> +#define PCIE_PHY_TRSV2_LVCC		0x25c
> +#define PCIE_PHY_TRSV3_EMP_LVL		0x2c4
> +#define PCIE_PHY_TRSV3_RXCDR		0x2ec
> +#define PCIE_PHY_TRSV3_LVCC		0x31c

Are you sure these are all exynos specific? Maybe they are licensed
from someone else?

> +
> +	pp->dbi_base = devm_ioremap(&pdev->dev, pp->cfg.start,
> +				resource_size(&pp->cfg));
> +	if (!pp->dbi_base) {
> +		dev_err(&pdev->dev, "error with ioremap\n");
> +		return -ENOMEM;
> +	}
> +
> +	pp->root_bus_nr = -1;
> +	pp->ops = &exynos_pcie_host_ops;
> +
> +	spin_lock_init(&pp->conf_lock);
> +	dw_pcie_host_init(pp);
> +	pp->va_cfg0_base = devm_ioremap(&pdev->dev, pp->cfg0_base,
> +					pp->config.cfg0_size);
> +	if (!pp->va_cfg0_base) {
> +		dev_err(pp->dev, "error with ioremap in function\n");
> +		return -ENOMEM;
> +	}
> +	pp->va_cfg1_base = devm_ioremap(&pdev->dev, pp->cfg1_base,
> +					pp->config.cfg1_size);
> +	if (!pp->va_cfg1_base) {
> +		dev_err(pp->dev, "error with ioremap\n");
> +		return -ENOMEM;
> +	}

I think the configuration space handling should go into the
dw_pcie_host_init function, as that part would be needed by all drivers.

> +static int __init exynos_pcie_probe(struct platform_device *pdev)
> +{
> +	struct pcie_port *pp;
> +	struct device_node *np = pdev->dev.of_node;
> +	struct of_pci_range range;
> +	struct of_pci_range_parser parser;
> +	int ret;
> +
> +	pp = devm_kzalloc(&pdev->dev, sizeof(*pp), GFP_KERNEL);
> +	if (!pp) {
> +		dev_err(&pdev->dev, "no memory for pcie port\n");
> +		return -ENOMEM;
> +	}
> +
> +	pp->dev = &pdev->dev;
> +
> +	if (of_pci_range_parser_init(&parser, np)) {
> +		dev_err(&pdev->dev, "missing ranges property\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Get the I/O and memory ranges from DT */
> +	for_each_of_pci_range(&parser, &range) {
> +		unsigned long restype = range.flags & IORESOURCE_TYPE_BITS;
> +		if (restype == IORESOURCE_IO) {
> +			of_pci_range_to_resource(&range, np, &pp->io);
> +			pp->io.name = "I/O";
> +			pp->io.start = max_t(resource_size_t,
> +					     PCIBIOS_MIN_IO,
> +					     range.pci_addr + global_io_offset);
> +			pp->io.end = min_t(resource_size_t,
> +					   IO_SPACE_LIMIT,
> +					   range.pci_addr + range.size
> +					   + global_io_offset);
> +			pp->config.io_size = resource_size(&pp->io);
> +			pp->config.io_bus_addr = range.pci_addr;
> +		}
> +		if (restype == IORESOURCE_MEM) {
> +			of_pci_range_to_resource(&range, np, &pp->mem);
> +			pp->mem.name = "MEM";
> +			pp->config.mem_size = resource_size(&pp->mem);
> +			pp->config.mem_bus_addr = range.pci_addr;
> +		}
> +		if (restype == 0) {
> +			of_pci_range_to_resource(&range, np, &pp->cfg);
> +			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
> +			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> +		}
> +	}

Same for these: it would be better to split up the probe function here
and move all of the above into the common code.

> +	pp->reset_gpio = of_get_named_gpio(np, "reset-gpio", 0);

I assume the reset logic would need to remain exynos specific

> +	pp->clk = devm_clk_get(&pdev->dev, "pcie");
> +	if (IS_ERR(pp->clk)) {
> +		dev_err(&pdev->dev, "Failed to get pcie rc clock\n");
> +		return PTR_ERR(pp->clk);
> +	}
> +	ret = clk_prepare_enable(pp->clk);
> +	if (ret)
> +		return ret;
> +
> +	pp->bus_clk = devm_clk_get(&pdev->dev, "pcie_bus");
> +	if (IS_ERR(pp->bus_clk)) {
> +		dev_err(&pdev->dev, "Failed to get pcie bus clock\n");
> +		ret = PTR_ERR(pp->bus_clk);
> +		goto fail_clk;
> +	}
> +	ret = clk_prepare_enable(pp->bus_clk);
> +	if (ret)
> +		goto fail_clk;

For the clocks, I think we can keep them in the common code, but
make them optional, i.e. do not fail the probe function if the clocks
don't exist, i.e. you get -ENOENT from devm_clk_get. We should however
still fail here if devm_clk_get returns a different error.

I also noticed an existing bug in your code here: if the clock controller
is not yet initialized, devm_clk_get() will return -EPROBE_DEFER,
which is broken in combination with platform_driver_probe. In order
to fix that, just change the code to use platform_driver_register
so it has the option to retry the probe after the clock controller
is initialized.
That should be a separate patch.

> +static int exynos_pcie_abort(unsigned long addr, unsigned int fsr,
> +			struct pt_regs *regs)
> +{
> +	unsigned long pc = instruction_pointer(regs);
> +	unsigned long instr = *(unsigned long *)pc;
> +
> +	WARN_ONCE(1, "pcie abort\n");
> +
> +	/*
> +	 * If the instruction being executed was a read,
> +	 * make it look like it read all-ones.
> +	 */
> +	if ((instr & 0x0c100000) == 0x04100000) {
> +		int reg = (instr >> 12) & 15;
> +		unsigned long val;
> +
> +		if (instr & 0x00400000)
> +			val = 255;
> +		else
> +			val = -1;
> +
> +		regs->uregs[reg] = val;
> +		regs->ARM_pc += 4;
> +		return 0;
> +	}
> +
> +	if ((instr & 0x0e100090) == 0x00100090) {
> +		int reg = (instr >> 12) & 15;
> +
> +		regs->uregs[reg] = -1;
> +		regs->ARM_pc += 4;
> +		return 0;
> +	}
> +
> +	return 1;
> +}

Another observation that is only partially related: the abort handler logic
is not specific to either exynos nor synopsys. However it is specific
to ARM and should not be part of a driver that is potentially architecture
independent. I would recommend moving this to a separate file
"arm-pci-abort.c" or something like that. I notice that a lot of the other
ARM PCI implementations have the exact same code but also need to reset
the abort in the bridge. Can you confirm that a) you don't need to tell
the root port about the abort and b) the abort handler is actually required
for exynos? How often do you run into this?

	Arnd
