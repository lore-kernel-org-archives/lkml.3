Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaG0LPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 07:15:52 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:37990
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751619AbaG0LPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 07:15:49 -0400
X-WSS-ID: 0N9DBA2-08-UZJ-02
X-M-MSG: 
Message-ID: <53D4DF4A.9030005@amd.com>
Date: Sun, 27 Jul 2014 14:15:22 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?windows-1252?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        =?windows-1252?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2 10/25] amdkfd: Add topology module to amdkfd
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-11-git-send-email-oded.gabbay@amd.com>
 <20140720223737.GF3068@gmail.com>
In-Reply-To: <20140720223737.GF3068@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(199002)(189002)(479174003)(87936001)(31966008)(23746002)(102836001)(76482001)(74502001)(99396002)(44976005)(107046002)(105586002)(95666004)(4396001)(64126003)(84676001)(64706001)(81542001)(101416001)(86362001)(79102001)(54356999)(65816999)(110136001)(21056001)(85852003)(83322001)(87266999)(92566001)(74662001)(50986999)(76176999)(80316001)(77982001)(19580395003)(36756003)(65806001)(80022001)(65956001)(85306003)(83506001)(33656002)(47776003)(68736004)(81342001)(97736001)(92726001)(50466002)(20776003)(106466001)(83072002)(46102001)(19580405001)(129583001)(579004)(559001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0285201563
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/14 01:37, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:29:17PM +0300, Oded Gabbay wrote:
>> From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
>>
>> This patch adds the topology module to the driver. The topology is exposed to
>> userspace through the sysfs.
>>
>> The calls to add and remove a device to/from topology are done by the radeon
>> driver.
>
> So overall we already said that we do not want to see the cpu architecture
> re-expose by hsa in its own format. This pacth is NACK. Only expose additional
> non existent information and also follow the number one rules of sysfs which
> is one value -> one file.
>
> I understand the temptation to rexpose the cpu topology in your own way to
> make life simpler but there is already api for this so please use what exist
> today and if there is short coming than i am sure they can be fixed.
>
> See :
>
> /sys/devices/system/cpu/cpu*
>
Agreed and we will change the code. Hopefully it will be in v3, although we may 
release v3 early this week and release v4 with this change next week.

	Oded
>>
>> Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>   drivers/gpu/drm/radeon/amdkfd/Makefile       |    2 +-
>>   drivers/gpu/drm/radeon/amdkfd/kfd_crat.h     |  294 +++++++
>>   drivers/gpu/drm/radeon/amdkfd/kfd_device.c   |    7 +
>>   drivers/gpu/drm/radeon/amdkfd/kfd_module.c   |    7 +
>>   drivers/gpu/drm/radeon/amdkfd/kfd_priv.h     |   17 +
>>   drivers/gpu/drm/radeon/amdkfd/kfd_topology.c | 1207 ++++++++++++++++++++++++++
>>   drivers/gpu/drm/radeon/amdkfd/kfd_topology.h |  168 ++++
>>   7 files changed, 1701 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_crat.h
>>   create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.c
>>   create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_topology.h
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
>> index 9564e75..08ecfcd 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/Makefile
>> +++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
>> @@ -4,6 +4,6 @@
>>
>>   ccflags-y := -Iinclude/drm
>>
>> -amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o
>> +amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o
>>
>>   obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_crat.h b/drivers/gpu/drm/radeon/amdkfd/kfd_crat.h
>> new file mode 100644
>> index 0000000..a374fa3
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_crat.h
>> @@ -0,0 +1,294 @@
>> +/*
>> + * Copyright 2014 Advanced Micro Devices, Inc.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> + * copy of this software and associated documentation files (the "Software"),
>> + * to deal in the Software without restriction, including without limitation
>> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
>> + * and/or sell copies of the Software, and to permit persons to whom the
>> + * Software is furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#ifndef KFD_CRAT_H_INCLUDED
>> +#define KFD_CRAT_H_INCLUDED
>> +
>> +#include <linux/types.h>
>> +
>> +#pragma pack(1)
>
> No pragma
>
>> +
>> +/*
>> + * 4CC signature values for the CRAT and CDIT ACPI tables
>> + */
>> +
>> +#define CRAT_SIGNATURE	"CRAT"
>> +#define CDIT_SIGNATURE	"CDIT"
>> +
>> +/*
>> + * Component Resource Association Table (CRAT)
>> + */
>> +
>> +#define CRAT_OEMID_LENGTH	6
>> +#define CRAT_OEMTABLEID_LENGTH	8
>> +#define CRAT_RESERVED_LENGTH	6
>> +
>> +#define CRAT_OEMID_64BIT_MASK ((1ULL << (CRAT_OEMID_LENGTH * 8)) - 1)
>> +
>> +struct crat_header {
>> +	uint32_t	signature;
>> +	uint32_t	length;
>> +	uint8_t		revision;
>> +	uint8_t		checksum;
>> +	uint8_t		oem_id[CRAT_OEMID_LENGTH];
>> +	uint8_t		oem_table_id[CRAT_OEMTABLEID_LENGTH];
>> +	uint32_t	oem_revision;
>> +	uint32_t	creator_id;
>> +	uint32_t	creator_revision;
>> +	uint32_t	total_entries;
>> +	uint16_t	num_domains;
>> +	uint8_t		reserved[CRAT_RESERVED_LENGTH];
>> +};
>> +
>> +/*
>> + * The header structure is immediately followed by total_entries of the
>> + * data definitions
>> + */
>> +
>> +/*
>> + * The currently defined subtype entries in the CRAT
>> + */
>> +#define CRAT_SUBTYPE_COMPUTEUNIT_AFFINITY	0
>> +#define CRAT_SUBTYPE_MEMORY_AFFINITY		1
>> +#define CRAT_SUBTYPE_CACHE_AFFINITY		2
>> +#define CRAT_SUBTYPE_TLB_AFFINITY		3
>> +#define CRAT_SUBTYPE_CCOMPUTE_AFFINITY		4
>> +#define CRAT_SUBTYPE_IOLINK_AFFINITY		5
>> +#define CRAT_SUBTYPE_MAX			6
>> +
>> +#define CRAT_SIBLINGMAP_SIZE	32
>> +
>> +/*
>> + * ComputeUnit Affinity structure and definitions
>> + */
>> +#define CRAT_CU_FLAGS_ENABLED		0x00000001
>> +#define CRAT_CU_FLAGS_HOT_PLUGGABLE	0x00000002
>> +#define CRAT_CU_FLAGS_CPU_PRESENT	0x00000004
>> +#define CRAT_CU_FLAGS_GPU_PRESENT	0x00000008
>> +#define CRAT_CU_FLAGS_IOMMU_PRESENT	0x00000010
>> +#define CRAT_CU_FLAGS_RESERVED		0xffffffe0
>> +
>> +#define CRAT_COMPUTEUNIT_RESERVED_LENGTH 4
>> +
>> +struct crat_subtype_computeunit {
>> +	uint8_t		type;
>> +	uint8_t		length;
>> +	uint16_t	reserved;
>> +	uint32_t	flags;
>> +	uint32_t	proximity_domain;
>> +	uint32_t	processor_id_low;
>> +	uint16_t	num_cpu_cores;
>> +	uint16_t	num_simd_cores;
>> +	uint16_t	max_waves_simd;
>> +	uint16_t	io_count;
>> +	uint16_t	hsa_capability;
>> +	uint16_t	lds_size_in_kb;
>> +	uint8_t		wave_front_size;
>> +	uint8_t		num_banks;
>> +	uint16_t	micro_engine_id;
>> +	uint8_t		num_arrays;
>> +	uint8_t		num_cu_per_array;
>> +	uint8_t		num_simd_per_cu;
>> +	uint8_t		max_slots_scatch_cu;
>> +	uint8_t		reserved2[CRAT_COMPUTEUNIT_RESERVED_LENGTH];
>> +};
>> +
>> +/*
>> + * HSA Memory Affinity structure and definitions
>> + */
>> +#define CRAT_MEM_FLAGS_ENABLED		0x00000001
>> +#define CRAT_MEM_FLAGS_HOT_PLUGGABLE	0x00000002
>> +#define CRAT_MEM_FLAGS_NON_VOLATILE	0x00000004
>> +#define CRAT_MEM_FLAGS_RESERVED		0xfffffff8
>> +
>> +#define CRAT_MEMORY_RESERVED_LENGTH 8
>> +
>> +struct crat_subtype_memory {
>> +	uint8_t		type;
>> +	uint8_t		length;
>> +	uint16_t	reserved;
>> +	uint32_t	flags;
>> +	uint32_t	promixity_domain;
>> +	uint32_t	base_addr_low;
>> +	uint32_t	base_addr_high;
>> +	uint32_t	length_low;
>> +	uint32_t	length_high;
>> +	uint32_t	width;
>> +	uint8_t		reserved2[CRAT_MEMORY_RESERVED_LENGTH];
>> +};
>> +
>> +/*
>> + * HSA Cache Affinity structure and definitions
>> + */
>> +#define CRAT_CACHE_FLAGS_ENABLED	0x00000001
>> +#define CRAT_CACHE_FLAGS_DATA_CACHE	0x00000002
>> +#define CRAT_CACHE_FLAGS_INST_CACHE	0x00000004
>> +#define CRAT_CACHE_FLAGS_CPU_CACHE	0x00000008
>> +#define CRAT_CACHE_FLAGS_SIMD_CACHE	0x00000010
>> +#define CRAT_CACHE_FLAGS_RESERVED	0xffffffe0
>> +
>> +#define CRAT_CACHE_RESERVED_LENGTH 8
>> +
>> +struct crat_subtype_cache {
>> +	uint8_t		type;
>> +	uint8_t		length;
>> +	uint16_t	reserved;
>> +	uint32_t	flags;
>> +	uint32_t	processor_id_low;
>> +	uint8_t		sibling_map[CRAT_SIBLINGMAP_SIZE];
>> +	uint32_t	cache_size;
>> +	uint8_t		cache_level;
>> +	uint8_t		lines_per_tag;
>> +	uint16_t	cache_line_size;
>> +	uint8_t		associativity;
>> +	uint8_t		cache_properties;
>> +	uint16_t	cache_latency;
>> +	uint8_t		reserved2[CRAT_CACHE_RESERVED_LENGTH];
>> +};
>> +
>> +/*
>> + * HSA TLB Affinity structure and definitions
>> + */
>> +#define CRAT_TLB_FLAGS_ENABLED	0x00000001
>> +#define CRAT_TLB_FLAGS_DATA_TLB	0x00000002
>> +#define CRAT_TLB_FLAGS_INST_TLB	0x00000004
>> +#define CRAT_TLB_FLAGS_CPU_TLB	0x00000008
>> +#define CRAT_TLB_FLAGS_SIMD_TLB	0x00000010
>> +#define CRAT_TLB_FLAGS_RESERVED	0xffffffe0
>> +
>> +#define CRAT_TLB_RESERVED_LENGTH 4
>> +
>> +struct crat_subtype_tlb {
>> +	uint8_t		type;
>> +	uint8_t		length;
>> +	uint16_t	reserved;
>> +	uint32_t	flags;
>> +	uint32_t	processor_id_low;
>> +	uint8_t		sibling_map[CRAT_SIBLINGMAP_SIZE];
>> +	uint32_t	tlb_level;
>> +	uint8_t		data_tlb_associativity_2mb;
>> +	uint8_t		data_tlb_size_2mb;
>> +	uint8_t		instruction_tlb_associativity_2mb;
>> +	uint8_t		instruction_tlb_size_2mb;
>> +	uint8_t		data_tlb_associativity_4k;
>> +	uint8_t		data_tlb_size_4k;
>> +	uint8_t		instruction_tlb_associativity_4k;
>> +	uint8_t		instruction_tlb_size_4k;
>> +	uint8_t		data_tlb_associativity_1gb;
>> +	uint8_t		data_tlb_size_1gb;
>> +	uint8_t		instruction_tlb_associativity_1gb;
>> +	uint8_t		instruction_tlb_size_1gb;
>> +	uint8_t		reserved2[CRAT_TLB_RESERVED_LENGTH];
>> +};
>> +
>> +/*
>> + * HSA CCompute/APU Affinity structure and definitions
>> + */
>> +#define CRAT_CCOMPUTE_FLAGS_ENABLED	0x00000001
>> +#define CRAT_CCOMPUTE_FLAGS_RESERVED	0xfffffffe
>> +
>> +#define CRAT_CCOMPUTE_RESERVED_LENGTH 16
>> +
>> +struct crat_subtype_ccompute {
>> +	uint8_t		type;
>> +	uint8_t		length;
>> +	uint16_t	reserved;
>> +	uint32_t	flags;
>> +	uint32_t	processor_id_low;
>> +	uint8_t		sibling_map[CRAT_SIBLINGMAP_SIZE];
>> +	uint32_t	apu_size;
>> +	uint8_t		reserved2[CRAT_CCOMPUTE_RESERVED_LENGTH];
>> +};
>> +
>> +/*
>> + * HSA IO Link Affinity structure and definitions
>> + */
>> +#define CRAT_IOLINK_FLAGS_ENABLED	0x00000001
>> +#define CRAT_IOLINK_FLAGS_COHERENCY	0x00000002
>> +#define CRAT_IOLINK_FLAGS_RESERVED	0xfffffffc
>> +
>> +/*
>> + * IO interface types
>> + */
>> +#define CRAT_IOLINK_TYPE_UNDEFINED	0
>> +#define CRAT_IOLINK_TYPE_HYPERTRANSPORT	1
>> +#define CRAT_IOLINK_TYPE_PCIEXPRESS	2
>> +#define CRAT_IOLINK_TYPE_OTHER		3
>> +#define CRAT_IOLINK_TYPE_MAX		255
>> +
>> +#define CRAT_IOLINK_RESERVED_LENGTH 24
>> +
>> +struct crat_subtype_iolink {
>> +	uint8_t		type;
>> +	uint8_t		length;
>> +	uint16_t	reserved;
>> +	uint32_t	flags;
>> +	uint32_t	proximity_domain_from;
>> +	uint32_t	proximity_domain_to;
>> +	uint8_t		io_interface_type;
>> +	uint8_t		version_major;
>> +	uint16_t	version_minor;
>> +	uint32_t	minimum_latency;
>> +	uint32_t	maximum_latency;
>> +	uint32_t	minimum_bandwidth_mbs;
>> +	uint32_t	maximum_bandwidth_mbs;
>> +	uint32_t	recommended_transfer_size;
>> +	uint8_t		reserved2[CRAT_IOLINK_RESERVED_LENGTH];
>> +};
>> +
>> +/*
>> + * HSA generic sub-type header
>> + */
>> +
>> +#define CRAT_SUBTYPE_FLAGS_ENABLED 0x00000001
>> +
>> +struct crat_subtype_generic {
>> +	uint8_t		type;
>> +	uint8_t		length;
>> +	uint16_t	reserved;
>> +	uint32_t	flags;
>> +};
>> +
>> +/*
>> + * Component Locality Distance Information Table (CDIT)
>> + */
>> +#define CDIT_OEMID_LENGTH	6
>> +#define CDIT_OEMTABLEID_LENGTH	8
>> +
>> +struct cdit_header {
>> +	uint32_t	signature;
>> +	uint32_t	length;
>> +	uint8_t		revision;
>> +	uint8_t		checksum;
>> +	uint8_t		oem_id[CDIT_OEMID_LENGTH];
>> +	uint8_t		oem_table_id[CDIT_OEMTABLEID_LENGTH];
>> +	uint32_t	oem_revision;
>> +	uint32_t	creator_id;
>> +	uint32_t	creator_revision;
>> +	uint32_t	total_entries;
>> +	uint16_t	num_domains;
>> +	uint8_t		entry[1];
>> +};
>> +
>> +#pragma pack()
>> +
>> +#endif /* KFD_CRAT_H_INCLUDED */
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>> index dd63ce09..4138694 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>> @@ -100,6 +100,9 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>>   {
>>   	kfd->shared_resources = *gpu_resources;
>>
>> +	if (kfd_topology_add_device(kfd) != 0)
>> +		return false;
>> +
>>   	kfd->init_complete = true;
>>   	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
>>   		 kfd->pdev->device);
>> @@ -109,6 +112,10 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>>
>>   void kgd2kfd_device_exit(struct kfd_dev *kfd)
>>   {
>> +	int err = kfd_topology_remove_device(kfd);
>> +
>> +	BUG_ON(err != 0);
>> +
>>   	kfree(kfd);
>>   }
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>> index c7faac6..c51f981 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>> @@ -73,16 +73,23 @@ static int __init kfd_module_init(void)
>>   	if (err < 0)
>>   		goto err_ioctl;
>>
>> +	err = kfd_topology_init();
>> +	if (err < 0)
>> +		goto err_topology;
>> +
>>   	dev_info(kfd_device, "Initialized module\n");
>>
>>   	return 0;
>>
>> +err_topology:
>> +	kfd_chardev_exit();
>>   err_ioctl:
>>   	return err;
>>   }
>>
>>   static void __exit kfd_module_exit(void)
>>   {
>> +	kfd_topology_shutdown();
>>   	kfd_chardev_exit();
>>   	dev_info(kfd_device, "Removed module\n");
>>   }
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> index 05e892f..b391e24 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> @@ -32,6 +32,14 @@
>>   #include <linux/spinlock.h>
>>   #include "../radeon_kfd.h"
>>
>> +#define KFD_SYSFS_FILE_MODE 0444
>> +
>> +/* GPU ID hash width in bits */
>> +#define KFD_GPU_ID_HASH_WIDTH 16
>> +
>> +/* Macro for allocating structures */
>> +#define kfd_alloc_struct(ptr_to_struct)	((typeof(ptr_to_struct)) kzalloc(sizeof(*ptr_to_struct), GFP_KERNEL))
>> +
>>   struct kfd_device_info {
>>   	const struct kfd_scheduler_class *scheduler_class;
>>   	unsigned int max_pasid_bits;
>> @@ -71,6 +79,15 @@ struct kfd_process {
>>
>>   extern struct device *kfd_device;
>>
>> +/* Topology */
>> +int kfd_topology_init(void);
>> +void kfd_topology_shutdown(void);
>> +int kfd_topology_add_device(struct kfd_dev *gpu);
>> +int kfd_topology_remove_device(struct kfd_dev *gpu);
>> +struct kfd_dev *kfd_device_by_id(uint32_t gpu_id);
>> +struct kfd_dev *kfd_device_by_pci_dev(const struct pci_dev *pdev);
>> +struct kfd_dev *kfd_topology_enum_kfd_devices(uint8_t idx);
>> +
>>   /* Interrupts */
>>   void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry);
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_topology.c b/drivers/gpu/drm/radeon/amdkfd/kfd_topology.c
>> new file mode 100644
>> index 0000000..30da4c3
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_topology.c
>> @@ -0,0 +1,1207 @@
>> +/*
>> + * Copyright 2014 Advanced Micro Devices, Inc.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> + * copy of this software and associated documentation files (the "Software"),
>> + * to deal in the Software without restriction, including without limitation
>> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
>> + * and/or sell copies of the Software, and to permit persons to whom the
>> + * Software is furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/kernel.h>
>> +#include <linux/pci.h>
>> +#include <linux/errno.h>
>> +#include <linux/acpi.h>
>> +#include <linux/hash.h>
>> +#include <linux/cpufreq.h>
>> +
>> +#include "kfd_priv.h"
>> +#include "kfd_crat.h"
>> +#include "kfd_topology.h"
>> +
>> +static struct list_head topology_device_list;
>> +static int topology_crat_parsed;
>> +static struct kfd_system_properties sys_props;
>> +
>> +static DECLARE_RWSEM(topology_lock);
>> +
>> +struct kfd_dev *kfd_device_by_id(uint32_t gpu_id)
>> +{
>> +	struct kfd_topology_device *top_dev;
>> +	struct kfd_dev *device = NULL;
>> +
>> +	down_read(&topology_lock);
>> +
>> +	list_for_each_entry(top_dev, &topology_device_list, list)
>> +		if (top_dev->gpu_id == gpu_id) {
>> +			device = top_dev->gpu;
>> +			break;
>> +		}
>> +
>> +	up_read(&topology_lock);
>> +
>> +	return device;
>> +}
>> +
>> +struct kfd_dev *kfd_device_by_pci_dev(const struct pci_dev *pdev)
>> +{
>> +	struct kfd_topology_device *top_dev;
>> +	struct kfd_dev *device = NULL;
>> +
>> +	down_read(&topology_lock);
>> +
>> +	list_for_each_entry(top_dev, &topology_device_list, list)
>> +		if (top_dev->gpu->pdev == pdev) {
>> +			device = top_dev->gpu;
>> +			break;
>> +		}
>> +
>> +	up_read(&topology_lock);
>> +
>> +	return device;
>> +}
>> +
>> +static int kfd_topology_get_crat_acpi(void *crat_image, size_t *size)
>> +{
>> +	struct acpi_table_header *crat_table;
>> +	acpi_status status;
>> +
>> +	if (!size)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * Fetch the CRAT table from ACPI
>> +	 */
>> +	status = acpi_get_table(CRAT_SIGNATURE, 0, &crat_table);
>> +	if (status == AE_NOT_FOUND) {
>> +		pr_warn("CRAT table not found\n");
>> +		return -ENODATA;
>> +	} else if (ACPI_FAILURE(status)) {
>> +		const char *err = acpi_format_exception(status);
>> +
>> +		pr_err("CRAT table error: %s\n", err);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (*size >= crat_table->length && crat_image != 0)
>> +		memcpy(crat_image, crat_table, crat_table->length);
>> +
>> +	*size = crat_table->length;
>> +
>> +	return 0;
>> +}
>> +
>> +static void kfd_populated_cu_info_cpu(struct kfd_topology_device *dev,
>> +		struct crat_subtype_computeunit *cu)
>> +{
>> +	BUG_ON(!dev);
>> +	BUG_ON(!cu);
>> +
>> +	dev->node_props.cpu_cores_count = cu->num_cpu_cores;
>> +	dev->node_props.cpu_core_id_base = cu->processor_id_low;
>> +	if (cu->hsa_capability & CRAT_CU_FLAGS_IOMMU_PRESENT)
>> +		dev->node_props.capability |= HSA_CAP_ATS_PRESENT;
>> +
>> +	pr_info("CU CPU: cores=%d id_base=%d\n", cu->num_cpu_cores,
>> +			cu->processor_id_low);
>> +}
>> +
>> +static void kfd_populated_cu_info_gpu(struct kfd_topology_device *dev,
>> +		struct crat_subtype_computeunit *cu)
>> +{
>> +	BUG_ON(!dev);
>> +	BUG_ON(!cu);
>> +
>> +	dev->node_props.simd_id_base = cu->processor_id_low;
>> +	dev->node_props.simd_count = cu->num_simd_cores;
>> +	dev->node_props.lds_size_in_kb = cu->lds_size_in_kb;
>> +	dev->node_props.max_waves_per_simd = cu->max_waves_simd;
>> +	dev->node_props.wave_front_size = cu->wave_front_size;
>> +	dev->node_props.mem_banks_count = cu->num_banks;
>> +	dev->node_props.array_count = cu->num_arrays;
>> +	dev->node_props.cu_per_simd_array = cu->num_cu_per_array;
>> +	dev->node_props.simd_per_cu = cu->num_simd_per_cu;
>> +	dev->node_props.max_slots_scratch_cu = cu->max_slots_scatch_cu;
>> +	if (cu->hsa_capability & CRAT_CU_FLAGS_HOT_PLUGGABLE)
>> +		dev->node_props.capability |= HSA_CAP_HOT_PLUGGABLE;
>> +	pr_info("CU GPU: simds=%d id_base=%d\n", cu->num_simd_cores,
>> +				cu->processor_id_low);
>> +}
>> +
>> +/* kfd_parse_subtype_cu is called when the topology mutex is already acquired */
>> +static int kfd_parse_subtype_cu(struct crat_subtype_computeunit *cu)
>> +{
>> +	struct kfd_topology_device *dev;
>> +	int i = 0;
>> +
>> +	BUG_ON(!cu);
>> +
>> +	pr_info("Found CU entry in CRAT table with proximity_domain=%d caps=%x\n",
>> +			cu->proximity_domain, cu->hsa_capability);
>> +	list_for_each_entry(dev, &topology_device_list, list) {
>> +		if (cu->proximity_domain == i) {
>> +			if (cu->flags & CRAT_CU_FLAGS_CPU_PRESENT)
>> +				kfd_populated_cu_info_cpu(dev, cu);
>> +
>> +			if (cu->flags & CRAT_CU_FLAGS_GPU_PRESENT)
>> +				kfd_populated_cu_info_gpu(dev, cu);
>> +			break;
>> +		}
>> +		i++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* kfd_parse_subtype_mem is called when the topology mutex is already acquired */
>> +static int kfd_parse_subtype_mem(struct crat_subtype_memory *mem)
>> +{
>> +	struct kfd_mem_properties *props;
>> +	struct kfd_topology_device *dev;
>> +	int i = 0;
>> +
>> +	BUG_ON(!mem);
>> +
>> +	pr_info("Found memory entry in CRAT table with proximity_domain=%d\n",
>> +			mem->promixity_domain);
>> +	list_for_each_entry(dev, &topology_device_list, list) {
>> +		if (mem->promixity_domain == i) {
>> +			props = kfd_alloc_struct(props);
>> +			if (props == 0)
>> +				return -ENOMEM;
>> +
>> +			if (dev->node_props.cpu_cores_count == 0)
>> +				props->heap_type = HSA_MEM_HEAP_TYPE_FB_PRIVATE;
>> +			else
>> +				props->heap_type = HSA_MEM_HEAP_TYPE_SYSTEM;
>> +
>> +			if (mem->flags & CRAT_MEM_FLAGS_HOT_PLUGGABLE)
>> +				props->flags |= HSA_MEM_FLAGS_HOT_PLUGGABLE;
>> +			if (mem->flags & CRAT_MEM_FLAGS_NON_VOLATILE)
>> +				props->flags |= HSA_MEM_FLAGS_NON_VOLATILE;
>> +
>> +			props->size_in_bytes = ((uint64_t)mem->length_high << 32) +
>> +						mem->length_low;
>> +			props->width = mem->width;
>> +
>> +			dev->mem_bank_count++;
>> +			list_add_tail(&props->list, &dev->mem_props);
>> +
>> +			break;
>> +		}
>> +		i++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* kfd_parse_subtype_cache is called when the topology mutex is already acquired */
>> +static int kfd_parse_subtype_cache(struct crat_subtype_cache *cache)
>> +{
>> +	struct kfd_cache_properties *props;
>> +	struct kfd_topology_device *dev;
>> +	uint32_t id;
>> +
>> +	BUG_ON(!cache);
>> +
>> +	id = cache->processor_id_low;
>> +
>> +	pr_info("Found cache entry in CRAT table with processor_id=%d\n", id);
>> +	list_for_each_entry(dev, &topology_device_list, list)
>> +		if (id == dev->node_props.cpu_core_id_base ||
>> +		    id == dev->node_props.simd_id_base) {
>> +			props = kfd_alloc_struct(props);
>> +			if (props == 0)
>> +				return -ENOMEM;
>> +
>> +			props->processor_id_low = id;
>> +			props->cache_level = cache->cache_level;
>> +			props->cache_size = cache->cache_size;
>> +			props->cacheline_size = cache->cache_line_size;
>> +			props->cachelines_per_tag = cache->lines_per_tag;
>> +			props->cache_assoc = cache->associativity;
>> +			props->cache_latency = cache->cache_latency;
>> +
>> +			if (cache->flags & CRAT_CACHE_FLAGS_DATA_CACHE)
>> +				props->cache_type |= HSA_CACHE_TYPE_DATA;
>> +			if (cache->flags & CRAT_CACHE_FLAGS_INST_CACHE)
>> +				props->cache_type |= HSA_CACHE_TYPE_INSTRUCTION;
>> +			if (cache->flags & CRAT_CACHE_FLAGS_CPU_CACHE)
>> +				props->cache_type |= HSA_CACHE_TYPE_CPU;
>> +			if (cache->flags & CRAT_CACHE_FLAGS_SIMD_CACHE)
>> +				props->cache_type |= HSA_CACHE_TYPE_HSACU;
>> +
>> +			dev->cache_count++;
>> +			dev->node_props.caches_count++;
>> +			list_add_tail(&props->list, &dev->cache_props);
>> +
>> +			break;
>> +		}
>> +
>> +	return 0;
>> +}
>> +
>> +/* kfd_parse_subtype_iolink is called when the topology mutex is already acquired */
>> +static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink)
>> +{
>> +	struct kfd_iolink_properties *props;
>> +	struct kfd_topology_device *dev;
>> +	uint32_t i = 0;
>> +	uint32_t id_from;
>> +	uint32_t id_to;
>> +
>> +	BUG_ON(!iolink);
>> +
>> +	id_from = iolink->proximity_domain_from;
>> +	id_to = iolink->proximity_domain_to;
>> +
>> +	pr_info("Found IO link entry in CRAT table with id_from=%d\n", id_from);
>> +	list_for_each_entry(dev, &topology_device_list, list) {
>> +		if (id_from == i) {
>> +			props = kfd_alloc_struct(props);
>> +			if (props == 0)
>> +				return -ENOMEM;
>> +
>> +			props->node_from = id_from;
>> +			props->node_to = id_to;
>> +			props->ver_maj = iolink->version_major;
>> +			props->ver_min = iolink->version_minor;
>> +
>> +			/*
>> +			 * weight factor (derived from CDIR), currently always 1
>> +			 */
>> +			props->weight = 1;
>> +
>> +			props->min_latency = iolink->minimum_latency;
>> +			props->max_latency = iolink->maximum_latency;
>> +			props->min_bandwidth = iolink->minimum_bandwidth_mbs;
>> +			props->max_bandwidth = iolink->maximum_bandwidth_mbs;
>> +			props->rec_transfer_size =
>> +					iolink->recommended_transfer_size;
>> +
>> +			dev->io_link_count++;
>> +			dev->node_props.io_links_count++;
>> +			list_add_tail(&props->list, &dev->io_link_props);
>> +
>> +			break;
>> +		}
>> +		i++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int kfd_parse_subtype(struct crat_subtype_generic *sub_type_hdr)
>> +{
>> +	struct crat_subtype_computeunit *cu;
>> +	struct crat_subtype_memory *mem;
>> +	struct crat_subtype_cache *cache;
>> +	struct crat_subtype_iolink *iolink;
>> +	int ret = 0;
>> +
>> +	BUG_ON(!sub_type_hdr);
>> +
>> +	switch (sub_type_hdr->type) {
>> +	case CRAT_SUBTYPE_COMPUTEUNIT_AFFINITY:
>> +		cu = (struct crat_subtype_computeunit *)sub_type_hdr;
>> +		ret = kfd_parse_subtype_cu(cu);
>> +		break;
>> +	case CRAT_SUBTYPE_MEMORY_AFFINITY:
>> +		mem = (struct crat_subtype_memory *)sub_type_hdr;
>> +		ret = kfd_parse_subtype_mem(mem);
>> +		break;
>> +	case CRAT_SUBTYPE_CACHE_AFFINITY:
>> +		cache = (struct crat_subtype_cache *)sub_type_hdr;
>> +		ret = kfd_parse_subtype_cache(cache);
>> +		break;
>> +	case CRAT_SUBTYPE_TLB_AFFINITY:
>> +		/*
>> +		 * For now, nothing to do here
>> +		 */
>> +		pr_info("Found TLB entry in CRAT table (not processing)\n");
>> +		break;
>> +	case CRAT_SUBTYPE_CCOMPUTE_AFFINITY:
>> +		/*
>> +		 * For now, nothing to do here
>> +		 */
>> +		pr_info("Found CCOMPUTE entry in CRAT table (not processing)\n");
>> +		break;
>> +	case CRAT_SUBTYPE_IOLINK_AFFINITY:
>> +		iolink = (struct crat_subtype_iolink *)sub_type_hdr;
>> +		ret = kfd_parse_subtype_iolink(iolink);
>> +		break;
>> +	default:
>> +		pr_warn("Unknown subtype (%d) in CRAT\n",
>> +				sub_type_hdr->type);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static void kfd_release_topology_device(struct kfd_topology_device *dev)
>> +{
>> +	struct kfd_mem_properties *mem;
>> +	struct kfd_cache_properties *cache;
>> +	struct kfd_iolink_properties *iolink;
>> +
>> +	BUG_ON(!dev);
>> +
>> +	list_del(&dev->list);
>> +
>> +	while (dev->mem_props.next != &dev->mem_props) {
>> +		mem = container_of(dev->mem_props.next,
>> +				struct kfd_mem_properties, list);
>> +		list_del(&mem->list);
>> +		kfree(mem);
>> +	}
>> +
>> +	while (dev->cache_props.next != &dev->cache_props) {
>> +		cache = container_of(dev->cache_props.next,
>> +				struct kfd_cache_properties, list);
>> +		list_del(&cache->list);
>> +		kfree(cache);
>> +	}
>> +
>> +	while (dev->io_link_props.next != &dev->io_link_props) {
>> +		iolink = container_of(dev->io_link_props.next,
>> +				struct kfd_iolink_properties, list);
>> +		list_del(&iolink->list);
>> +		kfree(iolink);
>> +	}
>> +
>> +	kfree(dev);
>> +
>> +	sys_props.num_devices--;
>> +}
>> +
>> +static void kfd_release_live_view(void)
>> +{
>> +	struct kfd_topology_device *dev;
>> +
>> +	while (topology_device_list.next != &topology_device_list) {
>> +		dev = container_of(topology_device_list.next,
>> +				 struct kfd_topology_device, list);
>> +		kfd_release_topology_device(dev);
>> +}
>> +
>> +	memset(&sys_props, 0, sizeof(sys_props));
>> +}
>> +
>> +static struct kfd_topology_device *kfd_create_topology_device(void)
>> +{
>> +	struct kfd_topology_device *dev;
>> +
>> +	dev = kfd_alloc_struct(dev);
>> +	if (dev == 0) {
>> +		pr_err("No memory to allocate a topology device");
>> +		return 0;
>> +	}
>> +
>> +	INIT_LIST_HEAD(&dev->mem_props);
>> +	INIT_LIST_HEAD(&dev->cache_props);
>> +	INIT_LIST_HEAD(&dev->io_link_props);
>> +
>> +	list_add_tail(&dev->list, &topology_device_list);
>> +	sys_props.num_devices++;
>> +
>> +	return dev;
>> +	}
>> +
>> +static int kfd_parse_crat_table(void *crat_image)
>> +{
>> +	struct kfd_topology_device *top_dev;
>> +	struct crat_subtype_generic *sub_type_hdr;
>> +	uint16_t node_id;
>> +	int ret;
>> +	struct crat_header *crat_table = (struct crat_header *)crat_image;
>> +	uint16_t num_nodes;
>> +	uint32_t image_len;
>> +
>> +	if (!crat_image)
>> +		return -EINVAL;
>> +
>> +	num_nodes = crat_table->num_domains;
>> +	image_len = crat_table->length;
>> +
>> +	pr_info("Parsing CRAT table with %d nodes\n", num_nodes);
>> +
>> +	for (node_id = 0; node_id < num_nodes; node_id++) {
>> +		top_dev = kfd_create_topology_device();
>> +		if (!top_dev) {
>> +			kfd_release_live_view();
>> +			return -ENOMEM;
>> +		}
>> +	}
>> +
>> +	sys_props.platform_id = (*((uint64_t *)crat_table->oem_id)) & CRAT_OEMID_64BIT_MASK;
>> +	sys_props.platform_oem = *((uint64_t *)crat_table->oem_table_id);
>> +	sys_props.platform_rev = crat_table->revision;
>> +
>> +	sub_type_hdr = (struct crat_subtype_generic *)(crat_table+1);
>> +	while ((char *)sub_type_hdr + sizeof(struct crat_subtype_generic) <
>> +			((char *)crat_image) + image_len) {
>> +		if (sub_type_hdr->flags & CRAT_SUBTYPE_FLAGS_ENABLED) {
>> +			ret = kfd_parse_subtype(sub_type_hdr);
>> +			if (ret != 0) {
>> +				kfd_release_live_view();
>> +				return ret;
>> +			}
>> +		}
>> +
>> +		sub_type_hdr = (typeof(sub_type_hdr))((char *)sub_type_hdr +
>> +				sub_type_hdr->length);
>> +	}
>> +
>> +	sys_props.generation_count++;
>> +	topology_crat_parsed = 1;
>> +
>> +	return 0;
>> +}
>> +
>> +
>> +#define sysfs_show_gen_prop(buffer, fmt, ...) \
>> +		snprintf(buffer, PAGE_SIZE, "%s"fmt, buffer, __VA_ARGS__)
>> +#define sysfs_show_32bit_prop(buffer, name, value) \
>> +		sysfs_show_gen_prop(buffer, "%s %u\n", name, value)
>> +#define sysfs_show_64bit_prop(buffer, name, value) \
>> +		sysfs_show_gen_prop(buffer, "%s %llu\n", name, value)
>> +#define sysfs_show_32bit_val(buffer, value) \
>> +		sysfs_show_gen_prop(buffer, "%u\n", value)
>> +#define sysfs_show_str_val(buffer, value) \
>> +		sysfs_show_gen_prop(buffer, "%s\n", value)
>> +
>> +static ssize_t sysprops_show(struct kobject *kobj, struct attribute *attr,
>> +		char *buffer)
>> +{
>> +	ssize_t ret;
>> +
>> +	/* Making sure that the buffer is an empty string */
>> +	buffer[0] = 0;
>> +
>> +	if (attr == &sys_props.attr_genid) {
>> +		ret = sysfs_show_32bit_val(buffer, sys_props.generation_count);
>> +	} else if (attr == &sys_props.attr_props) {
>> +		sysfs_show_64bit_prop(buffer, "platform_oem",
>> +				sys_props.platform_oem);
>> +		sysfs_show_64bit_prop(buffer, "platform_id",
>> +				sys_props.platform_id);
>> +		ret = sysfs_show_64bit_prop(buffer, "platform_rev",
>> +				sys_props.platform_rev);
>> +	} else {
>> +		ret = -EINVAL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct sysfs_ops sysprops_ops = {
>> +	.show = sysprops_show,
>> +};
>> +
>> +static struct kobj_type sysprops_type = {
>> +	.sysfs_ops = &sysprops_ops,
>> +};
>> +
>> +static ssize_t iolink_show(struct kobject *kobj, struct attribute *attr,
>> +		char *buffer)
>> +{
>> +	ssize_t ret;
>> +	struct kfd_iolink_properties *iolink;
>> +
>> +	/* Making sure that the buffer is an empty string */
>> +	buffer[0] = 0;
>> +
>> +	iolink = container_of(attr, struct kfd_iolink_properties, attr);
>> +	sysfs_show_32bit_prop(buffer, "type", iolink->iolink_type);
>> +	sysfs_show_32bit_prop(buffer, "version_major", iolink->ver_maj);
>> +	sysfs_show_32bit_prop(buffer, "version_minor", iolink->ver_min);
>> +	sysfs_show_32bit_prop(buffer, "node_from", iolink->node_from);
>> +	sysfs_show_32bit_prop(buffer, "node_to", iolink->node_to);
>> +	sysfs_show_32bit_prop(buffer, "weight", iolink->weight);
>> +	sysfs_show_32bit_prop(buffer, "min_latency", iolink->min_latency);
>> +	sysfs_show_32bit_prop(buffer, "max_latency", iolink->max_latency);
>> +	sysfs_show_32bit_prop(buffer, "min_bandwidth", iolink->min_bandwidth);
>> +	sysfs_show_32bit_prop(buffer, "max_bandwidth", iolink->max_bandwidth);
>> +	sysfs_show_32bit_prop(buffer, "recommended_transfer_size",
>> +			iolink->rec_transfer_size);
>> +	ret = sysfs_show_32bit_prop(buffer, "flags", iolink->flags);
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct sysfs_ops iolink_ops = {
>> +	.show = iolink_show,
>> +};
>> +
>> +static struct kobj_type iolink_type = {
>> +	.sysfs_ops = &iolink_ops,
>> +};
>> +
>> +static ssize_t mem_show(struct kobject *kobj, struct attribute *attr,
>> +		char *buffer)
>> +{
>> +	ssize_t ret;
>> +	struct kfd_mem_properties *mem;
>> +
>> +	/* Making sure that the buffer is an empty string */
>> +	buffer[0] = 0;
>> +
>> +	mem = container_of(attr, struct kfd_mem_properties, attr);
>> +	sysfs_show_32bit_prop(buffer, "heap_type", mem->heap_type);
>> +	sysfs_show_64bit_prop(buffer, "size_in_bytes", mem->size_in_bytes);
>> +	sysfs_show_32bit_prop(buffer, "flags", mem->flags);
>> +	sysfs_show_32bit_prop(buffer, "width", mem->width);
>> +	ret = sysfs_show_32bit_prop(buffer, "mem_clk_max", mem->mem_clk_max);
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct sysfs_ops mem_ops = {
>> +	.show = mem_show,
>> +};
>> +
>> +static struct kobj_type mem_type = {
>> +	.sysfs_ops = &mem_ops,
>> +};
>> +
>> +static ssize_t kfd_cache_show(struct kobject *kobj, struct attribute *attr,
>> +		char *buffer)
>> +{
>> +	ssize_t ret;
>> +	uint32_t i;
>> +	struct kfd_cache_properties *cache;
>> +
>> +	/* Making sure that the buffer is an empty string */
>> +	buffer[0] = 0;
>> +
>> +	cache = container_of(attr, struct kfd_cache_properties, attr);
>> +	sysfs_show_32bit_prop(buffer, "processor_id_low",
>> +			cache->processor_id_low);
>> +	sysfs_show_32bit_prop(buffer, "level", cache->cache_level);
>> +	sysfs_show_32bit_prop(buffer, "size", cache->cache_size);
>> +	sysfs_show_32bit_prop(buffer, "cache_line_size", cache->cacheline_size);
>> +	sysfs_show_32bit_prop(buffer, "cache_lines_per_tag",
>> +			cache->cachelines_per_tag);
>> +	sysfs_show_32bit_prop(buffer, "association", cache->cache_assoc);
>> +	sysfs_show_32bit_prop(buffer, "latency", cache->cache_latency);
>> +	sysfs_show_32bit_prop(buffer, "type", cache->cache_type);
>> +	snprintf(buffer, PAGE_SIZE, "%ssibling_map ", buffer);
>> +	for (i = 0; i < KFD_TOPOLOGY_CPU_SIBLINGS; i++)
>> +		ret = snprintf(buffer, PAGE_SIZE, "%s%d%s",
>> +				buffer, cache->sibling_map[i],
>> +				(i == KFD_TOPOLOGY_CPU_SIBLINGS-1) ?
>> +						"\n" : ",");
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct sysfs_ops cache_ops = {
>> +	.show = kfd_cache_show,
>> +};
>> +
>> +static struct kobj_type cache_type = {
>> +	.sysfs_ops = &cache_ops,
>> +};
>> +
>> +static ssize_t node_show(struct kobject *kobj, struct attribute *attr,
>> +		char *buffer)
>> +{
>> +	ssize_t ret;
>> +	struct kfd_topology_device *dev;
>> +	char public_name[KFD_TOPOLOGY_PUBLIC_NAME_SIZE];
>> +	uint32_t i;
>> +
>> +	/* Making sure that the buffer is an empty string */
>> +	buffer[0] = 0;
>> +
>> +	if (strcmp(attr->name, "gpu_id") == 0) {
>> +		dev = container_of(attr, struct kfd_topology_device,
>> +				attr_gpuid);
>> +		ret = sysfs_show_32bit_val(buffer, dev->gpu_id);
>> +	} else if (strcmp(attr->name, "name") == 0) {
>> +		dev = container_of(attr, struct kfd_topology_device,
>> +				attr_name);
>> +		for (i = 0; i < KFD_TOPOLOGY_PUBLIC_NAME_SIZE; i++) {
>> +			public_name[i] =
>> +					(char)dev->node_props.marketing_name[i];
>> +			if (dev->node_props.marketing_name[i] == 0)
>> +				break;
>> +		}
>> +		public_name[KFD_TOPOLOGY_PUBLIC_NAME_SIZE-1] = 0x0;
>> +		ret = sysfs_show_str_val(buffer, public_name);
>> +	} else {
>> +		dev = container_of(attr, struct kfd_topology_device,
>> +				attr_props);
>> +		sysfs_show_32bit_prop(buffer, "cpu_cores_count",
>> +				dev->node_props.cpu_cores_count);
>> +		sysfs_show_32bit_prop(buffer, "simd_count",
>> +				dev->node_props.simd_count);
>> +		sysfs_show_32bit_prop(buffer, "mem_banks_count",
>> +				dev->node_props.mem_banks_count);
>> +		sysfs_show_32bit_prop(buffer, "caches_count",
>> +				dev->node_props.caches_count);
>> +		sysfs_show_32bit_prop(buffer, "io_links_count",
>> +				dev->node_props.io_links_count);
>> +		sysfs_show_32bit_prop(buffer, "cpu_core_id_base",
>> +				dev->node_props.cpu_core_id_base);
>> +		sysfs_show_32bit_prop(buffer, "simd_id_base",
>> +				dev->node_props.simd_id_base);
>> +		sysfs_show_32bit_prop(buffer, "capability",
>> +				dev->node_props.capability);
>> +		sysfs_show_32bit_prop(buffer, "max_waves_per_simd",
>> +				dev->node_props.max_waves_per_simd);
>> +		sysfs_show_32bit_prop(buffer, "lds_size_in_kb",
>> +				dev->node_props.lds_size_in_kb);
>> +		sysfs_show_32bit_prop(buffer, "gds_size_in_kb",
>> +				dev->node_props.gds_size_in_kb);
>> +		sysfs_show_32bit_prop(buffer, "wave_front_size",
>> +				dev->node_props.wave_front_size);
>> +		sysfs_show_32bit_prop(buffer, "array_count",
>> +				dev->node_props.array_count);
>> +		sysfs_show_32bit_prop(buffer, "simd_arrays_per_engine",
>> +				dev->node_props.simd_arrays_per_engine);
>> +		sysfs_show_32bit_prop(buffer, "cu_per_simd_array",
>> +				dev->node_props.cu_per_simd_array);
>> +		sysfs_show_32bit_prop(buffer, "simd_per_cu",
>> +				dev->node_props.simd_per_cu);
>> +		sysfs_show_32bit_prop(buffer, "max_slots_scratch_cu",
>> +				dev->node_props.max_slots_scratch_cu);
>> +		sysfs_show_32bit_prop(buffer, "engine_id",
>> +				dev->node_props.engine_id);
>> +		sysfs_show_32bit_prop(buffer, "vendor_id",
>> +				dev->node_props.vendor_id);
>> +		sysfs_show_32bit_prop(buffer, "device_id",
>> +				dev->node_props.device_id);
>> +		sysfs_show_32bit_prop(buffer, "location_id",
>> +				dev->node_props.location_id);
>> +		sysfs_show_32bit_prop(buffer, "max_engine_clk_fcompute",
>> +				kfd2kgd->get_max_engine_clock_in_mhz(
>> +					dev->gpu->kgd));
>> +		sysfs_show_64bit_prop(buffer, "local_mem_size",
>> +				kfd2kgd->get_vmem_size(dev->gpu->kgd));
>> +		ret = sysfs_show_32bit_prop(buffer, "max_engine_clk_ccompute",
>> +				cpufreq_quick_get_max(0)/1000);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct sysfs_ops node_ops = {
>> +	.show = node_show,
>> +};
>> +
>> +static struct kobj_type node_type = {
>> +	.sysfs_ops = &node_ops,
>> +};
>> +
>> +static void kfd_remove_sysfs_file(struct kobject *kobj, struct attribute *attr)
>> +{
>> +	sysfs_remove_file(kobj, attr);
>> +	kobject_del(kobj);
>> +	kobject_put(kobj);
>> +}
>> +
>> +static void kfd_remove_sysfs_node_entry(struct kfd_topology_device *dev)
>> +{
>> +	struct kfd_iolink_properties *iolink;
>> +	struct kfd_cache_properties *cache;
>> +	struct kfd_mem_properties *mem;
>> +
>> +	BUG_ON(!dev);
>> +
>> +	if (dev->kobj_iolink) {
>> +		list_for_each_entry(iolink, &dev->io_link_props, list)
>> +			if (iolink->kobj) {
>> +				kfd_remove_sysfs_file(iolink->kobj, &iolink->attr);
>> +				iolink->kobj = 0;
>> +			}
>> +		kobject_del(dev->kobj_iolink);
>> +		kobject_put(dev->kobj_iolink);
>> +		dev->kobj_iolink = 0;
>> +	}
>> +
>> +	if (dev->kobj_cache) {
>> +		list_for_each_entry(cache, &dev->cache_props, list)
>> +			if (cache->kobj) {
>> +				kfd_remove_sysfs_file(cache->kobj, &cache->attr);
>> +				cache->kobj = 0;
>> +			}
>> +		kobject_del(dev->kobj_cache);
>> +		kobject_put(dev->kobj_cache);
>> +		dev->kobj_cache = 0;
>> +	}
>> +
>> +	if (dev->kobj_mem) {
>> +		list_for_each_entry(mem, &dev->mem_props, list)
>> +			if (mem->kobj) {
>> +				kfd_remove_sysfs_file(mem->kobj, &mem->attr);
>> +				mem->kobj = 0;
>> +			}
>> +		kobject_del(dev->kobj_mem);
>> +		kobject_put(dev->kobj_mem);
>> +		dev->kobj_mem = 0;
>> +	}
>> +
>> +	if (dev->kobj_node) {
>> +		sysfs_remove_file(dev->kobj_node, &dev->attr_gpuid);
>> +		sysfs_remove_file(dev->kobj_node, &dev->attr_name);
>> +		sysfs_remove_file(dev->kobj_node, &dev->attr_props);
>> +		kobject_del(dev->kobj_node);
>> +		kobject_put(dev->kobj_node);
>> +		dev->kobj_node = 0;
>> +	}
>> +}
>> +
>> +static int kfd_build_sysfs_node_entry(struct kfd_topology_device *dev,
>> +		uint32_t id)
>> +{
>> +	struct kfd_iolink_properties *iolink;
>> +	struct kfd_cache_properties *cache;
>> +	struct kfd_mem_properties *mem;
>> +	int ret;
>> +	uint32_t i;
>> +
>> +	BUG_ON(!dev);
>> +
>> +	/*
>> +	 * Creating the sysfs folders
>> +	 */
>> +	BUG_ON(dev->kobj_node);
>> +	dev->kobj_node = kfd_alloc_struct(dev->kobj_node);
>> +	if (!dev->kobj_node)
>> +		return -ENOMEM;
>> +
>> +	ret = kobject_init_and_add(dev->kobj_node, &node_type,
>> +			sys_props.kobj_nodes, "%d", id);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	dev->kobj_mem = kobject_create_and_add("mem_banks", dev->kobj_node);
>> +	if (!dev->kobj_mem)
>> +		return -ENOMEM;
>> +
>> +	dev->kobj_cache = kobject_create_and_add("caches", dev->kobj_node);
>> +	if (!dev->kobj_cache)
>> +		return -ENOMEM;
>> +
>> +	dev->kobj_iolink = kobject_create_and_add("io_links", dev->kobj_node);
>> +	if (!dev->kobj_iolink)
>> +		return -ENOMEM;
>> +
>> +	/*
>> +	 * Creating sysfs files for node properties
>> +	 */
>> +	dev->attr_gpuid.name = "gpu_id";
>> +	dev->attr_gpuid.mode = KFD_SYSFS_FILE_MODE;
>> +	sysfs_attr_init(&dev->attr_gpuid);
>> +	dev->attr_name.name = "name";
>> +	dev->attr_name.mode = KFD_SYSFS_FILE_MODE;
>> +	sysfs_attr_init(&dev->attr_name);
>> +	dev->attr_props.name = "properties";
>> +	dev->attr_props.mode = KFD_SYSFS_FILE_MODE;
>> +	sysfs_attr_init(&dev->attr_props);
>> +	ret = sysfs_create_file(dev->kobj_node, &dev->attr_gpuid);
>> +	if (ret < 0)
>> +		return ret;
>> +	ret = sysfs_create_file(dev->kobj_node, &dev->attr_name);
>> +	if (ret < 0)
>> +		return ret;
>> +	ret = sysfs_create_file(dev->kobj_node, &dev->attr_props);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	i = 0;
>> +	list_for_each_entry(mem, &dev->mem_props, list) {
>> +		mem->kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
>> +		if (!mem->kobj)
>> +			return -ENOMEM;
>> +		ret = kobject_init_and_add(mem->kobj, &mem_type,
>> +				dev->kobj_mem, "%d", i);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		mem->attr.name = "properties";
>> +		mem->attr.mode = KFD_SYSFS_FILE_MODE;
>> +		sysfs_attr_init(&mem->attr);
>> +		ret = sysfs_create_file(mem->kobj, &mem->attr);
>> +		if (ret < 0)
>> +			return ret;
>> +		i++;
>> +	}
>> +
>> +	i = 0;
>> +	list_for_each_entry(cache, &dev->cache_props, list) {
>> +		cache->kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
>> +		if (!cache->kobj)
>> +			return -ENOMEM;
>> +		ret = kobject_init_and_add(cache->kobj, &cache_type,
>> +				dev->kobj_cache, "%d", i);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		cache->attr.name = "properties";
>> +		cache->attr.mode = KFD_SYSFS_FILE_MODE;
>> +		sysfs_attr_init(&cache->attr);
>> +		ret = sysfs_create_file(cache->kobj, &cache->attr);
>> +		if (ret < 0)
>> +			return ret;
>> +		i++;
>> +	}
>> +
>> +	i = 0;
>> +	list_for_each_entry(iolink, &dev->io_link_props, list) {
>> +		iolink->kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
>> +		if (!iolink->kobj)
>> +			return -ENOMEM;
>> +		ret = kobject_init_and_add(iolink->kobj, &iolink_type,
>> +				dev->kobj_iolink, "%d", i);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		iolink->attr.name = "properties";
>> +		iolink->attr.mode = KFD_SYSFS_FILE_MODE;
>> +		sysfs_attr_init(&iolink->attr);
>> +		ret = sysfs_create_file(iolink->kobj, &iolink->attr);
>> +		if (ret < 0)
>> +			return ret;
>> +		i++;
>> +}
>> +
>> +	return 0;
>> +}
>> +
>> +static int kfd_build_sysfs_node_tree(void)
>> +{
>> +	struct kfd_topology_device *dev;
>> +	int ret;
>> +	uint32_t i = 0;
>> +
>> +	list_for_each_entry(dev, &topology_device_list, list) {
>> +		ret = kfd_build_sysfs_node_entry(dev, 0);
>> +		if (ret < 0)
>> +			return ret;
>> +		i++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void kfd_remove_sysfs_node_tree(void)
>> +{
>> +	struct kfd_topology_device *dev;
>> +
>> +	list_for_each_entry(dev, &topology_device_list, list)
>> +		kfd_remove_sysfs_node_entry(dev);
>> +}
>> +
>> +static int kfd_topology_update_sysfs(void)
>> +{
>> +	int ret;
>> +
>> +	pr_info("Creating topology SYSFS entries\n");
>> +	if (sys_props.kobj_topology == 0) {
>> +		sys_props.kobj_topology = kfd_alloc_struct(sys_props.kobj_topology);
>> +		if (!sys_props.kobj_topology)
>> +			return -ENOMEM;
>> +
>> +		ret = kobject_init_and_add(sys_props.kobj_topology,
>> +				&sysprops_type,  &kfd_device->kobj,
>> +				"topology");
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		sys_props.kobj_nodes = kobject_create_and_add("nodes",
>> +				sys_props.kobj_topology);
>> +		if (!sys_props.kobj_nodes)
>> +			return -ENOMEM;
>> +
>> +		sys_props.attr_genid.name = "generation_id";
>> +		sys_props.attr_genid.mode = KFD_SYSFS_FILE_MODE;
>> +		sysfs_attr_init(&sys_props.attr_genid);
>> +		ret = sysfs_create_file(sys_props.kobj_topology,
>> +				&sys_props.attr_genid);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		sys_props.attr_props.name = "system_properties";
>> +		sys_props.attr_props.mode = KFD_SYSFS_FILE_MODE;
>> +		sysfs_attr_init(&sys_props.attr_props);
>> +		ret = sysfs_create_file(sys_props.kobj_topology,
>> +				&sys_props.attr_props);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	kfd_remove_sysfs_node_tree();
>> +
>> +	return kfd_build_sysfs_node_tree();
>> +}
>> +
>> +static void kfd_topology_release_sysfs(void)
>> +{
>> +	kfd_remove_sysfs_node_tree();
>> +	if (sys_props.kobj_topology) {
>> +		sysfs_remove_file(sys_props.kobj_topology,
>> +				&sys_props.attr_genid);
>> +		sysfs_remove_file(sys_props.kobj_topology,
>> +				&sys_props.attr_props);
>> +		if (sys_props.kobj_nodes) {
>> +			kobject_del(sys_props.kobj_nodes);
>> +			kobject_put(sys_props.kobj_nodes);
>> +			sys_props.kobj_nodes = 0;
>> +		}
>> +		kobject_del(sys_props.kobj_topology);
>> +		kobject_put(sys_props.kobj_topology);
>> +		sys_props.kobj_topology = 0;
>> +	}
>> +}
>> +
>> +int kfd_topology_init(void)
>> +{
>> +	void *crat_image = 0;
>> +	size_t image_size = 0;
>> +	int ret;
>> +
>> +	/*
>> +	 * Initialize the head for the topology device list
>> +	 */
>> +	INIT_LIST_HEAD(&topology_device_list);
>> +	init_rwsem(&topology_lock);
>> +	topology_crat_parsed = 0;
>> +
>> +	memset(&sys_props, 0, sizeof(sys_props));
>> +
>> +	/*
>> +	 * Get the CRAT image from the ACPI
>> +	 */
>> +	ret = kfd_topology_get_crat_acpi(crat_image, &image_size);
>> +	if (ret == 0 && image_size > 0) {
>> +		pr_info("Found CRAT image with size=%zd\n", image_size);
>> +		crat_image = kmalloc(image_size, GFP_KERNEL);
>> +		if (!crat_image) {
>> +			ret = -ENOMEM;
>> +			pr_err("No memory for allocating CRAT image\n");
>> +			goto err;
>> +		}
>> +		ret = kfd_topology_get_crat_acpi(crat_image, &image_size);
>> +
>> +		if (ret == 0) {
>> +			down_write(&topology_lock);
>> +			ret = kfd_parse_crat_table(crat_image);
>> +			if (ret == 0)
>> +				ret = kfd_topology_update_sysfs();
>> +			up_write(&topology_lock);
>> +		} else {
>> +			pr_err("Couldn't get CRAT table size from ACPI\n");
>> +		}
>> +		kfree(crat_image);
>> +	} else if (ret == -ENODATA) {
>> +		ret = 0;
>> +	} else {
>> +		pr_err("Couldn't get CRAT table size from ACPI\n");
>> +	}
>> +
>> +err:
>> +	pr_info("Finished initializing topology ret=%d\n", ret);
>> +	return ret;
>> +}
>> +
>> +void kfd_topology_shutdown(void)
>> +{
>> +	kfd_topology_release_sysfs();
>> +	kfd_release_live_view();
>> +}
>> +
>> +static void kfd_debug_print_topology(void)
>> +{
>> +	struct kfd_topology_device *dev;
>> +	uint32_t i = 0;
>> +
>> +	pr_info("DEBUG PRINT OF TOPOLOGY:");
>> +	list_for_each_entry(dev, &topology_device_list, list) {
>> +		pr_info("Node: %d\n", i);
>> +		pr_info("\tGPU assigned: %s\n", (dev->gpu ? "yes" : "no"));
>> +		pr_info("\tCPU count: %d\n", dev->node_props.cpu_cores_count);
>> +		pr_info("\tSIMD count: %d", dev->node_props.simd_count);
>> +		i++;
>> +	}
>> +}
>> +
>> +static uint32_t kfd_generate_gpu_id(struct kfd_dev *gpu)
>> +{
>> +	uint32_t hashout;
>> +	uint32_t buf[7];
>> +	int i;
>> +
>> +	if (!gpu)
>> +		return 0;
>> +
>> +	buf[0] = gpu->pdev->devfn;
>> +	buf[1] = gpu->pdev->subsystem_vendor;
>> +	buf[2] = gpu->pdev->subsystem_device;
>> +	buf[3] = gpu->pdev->device;
>> +	buf[4] = gpu->pdev->bus->number;
>> +	buf[5] = (uint32_t)(kfd2kgd->get_vmem_size(gpu->kgd) & 0xffffffff);
>> +	buf[6] = (uint32_t)(kfd2kgd->get_vmem_size(gpu->kgd) >> 32);
>> +
>> +	for (i = 0, hashout = 0; i < 7; i++)
>> +		hashout ^= hash_32(buf[i], KFD_GPU_ID_HASH_WIDTH);
>> +
>> +	return hashout;
>> +}
>> +
>> +static struct kfd_topology_device *kfd_assign_gpu(struct kfd_dev *gpu)
>> +{
>> +	struct kfd_topology_device *dev;
>> +	struct kfd_topology_device *out_dev = 0;
>> +
>> +	BUG_ON(!gpu);
>> +
>> +	list_for_each_entry(dev, &topology_device_list, list)
>> +		if (dev->gpu == 0 && dev->node_props.simd_count > 0) {
>> +			dev->gpu = gpu;
>> +			out_dev = dev;
>> +			break;
>> +		}
>> +
>> +	return out_dev;
>> +}
>> +
>> +static void kfd_notify_gpu_change(uint32_t gpu_id, int arrival)
>> +{
>> +	/*
>> +	 * TODO: Generate an event for thunk about the arrival/removal
>> +	 * of the GPU
>> +	 */
>> +}
>> +
>> +int kfd_topology_add_device(struct kfd_dev *gpu)
>> +{
>> +	uint32_t gpu_id;
>> +	struct kfd_topology_device *dev;
>> +	int res;
>> +
>> +	BUG_ON(!gpu);
>> +
>> +	gpu_id = kfd_generate_gpu_id(gpu);
>> +
>> +	pr_debug("kfd: Adding new GPU (ID: 0x%x) to topology\n", gpu_id);
>> +
>> +	down_write(&topology_lock);
>> +	/*
>> +	 * Try to assign the GPU to existing topology device (generated from
>> +	 * CRAT table
>> +	 */
>> +	dev = kfd_assign_gpu(gpu);
>> +	if (!dev) {
>> +		pr_info("GPU was not found in the current topology. Extending.\n");
>> +		kfd_debug_print_topology();
>> +		dev = kfd_create_topology_device();
>> +		if (!dev) {
>> +			res = -ENOMEM;
>> +			goto err;
>> +		}
>> +		dev->gpu = gpu;
>> +
>> +		/*
>> +		 * TODO: Make a call to retrieve topology information from the
>> +		 * GPU vBIOS
>> +		 */
>> +
>> +		/*
>> +		 * Update the SYSFS tree, since we added another topology device
>> +		 */
>> +		if (kfd_topology_update_sysfs() < 0)
>> +			kfd_topology_release_sysfs();
>> +
>> +	}
>> +
>> +	dev->gpu_id = gpu_id;
>> +	gpu->id = gpu_id;
>> +	dev->node_props.vendor_id = gpu->pdev->vendor;
>> +	dev->node_props.device_id = gpu->pdev->device;
>> +	dev->node_props.location_id = (gpu->pdev->bus->number << 24) +
>> +			(gpu->pdev->devfn & 0xffffff);
>> +	/*
>> +	 * TODO: Retrieve max engine clock values from KGD
>> +	 */
>> +
>> +	res = 0;
>> +
>> +err:
>> +	up_write(&topology_lock);
>> +
>> +	if (res == 0)
>> +		kfd_notify_gpu_change(gpu_id, 1);
>> +
>> +	return res;
>> +}
>> +
>> +int kfd_topology_remove_device(struct kfd_dev *gpu)
>> +{
>> +	struct kfd_topology_device *dev;
>> +	uint32_t gpu_id;
>> +	int res = -ENODEV;
>> +
>> +	BUG_ON(!gpu);
>> +
>> +	down_write(&topology_lock);
>> +
>> +	list_for_each_entry(dev, &topology_device_list, list)
>> +		if (dev->gpu == gpu) {
>> +			gpu_id = dev->gpu_id;
>> +			kfd_remove_sysfs_node_entry(dev);
>> +			kfd_release_topology_device(dev);
>> +			res = 0;
>> +			if (kfd_topology_update_sysfs() < 0)
>> +				kfd_topology_release_sysfs();
>> +			break;
>> +		}
>> +
>> +	up_write(&topology_lock);
>> +
>> +	if (res == 0)
>> +		kfd_notify_gpu_change(gpu_id, 0);
>> +
>> +	return res;
>> +}
>> +
>> +/*
>> + * When idx is out of bounds, the function will return NULL
>> + */
>> +struct kfd_dev *kfd_topology_enum_kfd_devices(uint8_t idx)
>> +{
>> +
>> +	struct kfd_topology_device *top_dev;
>> +	struct kfd_dev *device = NULL;
>> +	uint8_t device_idx = 0;
>> +
>> +	down_read(&topology_lock);
>> +
>> +	list_for_each_entry(top_dev, &topology_device_list, list) {
>> +		if (device_idx == idx) {
>> +			device = top_dev->gpu;
>> +			break;
>> +		}
>> +
>> +		device_idx++;
>> +	}
>> +
>> +	up_read(&topology_lock);
>> +
>> +	return device;
>> +
>> +}
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_topology.h b/drivers/gpu/drm/radeon/amdkfd/kfd_topology.h
>> new file mode 100644
>> index 0000000..989624b
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_topology.h
>> @@ -0,0 +1,168 @@
>> +/*
>> + * Copyright 2014 Advanced Micro Devices, Inc.
>> + *
>> + * Permission is hereby granted, free of charge, to any person obtaining a
>> + * copy of this software and associated documentation files (the "Software"),
>> + * to deal in the Software without restriction, including without limitation
>> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
>> + * and/or sell copies of the Software, and to permit persons to whom the
>> + * Software is furnished to do so, subject to the following conditions:
>> + *
>> + * The above copyright notice and this permission notice shall be included in
>> + * all copies or substantial portions of the Software.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#ifndef __KFD_TOPOLOGY_H__
>> +#define __KFD_TOPOLOGY_H__
>> +
>> +#include <linux/types.h>
>> +#include <linux/list.h>
>> +#include "kfd_priv.h"
>> +
>> +#define KFD_TOPOLOGY_PUBLIC_NAME_SIZE 128
>> +
>> +#define HSA_CAP_HOT_PLUGGABLE			0x00000001
>> +#define HSA_CAP_ATS_PRESENT			0x00000002
>> +#define HSA_CAP_SHARED_WITH_GRAPHICS		0x00000004
>> +#define HSA_CAP_QUEUE_SIZE_POW2			0x00000008
>> +#define HSA_CAP_QUEUE_SIZE_32BIT		0x00000010
>> +#define HSA_CAP_QUEUE_IDLE_EVENT		0x00000020
>> +#define HSA_CAP_VA_LIMIT			0x00000040
>> +#define HSA_CAP_WATCH_POINTS_SUPPORTED		0x00000080
>> +#define HSA_CAP_WATCH_POINTS_TOTALBITS_MASK	0x00000f00
>> +#define HSA_CAP_WATCH_POINTS_TOTALBITS_SHIFT	8
>> +#define HSA_CAP_RESERVED			0xfffff000
>> +
>> +struct kfd_node_properties {
>> +	uint32_t cpu_cores_count;
>> +	uint32_t simd_count;
>> +	uint32_t mem_banks_count;
>> +	uint32_t caches_count;
>> +	uint32_t io_links_count;
>> +	uint32_t cpu_core_id_base;
>> +	uint32_t simd_id_base;
>> +	uint32_t capability;
>> +	uint32_t max_waves_per_simd;
>> +	uint32_t lds_size_in_kb;
>> +	uint32_t gds_size_in_kb;
>> +	uint32_t wave_front_size;
>> +	uint32_t array_count;
>> +	uint32_t simd_arrays_per_engine;
>> +	uint32_t cu_per_simd_array;
>> +	uint32_t simd_per_cu;
>> +	uint32_t max_slots_scratch_cu;
>> +	uint32_t engine_id;
>> +	uint32_t vendor_id;
>> +	uint32_t device_id;
>> +	uint32_t location_id;
>> +	uint32_t max_engine_clk_fcompute;
>> +	uint32_t max_engine_clk_ccompute;
>> +	uint16_t marketing_name[KFD_TOPOLOGY_PUBLIC_NAME_SIZE];
>> +};
>> +
>> +#define HSA_MEM_HEAP_TYPE_SYSTEM	0
>> +#define HSA_MEM_HEAP_TYPE_FB_PUBLIC	1
>> +#define HSA_MEM_HEAP_TYPE_FB_PRIVATE	2
>> +#define HSA_MEM_HEAP_TYPE_GPU_GDS	3
>> +#define HSA_MEM_HEAP_TYPE_GPU_LDS	4
>> +#define HSA_MEM_HEAP_TYPE_GPU_SCRATCH	5
>> +
>> +#define HSA_MEM_FLAGS_HOT_PLUGGABLE	0x00000001
>> +#define HSA_MEM_FLAGS_NON_VOLATILE	0x00000002
>> +#define HSA_MEM_FLAGS_RESERVED		0xfffffffc
>> +
>> +struct kfd_mem_properties {
>> +	struct list_head	list;
>> +	uint32_t		heap_type;
>> +	uint64_t		size_in_bytes;
>> +	uint32_t		flags;
>> +	uint32_t		width;
>> +	uint32_t		mem_clk_max;
>> +	struct kobject		*kobj;
>> +	struct attribute	attr;
>> +};
>> +
>> +#define KFD_TOPOLOGY_CPU_SIBLINGS 256
>> +
>> +#define HSA_CACHE_TYPE_DATA		0x00000001
>> +#define HSA_CACHE_TYPE_INSTRUCTION	0x00000002
>> +#define HSA_CACHE_TYPE_CPU		0x00000004
>> +#define HSA_CACHE_TYPE_HSACU		0x00000008
>> +#define HSA_CACHE_TYPE_RESERVED		0xfffffff0
>> +
>> +struct kfd_cache_properties {
>> +	struct list_head	list;
>> +	uint32_t		processor_id_low;
>> +	uint32_t		cache_level;
>> +	uint32_t		cache_size;
>> +	uint32_t		cacheline_size;
>> +	uint32_t		cachelines_per_tag;
>> +	uint32_t		cache_assoc;
>> +	uint32_t		cache_latency;
>> +	uint32_t		cache_type;
>> +	uint8_t			sibling_map[KFD_TOPOLOGY_CPU_SIBLINGS];
>> +	struct kobject		*kobj;
>> +	struct attribute	attr;
>> +};
>> +
>> +struct kfd_iolink_properties {
>> +	struct list_head	list;
>> +	uint32_t		iolink_type;
>> +	uint32_t		ver_maj;
>> +	uint32_t		ver_min;
>> +	uint32_t		node_from;
>> +	uint32_t		node_to;
>> +	uint32_t		weight;
>> +	uint32_t		min_latency;
>> +	uint32_t		max_latency;
>> +	uint32_t		min_bandwidth;
>> +	uint32_t		max_bandwidth;
>> +	uint32_t		rec_transfer_size;
>> +	uint32_t		flags;
>> +	struct kobject		*kobj;
>> +	struct attribute	attr;
>> +};
>> +
>> +struct kfd_topology_device {
>> +	struct list_head		list;
>> +	uint32_t			gpu_id;
>> +	struct kfd_node_properties	node_props;
>> +	uint32_t			mem_bank_count;
>> +	struct list_head		mem_props;
>> +	uint32_t			cache_count;
>> +	struct list_head		cache_props;
>> +	uint32_t			io_link_count;
>> +	struct list_head		io_link_props;
>> +	struct kfd_dev			*gpu;
>> +	struct kobject			*kobj_node;
>> +	struct kobject			*kobj_mem;
>> +	struct kobject			*kobj_cache;
>> +	struct kobject			*kobj_iolink;
>> +	struct attribute		attr_gpuid;
>> +	struct attribute		attr_name;
>> +	struct attribute		attr_props;
>> +};
>> +
>> +struct kfd_system_properties {
>> +	uint32_t		num_devices;     /* Number of H-NUMA nodes */
>> +	uint32_t		generation_count;
>> +	uint64_t		platform_oem;
>> +	uint64_t		platform_id;
>> +	uint64_t		platform_rev;
>> +	struct kobject		*kobj_topology;
>> +	struct kobject		*kobj_nodes;
>> +	struct attribute	attr_genid;
>> +	struct attribute	attr_props;
>> +};
>> +
>> +
>> +
>> +#endif /* __KFD_TOPOLOGY_H__ */
>> --
>> 1.9.1
>>

