Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbaFRHPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:15:31 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34192 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751576AbaFRHP2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:15:28 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Murali Karicheri <m-karicheri2@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Date: Wed, 18 Jun 2014 15:13:51 +0800
Subject: RE: [PATCH v2 3/8] PCI: designware: update pcie core driver to work
 with dw hw version 3.65
Thread-Topic: [PATCH v2 3/8] PCI: designware: update pcie core driver to
 work with dw hw version 3.65
Thread-Index: Ac+E3Stpgirfs9GkTf2Y1IvvmJOPPAF50Khw
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB6619C5F8168DA@EAPEX1MAIL1.st.com>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
 <1402426287-31157-4-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1402426287-31157-4-git-send-email-m-karicheri2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-18_03:2014-06-17,2014-06-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Murali,

> -----Original Message-----
> From: Murali Karicheri [mailto:m-karicheri2@ti.com]
> Sent: Wednesday, June 11, 2014 12:21 AM
> To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> linux-pci@vger.kernel.org; devicetree@vger.kernel.org; linux-
> doc@vger.kernel.org
> Cc: Murali Karicheri; Santosh Shilimkar; Russell King; Grant Likely; Rob Herring;
> Mohit KUMAR DCG; Jingoo Han; Bjorn Helgaas; Pratyush ANAND; Richard
> Zhu; Kishon Vijay Abraham I; Marek Vasut; Arnd Bergmann; Pawel Moll;
> Mark Rutland; Ian Campbell; Kumar Gala; Randy Dunlap
> Subject: [PATCH v2 3/8] PCI: designware: update pcie core driver to work
> with dw hw version 3.65
> 
> v3.65 version of the dw hw has MSI controller implemented in the application
> space. Add a version variable in the port struct to identify v3.65 hardware for
> different code treatment. This variable will have DW_V3_65 bit set when
> running on this hw version. The host init code is expected to set this version
> based on compatibility string dw,snps-pcie-v3.65.
> 
> Some of the MSI specific functions from current DW driver are re-used on
> v3.65 hw. However on v3.65, MSI controller registers are in the application
> register space and PCIE_MSI_INTR0_ENABLE is not applicable.
> Modify assign_irq() to check for version and not execute the code for
> PCIE_MSI_INTR0_ENABLE configuration on v3.65 hw. Additionally MSI IRQ
> register in application space is written by EP to raise an MSI IRQ. So add a
> get_msi_data() function in pcie_host_ops to retrieve the register address in
> dw_msi_setup_irq(). v3.65 dw core driver implements this function.
> 
> Also make some of the functions available in dw core driver global and make
> their prototypes available in the header file for re-use on v3.65.
> 

- Pls apply MSI specific changes on the top of Lucas patches:
[PATCH 0/4] proper multi MSI handling for designware host

Thanks
Mohit

> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Mohit Kumar <mohit.kumar@st.com>
> CC: Jingoo Han <jg1.han@samsung.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Pratyush Anand <pratyush.anand@st.com>
> CC: Richard Zhu <r65037@freescale.com>
> CC: Kishon Vijay Abraham I <kishon@ti.com>
> CC: Marek Vasut <marex@denx.de>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> CC: Kumar Gala <galak@codeaurora.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Grant Likely <grant.likely@linaro.org>
> 
> ---
>  drivers/pci/host/pcie-designware.c |   27 +++++++++++++++++----------
>  drivers/pci/host/pcie-designware.h |   16 ++++++++++++++++
>  2 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-
> designware.c
> index e4bd19a..f985811 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -277,11 +277,15 @@ static int assign_irq(int no_irqs, struct msi_desc
> *desc, int *pos)
>  		}
>  		set_bit(pos0 + i, pp->msi_irq_in_use);
>  		/*Enable corresponding interrupt in MSI interrupt controller
> */
> -		res = ((pos0 + i) / 32) * 12;
> -		bit = (pos0 + i) % 32;
> -		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
> 4, &val);
> -		val |= 1 << bit;
> -		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
> 4, val);
> +		if (!(pp->version & DW_V3_65)) {
> +			res = ((pos0 + i) / 32) * 12;
> +			bit = (pos0 + i) % 32;
> +			dw_pcie_rd_own_conf(pp,
> PCIE_MSI_INTR0_ENABLE + res,
> +					    4, &val);
> +			val |= 1 << bit;
> +			dw_pcie_wr_own_conf(pp,
> PCIE_MSI_INTR0_ENABLE + res,
> +					    4, val);
> +		}
>  	}
> 
>  	*pos = pos0;
> @@ -349,7 +353,10 @@ static int dw_msi_setup_irq(struct msi_chip *chip,
> struct pci_dev *pdev,
>  	 */
>  	desc->msi_attrib.multiple = msgvec;
> 
> -	msg.address_lo = virt_to_phys((void *)pp->msi_data);
> +	if (pp->ops->get_msi_data)
> +		msg.address_lo = pp->ops->get_msi_data(pp);
> +	else
> +		msg.address_lo = virt_to_phys((void *)pp->msi_data);
>  	msg.address_hi = 0x0;
>  	msg.data = pos;
>  	write_msi_msg(irq, &msg);
> @@ -768,7 +775,7 @@ static struct pci_ops dw_pcie_ops = {
>  	.write = dw_pcie_wr_conf,
>  };
> 
> -static int dw_pcie_setup(int nr, struct pci_sys_data *sys)
> +int dw_pcie_setup(int nr, struct pci_sys_data *sys)
>  {
>  	struct pcie_port *pp;
> 
> @@ -791,7 +798,7 @@ static int dw_pcie_setup(int nr, struct pci_sys_data
> *sys)
>  	return 1;
>  }
> 
> -static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
> +struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
>  {
>  	struct pci_bus *bus;
>  	struct pcie_port *pp = sys_to_pcie(sys); @@ -808,7 +815,7 @@ static
> struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
>  	return bus;
>  }
> 
> -static int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
> +int dw_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
>  {
>  	struct pcie_port *pp = sys_to_pcie(dev->bus->sysdata);
>  	int irq;
> @@ -820,7 +827,7 @@ static int dw_pcie_map_irq(const struct pci_dev
> *dev, u8 slot, u8 pin)
>  	return irq;
>  }
> 
> -static void dw_pcie_add_bus(struct pci_bus *bus)
> +void dw_pcie_add_bus(struct pci_bus *bus)
>  {
>  	if (IS_ENABLED(CONFIG_PCI_MSI)) {
>  		struct pcie_port *pp = sys_to_pcie(bus->sysdata); diff --git
> a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> index 2d6dd66..3a6a6eb 100644
> --- a/drivers/pci/host/pcie-designware.h
> +++ b/drivers/pci/host/pcie-designware.h
> @@ -39,6 +39,12 @@ struct pcie_port {
>  	void __iomem		*va_cfg0_base;
>  	u64			cfg1_base;
>  	void __iomem		*va_cfg1_base;
> +	/*
> +	 * v3.65 DW hw implements application register space for
> +	 * MSI and has no ATU view port
> +	 */
> +#define DW_V3_65		BIT(0)
> +	u32			version;
>  	u64			io_base;
>  	u64			mem_base;
>  	spinlock_t		conf_lock;
> @@ -68,6 +74,7 @@ struct pcie_host_ops {
>  			unsigned int devfn, int where, int size, u32 val);
>  	int (*link_up)(struct pcie_port *pp);
>  	void (*host_init)(struct pcie_port *pp);
> +	u32 (*get_msi_data)(struct pcie_port *pp);
>  };
> 
>  int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
> @@ -77,5 +84,14 @@ void dw_pcie_msi_init(struct pcie_port *pp);  int
> dw_pcie_link_up(struct pcie_port *pp);  void dw_pcie_setup_rc(struct
> pcie_port *pp);  int dw_pcie_host_init(struct pcie_port *pp);
> +int dw_pcie_setup(int nr, struct pci_sys_data *sys); struct pci_bus
> +*dw_pcie_scan_bus(int nr, struct pci_sys_data *sys); void
> +dw_pcie_add_bus(struct pci_bus *bus); int
> dw_pcie_parse_resource(struct
> +pcie_port *pp);
> 
> +/* internal to DW common core driver */ int
> +dw_pcie_common_host_init(struct pcie_port *pp, struct hw_pci *hw); int
> +dw_pcie_msi_host_init(struct pcie_port *pp, struct device_node *np,
> +			const struct irq_domain_ops *irq_ops); int
> dw_pcie_map_irq(const
> +struct pci_dev *dev, u8 slot, u8 pin);
>  #endif /* _PCIE_DESIGNWARE_H */
> --
> 1.7.9.5

