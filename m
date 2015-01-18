Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbbARGdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 01:33:09 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59411 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbbARGdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 01:33:04 -0500
Date: Sun, 18 Jan 2015 01:31:36 -0500 (EST)
Subject: Re: [PATCH v7 06/17] ARM64 / ACPI: Make PCI optional for ACPI on
 ARM64
From: Jon Masters <jcm@redhat.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Olof Johansson <olof@lixom.net>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Rob Herring <robh@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Timur Tabi <timur@codeaurora.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>
MIME-Version: 1.0
Message-ID: <508480149.12941388.1421562696311.JavaMail.zimbra@zmail15.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Zimbra 8.0.6_GA_5922 (MobileSync - Android/4.4.4-EAS-2.0)
In-Reply-To: <54BB51F1.8000900@linaro.org>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-7-git-send-email-hanjun.guo@linaro.org> <20150116094913.GA13634@e104818-lin.cambridge.arm.com> <54BB51F1.8000900@linaro.org>
Thread-Topic: ARM64 / ACPI: Make PCI optional for ACPI on ARM64
Thread-Index: gU5T05CPp1wqEIV6YfmA//Ni1eG/vA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

Sorry for top posting from bed. The mainstream servers will all likely do PCIe but there are several that may not. They should not be excluded. That said, if we booted a previously built kernel on a system without an MCFG and got no ECAM/root then things would probably still work.

I think it'll work out either way but for the record there is no requirement to do PCIe on ARM servers that conform to spec.

Jon.

-- 
Computer Architect | Sent from my #ARM Powered Mobile Device

On Jan 18, 2015 1:26 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>
> On 2015年01月16日 17:49, Catalin Marinas wrote: 
> > On Wed, Jan 14, 2015 at 03:04:54PM +0000, Hanjun Guo wrote: 
> >> Since PCI iOn 2015年01月16日 17:49, Catalin Marinas wrote:
> On Wed, Jan 14, 2015 at 03:04:54PM +0000, Hanjun Guo wrote:
>> Since PCI is not required in ACPI spec and ARM can run without
>> it, introduce some stub functions to make PCI optional for ACPI,
>> and make ACPI core run without CONFIG_PCI on ARM64.
>>
>> When PCI is enabled on ARM64, ACPI core will need some PCI functions
>> to make it functional, so introduce some empty functions here and
>> implement it later.
>>
>> Since ACPI on X86 and IA64 depends on PCI and this patch only makes
>> PCI optional for ARM64, it will not break anything on X86 and IA64.
>>
>> Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> Tested-by: Yijing Wang <wangyijing@huawei.com>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>
> Is this patch still required, now that we have PCI for arm64? I know the
> ACPI spec doesn't require PCI but do we expect any arm64 servers aimed
> at ACPI without PCIe?

I think so, how about make ACPI depends on PCI on ARM64 too?

>
> Anyway, that's not the main point, see more below.
>
>> diff --git a/arch/arm64/include/asm/pci.h b/arch/arm64/include/asm/pci.h
>> index 872ba93..fded096 100644
>> --- a/arch/arm64/include/asm/pci.h
>> +++ b/arch/arm64/include/asm/pci.h
>> @@ -24,6 +24,12 @@
>>    */
>>   #define PCI_DMA_BUS_IS_PHYS	(0)
>>
>> +static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
>> +{
>> +	/* no legacy IRQ on arm64 */
>> +	return -ENODEV;
>> +}
>> +
>>   extern int isa_dma_bridge_buggy;
>>
>>   #ifdef CONFIG_PCI
>> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
>> index ce5836c..42fb195 100644
>> --- a/arch/arm64/kernel/pci.c
>> +++ b/arch/arm64/kernel/pci.c
>> @@ -10,6 +10,7 @@
>>    *
>>    */
>>
>> +#include <linux/acpi.h>
>>   #include <linux/init.h>
>>   #include <linux/io.h>
>>   #include <linux/kernel.h>
>> @@ -68,3 +69,30 @@ void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
>>   	bus->domain_nr = domain;
>>   }
>>   #endif
>> +
>> +/*
>> + * raw_pci_read/write - Platform-specific PCI config space access.
>> + *
>> + * Default empty implementation.  Replace with an architecture-specific setup
>> + * routine, if necessary.
>> + */
>> +int raw_pci_read(unsigned int domain, unsigned int bus,
>> +		  unsigned int devfn, int reg, int len, u32 *val)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +int raw_pci_write(unsigned int domain, unsigned int bus,
>> +		unsigned int devfn, int reg, int len, u32 val)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +#ifdef CONFIG_ACPI
>> +/* Root bridge scanning */
>> +struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>> +{
>> +	/* TODO: Should be revisited when implementing PCI on ACPI */
>> +	return NULL;
>> +}
>> +#endif
>
> Do these functions have anything to do with the subject? You add them in
> arch/arm64/kernel/pci.c which is compiled only when CONFIG_PCI while the
> commit log implies that you add them to allow CONFIG_PCI to be off.

My bad, I can update the change log to make it explicit it is needed
when PCI is enabled.

>
> When PCI is enabled and the above functions are compiled in, do they
> need to return any useful data or just -EINVAL. Are they ever called?

They will be called if PCI root bridge is defined in DSDT, should I
print some warning message before it is implemented?

>
>> diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
>> index 39f3ec1..c346011 100644
>> --- a/drivers/acpi/Makefile
>> +++ b/drivers/acpi/Makefile
>> @@ -43,7 +43,7 @@ acpi-y				+= processor_core.o
>>   acpi-$(CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC) += processor_pdc.o
>>   acpi-y				+= ec.o
>>   acpi-$(CONFIG_ACPI_DOCK)	+= dock.o
>> -acpi-y				+= pci_root.o pci_link.o pci_irq.o
>> +acpi-$(CONFIG_PCI)		+= pci_root.o pci_link.o pci_irq.o
>>   acpi-y				+= acpi_lpss.o
>>   acpi-y				+= acpi_platform.o
>>   acpi-y				+= acpi_pnp.o
>> diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
>> index 163e82f..c5ff8ba 100644
>> --- a/drivers/acpi/internal.h
>> +++ b/drivers/acpi/internal.h
>> @@ -26,8 +26,13 @@
>>   acpi_status acpi_os_initialize1(void);
>>   int init_acpi_device_notify(void);
>>   int acpi_scan_init(void);
>> +#ifdef CONFIG_PCI
>>   void acpi_pci_root_init(void);
>>   void acpi_pci_link_init(void);
>> +#else
>> +static inline void acpi_pci_root_init(void) {}
>> +static inline void acpi_pci_link_init(void) {}
>> +#endif
>>   void acpi_processor_init(void);
>>   void acpi_platform_init(void);
>>   void acpi_pnp_init(void);
>
> That's a good clean-up.

If we make ACPI depends on PCI on ARM64, these two stub functions
are not needed anymore.

>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 360a966..1476a66 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -564,15 +564,6 @@ struct pci_ops {
>>   	int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
>>   };
>>
>> -/*
>> - * ACPI needs to be able to access PCI config space before we've done a
>> - * PCI bus scan and created pci_bus structures.
>> - */
>> -int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
>> -		 int reg, int len, u32 *val);
>> -int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
>> -		  int reg, int len, u32 val);
>> -
>>   struct pci_bus_region {
>>   	dma_addr_t start;
>>   	dma_addr_t end;
>> @@ -1329,6 +1320,16 @@ typedef int (*arch_set_vga_state_t)(struct pci_dev *pdev, bool decode,
>>   		      unsigned int command_bits, u32 flags);
>>   void pci_register_set_vga_state(arch_set_vga_state_t func);
>>
>> +/*
>> + * ACPI needs to be able to access PCI config space before we've done a
>> + * PCI bus scan and created pci_bus structures.
>> + */
>> +int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
>> +		 int reg, int len, u32 *val);
>> +int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
>> +		  int reg, int len, u32 val);
>> +void pcibios_penalize_isa_irq(int irq, int active);
>> +
>>   #else /* CONFIG_PCI is not enabled */
>>
>>   /*
>> @@ -1430,6 +1431,23 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
>>   						unsigned int devfn)
>>   { return NULL; }
>>
>> +static inline struct pci_bus *pci_find_bus(int domain, int busnr)
>> +{ return NULL; }
>> +
>> +static inline int pci_bus_write_config_byte(struct pci_bus *bus,
>> +				unsigned int devfn, int where, u8 val)
>> +{ return -ENOSYS; }
>> +
>> +static inline int raw_pci_read(unsigned int domain, unsigned int bus,
>> +			unsigned int devfn, int reg, int len, u32 *val)
>> +{ return -ENOSYS; }
>> +
>> +static inline int raw_pci_write(unsigned int domain, unsigned int bus,
>> +			unsigned int devfn, int reg, int len, u32 val)
>> +{ return -ENOSYS; }
>
> So you implement the !CONFIG_PCI functions here to return -ENOSYS while
> the arm64 CONFIG_PCI ones would return -EINVAL. I'm confused.

return -ENOSYS in the arm64 CONFIG_PCI ones next version :)

Thanks
Hanjun
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
