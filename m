Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaHBT0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 15:26:07 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:47660
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754735AbaHBT0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 15:26:04 -0400
X-WSS-ID: 0N9P1YP-07-5PK-02
X-M-MSG: 
Message-ID: <53DD3B28.7020708@amd.com>
Date: Sat, 2 Aug 2014 22:25:28 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>
Subject: Re: [PATCH v2 11/25] amdkfd: Add basic modules to amdkfd
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-12-git-send-email-oded.gabbay@amd.com>
 <20140720230239.GG3068@gmail.com>
In-Reply-To: <20140720230239.GG3068@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.144]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(51704005)(51234002)(24454002)(479174003)(79102001)(106466001)(99396002)(107046002)(31966008)(76482001)(85306004)(95666004)(86362001)(77982001)(68736004)(33656002)(54356999)(102836001)(92726001)(65816999)(87266999)(76176999)(4396001)(50986999)(20776003)(46102001)(97736001)(105586002)(81342001)(83506001)(101416001)(74662001)(81542001)(19580395003)(80022001)(64706001)(84676001)(50466002)(74502001)(65806001)(65956001)(44976005)(23676002)(19580405001)(47776003)(87936001)(83322001)(36756003)(21056001)(85852003)(2201001)(83072002)(92566001)(80316001)(129583001)(559001)(579004);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB038;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029174C036
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/07/14 02:02, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:29:18PM +0300, Oded Gabbay wrote:
>> From: Andrew Lewycky <Andrew.Lewycky@amd.com>
>>
>> This patch adds the process module and 4 helper modules:
>>
>> - kfd_process, which handles process which open /dev/kfd
>> - kfd_doorbell, which provides helper functions for doorbell allocation, release and mapping to userspace
>> - kfd_pasid, which provides helper functions for pasid allocation and release
>> - kfd_vidmem, which provides helper functions for allocation and release of memory from the gfx driver
>> - kfd_aperture, which provides helper functions for managing the LDS, Local GPU memory and Scratch memory apertures of the process
>>
>> This patch only contains the basic kfd_process module, which doesn't contain the reference to the queue scheduler. This was done to allow easier code review.
>>
>> Also, this patch doesn't contain the calls to the IOMMU driver for binding the pasid to the device. Again, this was done to allow easier code review
>>
>> The kfd_process object is created when a process opens /dev/kfd and is closed when the mm_struct of that process is teared-down.
> 
> So i valid argument were made to have one file per device and because this is not
> a common hsa architecture i am rather reluctant to add the /dev/kfd directory just
> for a temporary solution until people inside the HSA foundation get there act to-
> gether and work on a common API.
> 
> So i rather have all kfd temporary solution inside the radeon driver under the
> drm folder. I think we have enough ioctl left to accomodate you.
> 
>>
>> Signed-off-by: Andrew Lewycky <Andrew.Lewycky@amd.com>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>  drivers/gpu/drm/radeon/amdkfd/Makefile       |   4 +-
>>  drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c | 123 +++++++++
>>  drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c  |  36 ++-
>>  drivers/gpu/drm/radeon/amdkfd/kfd_device.c   |   2 +
>>  drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c | 264 +++++++++++++++++++
>>  drivers/gpu/drm/radeon/amdkfd/kfd_module.c   |  22 ++
>>  drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c    |  97 +++++++
>>  drivers/gpu/drm/radeon/amdkfd/kfd_priv.h     | 148 +++++++++++
>>  drivers/gpu/drm/radeon/amdkfd/kfd_process.c  | 374 +++++++++++++++++++++++++++
>>  drivers/gpu/drm/radeon/amdkfd/kfd_vidmem.c   |  96 +++++++
>>  10 files changed, 1163 insertions(+), 3 deletions(-)
>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process.c
>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_vidmem.c
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
>> index 08ecfcd..daf75a8 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/Makefile
>> +++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
>> @@ -4,6 +4,8 @@
>>  
>>  ccflags-y := -Iinclude/drm
>>  
>> -amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o
>> +amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
>> +		kfd_pasid.o kfd_doorbell.o kfd_vidmem.o kfd_aperture.o \
>> +		kfd_process.o
>>  
>>  obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c b/drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
>> new file mode 100644
>> index 0000000..0468114
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
>> @@ -0,0 +1,123 @@
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
>> + *
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/export.h>
>> +#include <linux/err.h>
>> +#include <linux/fs.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/compat.h>
>> +#include <uapi/linux/kfd_ioctl.h>
>> +#include <linux/time.h>
>> +#include "kfd_priv.h"
>> +#include <linux/mm.h>
>> +#include <uapi/asm-generic/mman-common.h>
>> +#include <asm/processor.h>
>> +
>> +
>> +#define MAKE_GPUVM_APP_BASE(gpu_num) (((uint64_t)(gpu_num) << 61) + 0x1000000000000)
>> +#define MAKE_GPUVM_APP_LIMIT(base) (((uint64_t)(base) & 0xFFFFFF0000000000) | 0xFFFFFFFFFF)
>> +#define MAKE_SCRATCH_APP_BASE(gpu_num) (((uint64_t)(gpu_num) << 61) + 0x100000000)
>> +#define MAKE_SCRATCH_APP_LIMIT(base) (((uint64_t)base & 0xFFFFFFFF00000000) | 0xFFFFFFFF)
>> +#define MAKE_LDS_APP_BASE(gpu_num) (((uint64_t)(gpu_num) << 61) + 0x0)
>> +#define MAKE_LDS_APP_LIMIT(base) (((uint64_t)(base) & 0xFFFFFFFF00000000) | 0xFFFFFFFF)
>> +
>> +#define HSA_32BIT_LDS_APP_SIZE 0x10000
>> +#define HSA_32BIT_LDS_APP_ALIGNMENT 0x10000
>> +
>> +static unsigned long kfd_reserve_aperture(struct kfd_process *process, unsigned long len, unsigned long alignment)
>> +{
>> +
>> +	unsigned long addr = 0;
>> +	unsigned long start_address;
>> +
>> +	/*
>> +	 * Go bottom up and find the first available aligned address.
>> +	 * We may narrow space to scan by getting mmap range limits.
>> +	 */
>> +	for (start_address =  alignment; start_address < (TASK_SIZE - alignment); start_address += alignment) {
>> +		addr = vm_mmap(NULL, start_address, len, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, 0);
> 
> So this forcing aperture into address space process is not really
> welcome. Userspace have no idea this will happen and valid existing
> program may already staticly allocate those address through mmap
> either after or before they might trigger this code.
> 
> As i said in the general answer, i think best here is to use the
> kernel reserved area to map this. You can work around the gate
> page if gate page matter to you.

We talked about it in another thread, but to sum it up, I removed the
support for LDS aperture in 32 bit mode (which is the mode that uses the
above function).
> 
> This of course beg the question what happen if gpu try to access
> inside the kernel region ? Does the iommu respect the system flag
> of the page table ? Or does it just happily allow the gpu to access
> the whole kernel area ?
> 
> I guess i should go dive into the iommuv2 datasheet to find out.
> 
>> +		if (!IS_ERR_VALUE(addr)) {
>> +			if (addr == start_address)
>> +				return addr;
>> +			vm_munmap(addr, len);
>> +		}
>> +	}
>> +	return 0;
>> +
>> +}
>> +
>> +int kfd_init_apertures(struct kfd_process *process)
>> +{
>> +	uint8_t id  = 0;
>> +	struct kfd_dev *dev;
>> +	struct kfd_process_device *pdd;
>> +
>> +	mutex_lock(&process->mutex);
>> +
>> +	/*Iterating over all devices*/
>> +	while ((dev = kfd_topology_enum_kfd_devices(id)) != NULL && id < NUM_OF_SUPPORTED_GPUS) {
>> +
>> +		pdd = kfd_get_process_device_data(dev, process);
>> +
>> +		/*for 64 bit process aperture will be statically reserved in the non canonical process address space
> 
> What does non canonical process address space means ? This is the x86-64 terminology
> or something else ?
This is the x86_64 terminology. In v3 I will add detailed explanation on
this subject.
> 
>> +		 *for 32 bit process the aperture will be reserved in the process address space
>> +		 */
>> +		if (process->is_32bit_user_mode) {
>> +			/*try to reserve aperture. continue on failure, just put the aperture size to be 0*/
>> +			pdd->lds_base = kfd_reserve_aperture(
>> +						process,
>> +						HSA_32BIT_LDS_APP_SIZE,
>> +						HSA_32BIT_LDS_APP_ALIGNMENT);
>> +
>> +			if (pdd->lds_base)
>> +				pdd->lds_limit = pdd->lds_base + HSA_32BIT_LDS_APP_SIZE - 1;
>> +			else
>> +				pdd->lds_limit = 0;
>> +
>> +			/*GPUVM and Scratch apertures are not supported*/
>> +			pdd->gpuvm_base = pdd->gpuvm_limit = pdd->scratch_base = pdd->scratch_limit = 0;
>> +		} else {
>> +			/*node id couldn't be 0 - the three MSB bits of aperture shoudn't be 0*/
>> +			pdd->lds_base = MAKE_LDS_APP_BASE(id + 1);
>> +			pdd->lds_limit = MAKE_LDS_APP_LIMIT(pdd->lds_base);
>> +			pdd->gpuvm_base = MAKE_GPUVM_APP_BASE(id + 1);
>> +			pdd->gpuvm_limit = MAKE_GPUVM_APP_LIMIT(pdd->gpuvm_base);
>> +			pdd->scratch_base = MAKE_SCRATCH_APP_BASE(id + 1);
>> +			pdd->scratch_limit = MAKE_SCRATCH_APP_LIMIT(pdd->scratch_base);
>> +		}
>> +
>> +		dev_dbg(kfd_device, "node id %u, gpu id %u, lds_base %llX lds_limit %llX gpuvm_base %llX gpuvm_limit %llX scratch_base %llX scratch_limit %llX",
>> +				id, pdd->dev->id, pdd->lds_base, pdd->lds_limit, pdd->gpuvm_base, pdd->gpuvm_limit, pdd->scratch_base, pdd->scratch_limit);
> 
> Break this debug output into several debug message. Not all of us have 30"
> monitor.
Done in v3
> 
>> +
>> +		id++;
>> +	}
>> +
>> +	mutex_unlock(&process->mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>> index b98bcb7..d6580a6 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
>> @@ -38,6 +38,7 @@
>>  
>>  static long kfd_ioctl(struct file *, unsigned int, unsigned long);
>>  static int kfd_open(struct inode *, struct file *);
>> +static int kfd_mmap(struct file *, struct vm_area_struct *);
>>  
>>  static const char kfd_dev_name[] = "kfd";
>>  
>> @@ -46,6 +47,7 @@ static const struct file_operations kfd_fops = {
>>  	.unlocked_ioctl = kfd_ioctl,
>>  	.compat_ioctl = kfd_ioctl,
>>  	.open = kfd_open,
>> +	.mmap = kfd_mmap,
>>  };
>>  
>>  static int kfd_char_dev_major = -1;
>> @@ -96,9 +98,22 @@ struct device *kfd_chardev(void)
>>  
>>  static int kfd_open(struct inode *inode, struct file *filep)
>>  {
>> +	struct kfd_process *process;
>> +
>>  	if (iminor(inode) != 0)
>>  		return -ENODEV;
>>  
>> +	process = kfd_create_process(current);
>> +	if (IS_ERR(process))
>> +		return PTR_ERR(process);
>> +
>> +	process->is_32bit_user_mode = is_compat_task();
>> +
>> +	dev_dbg(kfd_device, "process %d opened, compat mode (32 bit) - %d\n",
>> +		process->pasid, process->is_32bit_user_mode);
>> +
>> +	kfd_init_apertures(process);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -152,8 +167,9 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>>  		"ioctl cmd 0x%x (#%d), arg 0x%lx\n",
>>  		cmd, _IOC_NR(cmd), arg);
>>  
>> -	/* TODO: add function that retrieves process */
>> -	process = NULL;
>> +	process = kfd_get_process(current);
>> +	if (IS_ERR(process))
>> +		return PTR_ERR(process);
>>  
>>  	switch (cmd) {
>>  	case KFD_IOC_CREATE_QUEUE:
>> @@ -201,3 +217,19 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>>  
>>  	return err;
>>  }
>> +
>> +static int
>> +kfd_mmap(struct file *filp, struct vm_area_struct *vma)
>> +{
>> +	unsigned long pgoff = vma->vm_pgoff;
>> +	struct kfd_process *process;
>> +
>> +	process = kfd_get_process(current);
>> +	if (IS_ERR(process))
>> +		return PTR_ERR(process);
>> +
>> +	if (pgoff >= KFD_MMAP_DOORBELL_START && pgoff < KFD_MMAP_DOORBELL_END)
>> +		return kfd_doorbell_mmap(process, vma);
>> +
>> +	return -EINVAL;
>> +}
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>> index 4138694..f6a7cf7 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
>> @@ -100,6 +100,8 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
>>  {
>>  	kfd->shared_resources = *gpu_resources;
>>  
>> +	kfd_doorbell_init(kfd);
>> +
>>  	if (kfd_topology_add_device(kfd) != 0)
>>  		return false;
>>  
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
>> new file mode 100644
>> index 0000000..972eaea
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
>> @@ -0,0 +1,264 @@
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
>> +#include "kfd_priv.h"
>> +#include <linux/mm.h>
>> +#include <linux/mman.h>
>> +#include <linux/slab.h>
>> +
>> +/*
>> + * This extension supports a kernel level doorbells management for
>> + * the kernel queues.
>> + * Basically the last doorbells page is devoted to kernel queues
>> + * and that's assures that any user process won't get access to the
>> + * kernel doorbells page
>> + */
>> +static DEFINE_MUTEX(doorbell_mutex);
>> +static unsigned long doorbell_available_index[DIV_ROUND_UP(MAX_PROCESS_QUEUES, BITS_PER_LONG)] = { 0 };
>> +#define KERNEL_DOORBELL_PASID 1
>> +
>> +/*
>> + * Each device exposes a doorbell aperture, a PCI MMIO aperture that
>> + * receives 32-bit writes that are passed to queues as wptr values.
>> + * The doorbells are intended to be written by applications as part
>> + * of queueing work on user-mode queues.
>> + * We assign doorbells to applications in PAGE_SIZE-sized and aligned chunks.
>> + * We map the doorbell address space into user-mode when a process creates
>> + * its first queue on each device.
>> + * Although the mapping is done by KFD, it is equivalent to an mmap of
>> + * the /dev/kfd with the particular device encoded in the mmap offset.
>> + * There will be other uses for mmap of /dev/kfd, so only a range of
>> + * offsets (KFD_MMAP_DOORBELL_START-END) is used for doorbells.
>> + */
> 
> Mapping should not be done by the driver instead you should provide the
> offset to userspace and have userspace call mmap with proper argument.
> I do not think having device driver doing mmap in the back of an ioctl
> would be a welcome idea.
> 
Done in v3

>> +
>> +/* # of doorbell bytes allocated for each process. */
>> +static inline size_t doorbell_process_allocation(void)
>> +{
>> +	return roundup(sizeof(doorbell_t) * MAX_PROCESS_QUEUES, PAGE_SIZE);
>> +}
> 
> This whole doorbell situation needs some cleanup instead of passing every
> things as byte and byte offset you should rather pass everything as pfn and
> pgoffset so it is clear that a doorbell is on page granularity and you will
> not have to clutter all kind of align and round up accross code. Just cleaner
> and safer.
> 
Done in v3
>> +
>> +/* Doorbell calculations for device init. */
>> +void kfd_doorbell_init(struct kfd_dev *kfd)
>> +{
>> +	size_t doorbell_start_offset;
>> +	size_t doorbell_aperture_size;
>> +	size_t doorbell_process_limit;
>> +
>> +	/*
>> +	 * We start with calculations in bytes because the input data might
>> +	 * only be byte-aligned.
>> +	 * Only after we have done the rounding can we assume any alignment.
>> +	 */
>> +
>> +	doorbell_start_offset = roundup(kfd->shared_resources.doorbell_start_offset,
>> +					doorbell_process_allocation());
>> +	doorbell_aperture_size = rounddown(kfd->shared_resources.doorbell_aperture_size,
>> +					doorbell_process_allocation());
>> +
>> +	if (doorbell_aperture_size > doorbell_start_offset)
>> +		doorbell_process_limit =
>> +			(doorbell_aperture_size - doorbell_start_offset) / doorbell_process_allocation();
>> +	else
>> +		doorbell_process_limit = 0;
>> +
>> +	kfd->doorbell_base = kfd->shared_resources.doorbell_physical_address + doorbell_start_offset;
>> +	kfd->doorbell_id_offset = doorbell_start_offset / sizeof(doorbell_t);
>> +	kfd->doorbell_process_limit = doorbell_process_limit - 1;
>> +
>> +	kfd->doorbell_kernel_ptr = ioremap(kfd->doorbell_base, doorbell_process_allocation());
>> +	BUG_ON(!kfd->doorbell_kernel_ptr);
>> +
>> +	pr_debug("kfd: doorbell initialization\n"
>> +				 "     doorbell base           == 0x%08lX\n"
>> +				 "     doorbell_id_offset      == 0x%08lu\n"
>> +				 "     doorbell_process_limit  == 0x%08lu\n"
>> +				 "     doorbell_kernel_offset  == 0x%08lX\n"
>> +				 "     doorbell aperture size  == 0x%08lX\n"
>> +				 "     doorbell kernel address == 0x%08lX\n",
>> +				 (uintptr_t)kfd->doorbell_base,
>> +				 kfd->doorbell_id_offset,
>> +				 doorbell_process_limit,
>> +				 (uintptr_t)kfd->doorbell_base,
>> +				 kfd->shared_resources.doorbell_aperture_size,
>> +				 (uintptr_t)kfd->doorbell_kernel_ptr);
> 
> Kind of ugly, will break some of the kernel log manager, you need to do one
> pr_debug call per line.
> 
Done in v3

>> +
>> +}
>> +
>> +/*
>> + * This is the /dev/kfd mmap (for doorbell) implementation.
>> + * We intend that this is only called through map_doorbells, not through
>> + * user-mode mmap of /dev/kfd
>> + */
>> +int kfd_doorbell_mmap(struct kfd_process *process, struct vm_area_struct *vma)
>> +{
>> +	unsigned int device_index;
>> +	struct kfd_dev *dev;
>> +	phys_addr_t start;
>> +
>> +	BUG_ON(vma->vm_pgoff < KFD_MMAP_DOORBELL_START || vma->vm_pgoff >= KFD_MMAP_DOORBELL_END);
>> +
>> +	/* For simplicitly we only allow mapping of the entire doorbell allocation of a single device & process. */
>> +	if (vma->vm_end - vma->vm_start != doorbell_process_allocation())
>> +		return -EINVAL;
>> +
>> +	/* device_index must be GPU ID!! */
>> +	device_index = vma->vm_pgoff - KFD_MMAP_DOORBELL_START;
>> +
>> +	dev = kfd_device_by_id(device_index);
>> +	if (dev == NULL)
>> +		return -EINVAL;
>> +
>> +	vma->vm_flags |= VM_IO | VM_DONTCOPY | VM_DONTEXPAND | VM_NORESERVE | VM_DONTDUMP | VM_PFNMAP;
>> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> +
>> +	start = dev->doorbell_base + process->pasid * doorbell_process_allocation();
>> +
>> +	pr_debug("kfd: mapping doorbell page in kfd_doorbell_mmap\n"
>> +		 "     target user address == 0x%016llX\n"
>> +		 "     physical address    == 0x%016llX\n"
>> +		 "     vm_flags            == 0x%08lX\n"
>> +		 "     size                == 0x%08lX\n",
>> +		 (long long unsigned int) vma->vm_start, start, vma->vm_flags,
>> +		 doorbell_process_allocation());
>> +
>> +	return io_remap_pfn_range(vma,
>> +				vma->vm_start,
>> +				start >> PAGE_SHIFT,
>> +				doorbell_process_allocation(),
>> +				vma->vm_page_prot);
>> +}
>> +
>> +/*
>> + * Map the doorbells for a single process & device.
>> + * This will indirectly call kfd_doorbell_mmap.
>> + * This assumes that the process mutex is being held.
>> + */
>> +static int map_doorbells(struct file *devkfd, struct kfd_process *process,
>> +				struct kfd_dev *dev)
>> +{
>> +	struct kfd_process_device *pdd = kfd_get_process_device_data(dev, process);
>> +
>> +	if (pdd == NULL)
>> +		return -ENOMEM;
>> +
>> +	if (pdd->doorbell_mapping == NULL) {
>> +		unsigned long offset = (KFD_MMAP_DOORBELL_START + dev->id) << PAGE_SHIFT;
>> +		doorbell_t __user *doorbell_mapping;
>> +
>> +		doorbell_mapping = (doorbell_t __user *)vm_mmap(devkfd, 0, doorbell_process_allocation(), PROT_WRITE,
>> +								MAP_SHARED, offset);
> 
> Like said above have the userspace do that. Do not do it inside
> the kernel.
> 
Done in v3

>> +		if (IS_ERR(doorbell_mapping))
>> +			return PTR_ERR(doorbell_mapping);
>> +
>> +		pdd->doorbell_mapping = doorbell_mapping;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* get kernel iomem pointer for a doorbell */
>> +u32 __iomem *kfd_get_kernel_doorbell(struct kfd_dev *kfd, unsigned int *doorbell_off)
>> +{
>> +	u32 inx;
>> +
>> +	BUG_ON(!kfd || !doorbell_off);
>> +
>> +	mutex_lock(&doorbell_mutex);
>> +	inx = find_first_zero_bit(doorbell_available_index, MAX_PROCESS_QUEUES);
>> +	__set_bit(inx, doorbell_available_index);
>> +	mutex_unlock(&doorbell_mutex);
>> +
>> +	if (inx >= MAX_PROCESS_QUEUES)
>> +		return NULL;
>> +
>> +	/* caluculating the kernel doorbell offset using "faked" kernel pasid that allocated for kernel queues only */
>> +	*doorbell_off = KERNEL_DOORBELL_PASID * (doorbell_process_allocation()/sizeof(doorbell_t)) + inx;
>> +
>> +	pr_debug("kfd: get kernel queue doorbell\n"
>> +			 "     doorbell offset   == 0x%08d\n"
>> +			 "     kernel address    == 0x%08lX\n",
>> +			 *doorbell_off, (uintptr_t)(kfd->doorbell_kernel_ptr + inx));
>> +
>> +	return kfd->doorbell_kernel_ptr + inx;
>> +}
>> +
>> +void kfd_release_kernel_doorbell(struct kfd_dev *kfd, u32 __iomem *db_addr)
>> +{
>> +	unsigned int inx;
>> +
>> +	BUG_ON(!kfd || !db_addr);
>> +
>> +	inx = (unsigned int)(db_addr - kfd->doorbell_kernel_ptr);
>> +
>> +	mutex_lock(&doorbell_mutex);
>> +	__clear_bit(inx, doorbell_available_index);
>> +	mutex_unlock(&doorbell_mutex);
>> +}
>> +
>> +inline void write_kernel_doorbell(u32 __iomem *db, u32 value)
>> +{
>> +	if (db) {
>> +		writel(value, db);
>> +		pr_debug("writing %d to doorbell address 0x%p\n", value, db);
>> +	}
>> +}
>> +
>> +/*
>> + * Get the user-mode address of a doorbell.
>> + * Assumes that the process mutex is being held.
>> + */
>> +doorbell_t __user *kfd_get_doorbell(struct file *devkfd,
>> +					struct kfd_process *process,
>> +					struct kfd_dev *dev,
>> +					unsigned int doorbell_index)
>> +{
>> +	struct kfd_process_device *pdd;
>> +	int err;
>> +
>> +	BUG_ON(doorbell_index > MAX_DOORBELL_INDEX);
>> +
>> +	err = map_doorbells(devkfd, process, dev);
>> +	if (err)
>> +		return ERR_PTR(err);
>> +
>> +	pdd = kfd_get_process_device_data(dev, process);
>> +	BUG_ON(pdd == NULL); /* map_doorbells would have failed otherwise */
>> +
>> +	pr_debug("doorbell value on creation 0x%x\n", pdd->doorbell_mapping[doorbell_index]);
>> +
>> +	return &pdd->doorbell_mapping[doorbell_index];
>> +}
>> +
>> +/*
>> + * queue_ids are in the range [0,MAX_PROCESS_QUEUES) and are mapped 1:1
>> + * to doorbells with the process's doorbell page
>> + */
>> +unsigned int kfd_queue_id_to_doorbell(struct kfd_dev *kfd, struct kfd_process *process, unsigned int queue_id)
>> +{
>> +	/*
>> +	 * doorbell_id_offset accounts for doorbells taken by KGD.
>> +	 * pasid * doorbell_process_allocation/sizeof(doorbell_t) adjusts
>> +	 * to the process's doorbells
>> +	 */
>> +	return kfd->doorbell_id_offset + process->pasid * (doorbell_process_allocation()/sizeof(doorbell_t)) + queue_id;
>> +}
>> +
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>> index c51f981..dc08f51 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
>> @@ -65,14 +65,30 @@ void kgd2kfd_exit(void)
>>  {
>>  }
>>  
>> +extern int kfd_process_exit(struct notifier_block *nb,
>> +				unsigned long action, void *data);
>> +
>> +static struct notifier_block kfd_mmput_nb = {
>> +	.notifier_call		= kfd_process_exit,
>> +	.priority		= 3,
>> +};
>> +
>>  static int __init kfd_module_init(void)
>>  {
>>  	int err;
>>  
>> +	err = kfd_pasid_init();
>> +	if (err < 0)
>> +		goto err_pasid;
>> +
>>  	err = kfd_chardev_init();
>>  	if (err < 0)
>>  		goto err_ioctl;
>>  
>> +	err = mmput_register_notifier(&kfd_mmput_nb);
>> +	if (err)
>> +		goto err_mmu_notifier;
>> +
>>  	err = kfd_topology_init();
>>  	if (err < 0)
>>  		goto err_topology;
>> @@ -82,15 +98,21 @@ static int __init kfd_module_init(void)
>>  	return 0;
>>  
>>  err_topology:
>> +	mmput_unregister_notifier(&kfd_mmput_nb);
>> +err_mmu_notifier:
>>  	kfd_chardev_exit();
>>  err_ioctl:
>> +	kfd_pasid_exit();
>> +err_pasid:
>>  	return err;
>>  }
>>  
>>  static void __exit kfd_module_exit(void)
>>  {
>>  	kfd_topology_shutdown();
>> +	mmput_unregister_notifier(&kfd_mmput_nb);
>>  	kfd_chardev_exit();
>> +	kfd_pasid_exit();
>>  	dev_info(kfd_device, "Removed module\n");
>>  }
>>  
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c b/drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
>> new file mode 100644
>> index 0000000..0b594e4
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
>> @@ -0,0 +1,97 @@
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
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include "kfd_priv.h"
>> +
>> +#define INITIAL_PASID_LIMIT (1<<20)
>> +
>> +static unsigned long *pasid_bitmap;
>> +static pasid_t pasid_limit;
>> +static DEFINE_MUTEX(pasid_mutex);
>> +
>> +int kfd_pasid_init(void)
>> +{
>> +	pasid_limit = INITIAL_PASID_LIMIT;
>> +
>> +	pasid_bitmap = kzalloc(DIV_ROUND_UP(INITIAL_PASID_LIMIT, BITS_PER_BYTE), GFP_KERNEL);
>> +	if (!pasid_bitmap)
>> +		return -ENOMEM;
>> +
>> +	set_bit(0, pasid_bitmap); /* PASID 0 is reserved. */
>> +
>> +	return 0;
>> +}
>> +
>> +void kfd_pasid_exit(void)
>> +{
>> +	kfree(pasid_bitmap);
>> +}
>> +
>> +bool kfd_set_pasid_limit(pasid_t new_limit)
>> +{
>> +	if (new_limit < pasid_limit) {
>> +		bool ok;
>> +
>> +		mutex_lock(&pasid_mutex);
>> +
>> +		/* ensure that no pasids >= new_limit are in-use */
>> +		ok = (find_next_bit(pasid_bitmap, pasid_limit, new_limit) == pasid_limit);
>> +		if (ok)
>> +			pasid_limit = new_limit;
>> +
>> +		mutex_unlock(&pasid_mutex);
>> +
>> +		return ok;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +inline pasid_t kfd_get_pasid_limit(void)
>> +{
>> +	return pasid_limit;
>> +}
>> +
>> +pasid_t kfd_pasid_alloc(void)
>> +{
>> +	pasid_t found;
>> +
>> +	mutex_lock(&pasid_mutex);
>> +
>> +	found = find_first_zero_bit(pasid_bitmap, pasid_limit);
>> +	if (found == pasid_limit)
>> +		found = 0;
>> +	else
>> +		set_bit(found, pasid_bitmap);
>> +
>> +	mutex_unlock(&pasid_mutex);
>> +
>> +	return found;
>> +}
>> +
>> +void kfd_pasid_free(pasid_t pasid)
>> +{
>> +	BUG_ON(pasid == 0 || pasid >= pasid_limit);
>> +	clear_bit(pasid, pasid_bitmap);
>> +}
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> index b391e24..af5a5e4 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> @@ -32,14 +32,39 @@
>>  #include <linux/spinlock.h>
>>  #include "../radeon_kfd.h"
>>  
>> +/*
>> + * Per-process limit. Each process can only
>> + * create MAX_PROCESS_QUEUES across all devices
>> + */
>> +#define MAX_PROCESS_QUEUES 1024
>> +
>> +#define MAX_DOORBELL_INDEX MAX_PROCESS_QUEUES
>>  #define KFD_SYSFS_FILE_MODE 0444
>>  
>> +/*
>> + * We multiplex different sorts of mmap-able memory onto /dev/kfd.
>> + * We figure out what type of memory the caller wanted by comparing
>> + * the mmap page offset to known ranges.
>> + */
>> +#define KFD_MMAP_DOORBELL_START	(((1ULL << 32)*1) >> PAGE_SHIFT)
>> +#define KFD_MMAP_DOORBELL_END	(((1ULL << 32)*2) >> PAGE_SHIFT)
>> +
>>  /* GPU ID hash width in bits */
>>  #define KFD_GPU_ID_HASH_WIDTH 16
>>  
>>  /* Macro for allocating structures */
>>  #define kfd_alloc_struct(ptr_to_struct)	((typeof(ptr_to_struct)) kzalloc(sizeof(*ptr_to_struct), GFP_KERNEL))
>>  
>> +/*
>> + * Large enough to hold the maximum usable pasid + 1.
>> + * It must also be able to store the number of doorbells
>> + * reported by a KFD device.
>> + */
>> +typedef unsigned int pasid_t;
>> +
>> +/* Type that represents a HW doorbell slot. */
>> +typedef u32 doorbell_t;
>> +
>>  struct kfd_device_info {
>>  	const struct kfd_scheduler_class *scheduler_class;
>>  	unsigned int max_pasid_bits;
>> @@ -56,6 +81,17 @@ struct kfd_dev {
>>  
>>  	unsigned int id;		/* topology stub index */
>>  
>> +	phys_addr_t doorbell_base;	/* Start of actual doorbells used by
>> +					 * KFD. It is aligned for mapping
>> +					 * into user mode
>> +					 */
>> +	size_t doorbell_id_offset;	/* Doorbell offset (from KFD doorbell
>> +					 * to HW doorbell, GFX reserved some
>> +					 * at the start)
>> +					 */
>> +	size_t doorbell_process_limit;	/* Number of processes we have doorbell space for. */
>> +	u32 __iomem *doorbell_kernel_ptr; /* this is a pointer for a doorbells page used by kernel queue */
>> +
>>  	struct kgd2kfd_shared_resources shared_resources;
>>  };
>>  
>> @@ -68,15 +104,124 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd);
>>  
>>  extern const struct kfd2kgd_calls *kfd2kgd;
>>  
>> +/* Dummy struct just to make kfd_mem_obj* a unique pointer type. */
>> +struct kfd_mem_obj_s;
>> +typedef struct kfd_mem_obj_s *kfd_mem_obj;
> 
> IIRC the rule is no more typedef in kernel. Or maybe i just dreamt
> that rule.
> 
Removed all typedefs in v3

>> +
>> +enum kfd_mempool {
>> +	KFD_MEMPOOL_SYSTEM_CACHEABLE = 1,
>> +	KFD_MEMPOOL_SYSTEM_WRITECOMBINE = 2,
>> +	KFD_MEMPOOL_FRAMEBUFFER = 3,
>> +};
>> +
>> +
>> +int kfd_vidmem_alloc(struct kfd_dev *kfd, size_t size, size_t alignment,
>> +			enum kfd_mempool pool, kfd_mem_obj *mem_obj);
>> +void kfd_vidmem_free(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
>> +int kfd_vidmem_gpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj, uint64_t *vmid0_address);
>> +void kfd_vidmem_ungpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
>> +int kfd_vidmem_kmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj, void **ptr);
>> +void kfd_vidmem_unkmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
>> +int kfd_vidmem_alloc_map(struct kfd_dev *kfd, kfd_mem_obj *mem_obj, void **ptr,
>> +			uint64_t *vmid0_address, size_t size);
>> +void kfd_vidmem_free_unmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
>>  /* Character device interface */
>>  int kfd_chardev_init(void);
>>  void kfd_chardev_exit(void);
>>  struct device *kfd_chardev(void);
>>  
>> +
>> +/* Data that is per-process-per device. */
>> +struct kfd_process_device {
>> +	/*
>> +	 * List of all per-device data for a process.
>> +	 * Starts from kfd_process.per_device_data.
>> +	 */
>> +	struct list_head per_device_list;
>> +
>> +	/* The device that owns this data. */
>> +	struct kfd_dev *dev;
>> +
>> +	/* The user-mode address of the doorbell mapping for this device. */
>> +	doorbell_t __user *doorbell_mapping;
>> +
>> +	/* Is this process/pasid bound to this device? (amd_iommu_bind_pasid) */
>> +	bool bound;
> 
> Best to put the boolean at the end of the structure ...
> 
Done in v3

>> +
>> +	/*Apertures*/
>> +	uint64_t lds_base;
>> +	uint64_t lds_limit;
>> +	uint64_t gpuvm_base;
>> +	uint64_t gpuvm_limit;
>> +	uint64_t scratch_base;
>> +	uint64_t scratch_limit;
>> +};
>> +
>>  /* Process data */
>>  struct kfd_process {
>> +	struct list_head processes_list;
>> +
>> +	struct mm_struct *mm;
>> +
>> +	struct mutex mutex;
>> +
>> +	/*
>> +	 * In any process, the thread that started main() is the lead
>> +	 * thread and outlives the rest.
>> +	 * It is here because amd_iommu_bind_pasid wants a task_struct.
>> +	 */
>> +	struct task_struct *lead_thread;
>> +
>> +	pasid_t pasid;
>> +
>> +	/*
>> +	 * List of kfd_process_device structures,
>> +	 * one for each device the process is using.
>> +	 */
>> +	struct list_head per_device_data;
>> +
>> +	/* The process's queues. */
>> +	size_t queue_array_size;
>> +
>> +	/* Size is queue_array_size, up to MAX_PROCESS_QUEUES. */
>> +	struct kfd_queue **queues;
>> +
>> +	unsigned long allocated_queue_bitmap[DIV_ROUND_UP(MAX_PROCESS_QUEUES, BITS_PER_LONG)];
>> +
>> +	/*Is the user space process 32 bit?*/
>> +	bool is_32bit_user_mode;
>>  };
>>  
>> +struct kfd_process *kfd_create_process(const struct task_struct *);
>> +struct kfd_process *kfd_get_process(const struct task_struct *);
>> +
>> +struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
>> +							struct kfd_process *p);
>> +
>> +/* PASIDs */
>> +int kfd_pasid_init(void);
>> +void kfd_pasid_exit(void);
>> +bool kfd_set_pasid_limit(pasid_t new_limit);
>> +pasid_t kfd_get_pasid_limit(void);
>> +pasid_t kfd_pasid_alloc(void);
>> +void kfd_pasid_free(pasid_t pasid);
>> +
>> +/* Doorbells */
>> +void kfd_doorbell_init(struct kfd_dev *kfd);
>> +int kfd_doorbell_mmap(struct kfd_process *process, struct vm_area_struct *vma);
>> +doorbell_t __user *kfd_get_doorbell(struct file *devkfd,
>> +					struct kfd_process *process,
>> +					struct kfd_dev *dev,
>> +					unsigned int doorbell_index);
>> +u32 __iomem *kfd_get_kernel_doorbell(struct kfd_dev *kfd,
>> +					unsigned int *doorbell_off);
>> +void kfd_release_kernel_doorbell(struct kfd_dev *kfd, u32 __iomem *db_addr);
>> +u32 read_kernel_doorbell(u32 __iomem *db);
>> +void write_kernel_doorbell(u32 __iomem *db, u32 value);
>> +unsigned int kfd_queue_id_to_doorbell(struct kfd_dev *kfd,
>> +					struct kfd_process *process,
>> +					unsigned int queue_id);
>> +
>>  extern struct device *kfd_device;
>>  
>>  /* Topology */
>> @@ -95,4 +240,7 @@ void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry);
>>  void kgd2kfd_suspend(struct kfd_dev *dev);
>>  int kgd2kfd_resume(struct kfd_dev *dev);
>>  
>> +/* amdkfd Apertures */
>> +int kfd_init_apertures(struct kfd_process *process);
>> +
>>  #endif
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
>> new file mode 100644
>> index 0000000..5efbce0
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
>> @@ -0,0 +1,374 @@
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
>> +#include <linux/mutex.h>
>> +#include <linux/log2.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/notifier.h>
>> +struct mm_struct;
>> +
>> +#include "kfd_priv.h"
>> +
>> +/*
>> + * Initial size for the array of queues.
>> + * The allocated size is doubled each time
>> + * it is exceeded up to MAX_PROCESS_QUEUES.
>> + */
>> +#define INITIAL_QUEUE_ARRAY_SIZE 16
>> +
>> +/* List of struct kfd_process */
>> +static struct list_head kfd_processes_list = LIST_HEAD_INIT(kfd_processes_list);
>> +
>> +static DEFINE_MUTEX(kfd_processes_mutex);
>> +
>> +static struct kfd_process *create_process(const struct task_struct *thread);
>> +
>> +struct kfd_process *kfd_create_process(const struct task_struct *thread)
>> +{
>> +	struct kfd_process *process;
>> +
>> +	if (thread->mm == NULL)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	/* Only the pthreads threading model is supported. */
>> +	if (thread->group_leader->mm != thread->mm)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	/*
>> +	 * take kfd processes mutex before starting of process creation
>> +	 * so there won't be a case where two threads of the same process
>> +	 * create two kfd_process structures
>> +	 */
>> +	mutex_lock(&kfd_processes_mutex);
>> +
>> +	/* A prior open of /dev/kfd could have already created the process. */
>> +	process = thread->mm->kfd_process;
>> +	if (process)
>> +		pr_debug("kfd: process already found\n");
>> +
>> +	if (!process)
>> +		process = create_process(thread);
>> +
>> +	mutex_unlock(&kfd_processes_mutex);
>> +
>> +	return process;
>> +}
>> +
>> +struct kfd_process *kfd_get_process(const struct task_struct *thread)
>> +{
>> +	struct kfd_process *process;
>> +
>> +	if (thread->mm == NULL)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	/* Only the pthreads threading model is supported. */
>> +	if (thread->group_leader->mm != thread->mm)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	process = thread->mm->kfd_process;
>> +
>> +	return process;
>> +}
>> +
>> +static void free_process(struct kfd_process *p)
>> +{
>> +	struct kfd_process_device *pdd, *temp;
>> +
>> +	BUG_ON(p == NULL);
>> +
>> +	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
>> +		list_del(&pdd->per_device_list);
>> +		kfree(pdd);
>> +	}
>> +
>> +	kfd_pasid_free(p->pasid);
>> +
>> +	mutex_destroy(&p->mutex);
>> +
>> +	kfree(p->queues);
>> +
>> +	list_del(&p->processes_list);
>> +
>> +	kfree(p);
>> +}
>> +
>> +int kfd_process_exit(struct notifier_block *nb,
>> +			unsigned long action, void *data)
>> +{
>> +	struct mm_struct *mm = data;
>> +	struct kfd_process *p;
>> +
>> +	mutex_lock(&kfd_processes_mutex);
>> +
>> +	p = mm->kfd_process;
>> +	if (p) {
>> +		free_process(p);
>> +		mm->kfd_process = NULL;
>> +	}
>> +
>> +	mutex_unlock(&kfd_processes_mutex);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct kfd_process *create_process(const struct task_struct *thread)
>> +{
>> +	struct kfd_process *process;
>> +	int err = -ENOMEM;
>> +
>> +	process = kzalloc(sizeof(*process), GFP_KERNEL);
>> +
>> +	if (!process)
>> +		goto err_alloc_process;
>> +
>> +	process->queues = kmalloc_array(INITIAL_QUEUE_ARRAY_SIZE, sizeof(process->queues[0]), GFP_KERNEL);
>> +	if (!process->queues)
>> +		goto err_alloc_queues;
>> +
>> +	process->pasid = kfd_pasid_alloc();
>> +	if (process->pasid == 0)
>> +		goto err_alloc_pasid;
>> +
>> +	mutex_init(&process->mutex);
>> +
>> +	process->mm = thread->mm;
>> +	thread->mm->kfd_process = process;
>> +	list_add_tail(&process->processes_list, &kfd_processes_list);
>> +
>> +	process->lead_thread = thread->group_leader;
>> +
>> +	process->queue_array_size = INITIAL_QUEUE_ARRAY_SIZE;
>> +
>> +	INIT_LIST_HEAD(&process->per_device_data);
>> +
>> +	return process;
>> +
>> +err_alloc_pasid:
>> +	kfree(process->queues);
>> +err_alloc_queues:
>> +	kfree(process);
>> +err_alloc_process:
>> +	return ERR_PTR(err);
>> +}
>> +
>> +struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
>> +							struct kfd_process *p)
>> +{
>> +	struct kfd_process_device *pdd;
>> +
>> +	list_for_each_entry(pdd, &p->per_device_data, per_device_list)
>> +		if (pdd->dev == dev)
>> +			return pdd;
>> +
>> +	pdd = kzalloc(sizeof(*pdd), GFP_KERNEL);
>> +	if (pdd != NULL) {
>> +		pdd->dev = dev;
>> +		list_add(&pdd->per_device_list, &p->per_device_data);
>> +	}
>> +
>> +	return pdd;
>> +}
>> +
>> +/*
>> + * Direct the IOMMU to bind the process (specifically the pasid->mm) to the device.
>> + * Unbinding occurs when the process dies or the device is removed.
>> + *
>> + * Assumes that the process lock is held.
>> + */
>> +struct kfd_process_device *kfd_bind_process_to_device(struct kfd_dev *dev,
>> +							struct kfd_process *p)
>> +{
>> +	struct kfd_process_device *pdd = kfd_get_process_device_data(dev, p);
>> +
>> +	if (pdd == NULL)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	if (pdd->bound)
>> +		return pdd;
>> +
>> +	pdd->bound = true;
>> +
>> +	return pdd;
>> +}
>> +
>> +void kfd_unbind_process_from_device(struct kfd_dev *dev, pasid_t pasid)
>> +{
>> +	struct kfd_process *p;
>> +	struct kfd_process_device *pdd;
>> +
>> +	BUG_ON(dev == NULL);
>> +
>> +	mutex_lock(&kfd_processes_mutex);
>> +
>> +	list_for_each_entry(p, &kfd_processes_list, processes_list)
>> +		if (p->pasid == pasid)
>> +			break;
>> +
>> +	mutex_unlock(&kfd_processes_mutex);
>> +
>> +	BUG_ON(p->pasid != pasid);
>> +
>> +	pdd = kfd_get_process_device_data(dev, p);
>> +
>> +	BUG_ON(pdd == NULL);
>> +
>> +	mutex_lock(&p->mutex);
>> +
>> +	/*
>> +	 * Just mark pdd as unbound, because we still need it to call
>> +	 * amd_iommu_unbind_pasid() in when the process exits.
>> +	 * We don't call amd_iommu_unbind_pasid() here
>> +	 * because the IOMMU called us.
>> +	 */
>> +	pdd->bound = false;
>> +
>> +	mutex_unlock(&p->mutex);
>> +}
>> +
>> +/*
>> + * Ensure that the process's queue array is large enough to hold
>> + * the queue at queue_id.
>> + * Assumes that the process lock is held.
>> + */
>> +static bool ensure_queue_array_size(struct kfd_process *p, unsigned int queue_id)
>> +{
>> +	size_t desired_size;
>> +	struct kfd_queue **new_queues;
>> +
>> +	compiletime_assert(INITIAL_QUEUE_ARRAY_SIZE > 0, "INITIAL_QUEUE_ARRAY_SIZE must not be 0");
>> +	compiletime_assert(INITIAL_QUEUE_ARRAY_SIZE <= MAX_PROCESS_QUEUES,
>> +			   "INITIAL_QUEUE_ARRAY_SIZE must be less than MAX_PROCESS_QUEUES");
>> +	/* Ensure that doubling the current size won't ever overflow. */
>> +	compiletime_assert(MAX_PROCESS_QUEUES < SIZE_MAX / 2, "MAX_PROCESS_QUEUES must be less than SIZE_MAX/2");
>> +
>> +	/*
>> +	 * These & queue_id < MAX_PROCESS_QUEUES guarantee that
>> +	 * the desired_size calculation will end up <= MAX_PROCESS_QUEUES
>> +	 */
>> +	compiletime_assert(is_power_of_2(INITIAL_QUEUE_ARRAY_SIZE), "INITIAL_QUEUE_ARRAY_SIZE must be power of 2.");
>> +	compiletime_assert(MAX_PROCESS_QUEUES % INITIAL_QUEUE_ARRAY_SIZE == 0,
>> +			   "MAX_PROCESS_QUEUES must be multiple of INITIAL_QUEUE_ARRAY_SIZE.");
>> +	compiletime_assert(is_power_of_2(MAX_PROCESS_QUEUES / INITIAL_QUEUE_ARRAY_SIZE),
>> +			   "MAX_PROCESS_QUEUES must be a power-of-2 multiple of INITIAL_QUEUE_ARRAY_SIZE.");
>> +
>> +	if (queue_id < p->queue_array_size)
>> +		return true;
>> +
>> +	if (queue_id >= MAX_PROCESS_QUEUES)
>> +		return false;
>> +
>> +	desired_size = p->queue_array_size;
>> +	while (desired_size <= queue_id)
>> +		desired_size *= 2;
>> +
>> +	BUG_ON(desired_size < queue_id || desired_size > MAX_PROCESS_QUEUES);
>> +	BUG_ON(desired_size % INITIAL_QUEUE_ARRAY_SIZE != 0 || !is_power_of_2(desired_size / INITIAL_QUEUE_ARRAY_SIZE));
>> +
>> +	new_queues = kmalloc_array(desired_size, sizeof(p->queues[0]), GFP_KERNEL);
>> +	if (!new_queues)
>> +		return false;
>> +
>> +	memcpy(new_queues, p->queues, p->queue_array_size * sizeof(p->queues[0]));
>> +
>> +	kfree(p->queues);
>> +	p->queues = new_queues;
>> +	p->queue_array_size = desired_size;
>> +
>> +	return true;
>> +}
>> +
>> +/* Assumes that the process lock is held. */
>> +bool kfd_allocate_queue_id(struct kfd_process *p, unsigned int *queue_id)
>> +{
>> +	unsigned int qid = find_first_zero_bit(p->allocated_queue_bitmap, MAX_PROCESS_QUEUES);
>> +
>> +	if (qid >= MAX_PROCESS_QUEUES)
>> +		return false;
>> +
>> +	if (!ensure_queue_array_size(p, qid))
>> +		return false;
>> +
>> +	__set_bit(qid, p->allocated_queue_bitmap);
>> +
>> +	p->queues[qid] = NULL;
>> +	*queue_id = qid;
>> +
>> +	return true;
>> +}
>> +
>> +/*
>> + * Install a queue into a previously-allocated queue id.
>> + * Assumes that the process lock is held.
>> + */
>> +void kfd_install_queue(struct kfd_process *p, unsigned int queue_id, struct kfd_queue *queue)
>> +{
>> +	/* Have to call allocate_queue_id before install_queue. */
>> +	BUG_ON(queue_id >= p->queue_array_size);
>> +	BUG_ON(queue == NULL);
>> +
>> +	p->queues[queue_id] = queue;
>> +}
>> +
>> +/*
>> + * Remove a queue from the open queue list and deallocate the queue id.
>> + * This can be called whether or not a queue was installed.
>> + * Assumes that the process lock is held.
>> + */
>> +void kfd_remove_queue(struct kfd_process *p, unsigned int queue_id)
>> +{
>> +	BUG_ON(!test_bit(queue_id, p->allocated_queue_bitmap));
>> +	BUG_ON(queue_id >= p->queue_array_size);
>> +
>> +	__clear_bit(queue_id, p->allocated_queue_bitmap);
>> +}
>> +
>> +/* Assumes that the process lock is held. */
>> +struct kfd_queue *kfd_get_queue(struct kfd_process *p, unsigned int queue_id)
>> +{
>> +	/*
>> +	 * test_bit because the contents of unallocated
>> +	 * queue slots are undefined.
>> +	 * Otherwise ensure_queue_array_size would have to clear new entries and
>> +	 * remove_queue would have to NULL removed queues.
>> +	 */
>> +	return (queue_id < p->queue_array_size &&
>> +		test_bit(queue_id, p->allocated_queue_bitmap)) ?
>> +			p->queues[queue_id] : NULL;
>> +}
>> +
>> +struct kfd_process_device *kfd_get_first_process_device_data(struct kfd_process *p)
>> +{
>> +	return list_first_entry(&p->per_device_data, struct kfd_process_device, per_device_list);
>> +}
>> +
>> +struct kfd_process_device *kfd_get_next_process_device_data(struct kfd_process *p, struct kfd_process_device *pdd)
>> +{
>> +	if (list_is_last(&pdd->per_device_list, &p->per_device_data))
>> +		return NULL;
>> +	return list_next_entry(pdd, per_device_list);
>> +}
>> +
>> +bool kfd_has_process_device_data(struct kfd_process *p)
>> +{
>> +	return !(list_empty(&p->per_device_data));
>> +}
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_vidmem.c b/drivers/gpu/drm/radeon/amdkfd/kfd_vidmem.c
>> new file mode 100644
>> index 0000000..a2c4d30
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_vidmem.c
>> @@ -0,0 +1,96 @@
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
>> +#include "kfd_priv.h"
>> +
>> +int kfd_vidmem_alloc(struct kfd_dev *kfd, size_t size, size_t alignment,
>> +			enum kfd_mempool pool, kfd_mem_obj *mem_obj)
>> +{
>> +	return kfd2kgd->allocate_mem(kfd->kgd,
>> +					size,
>> +					alignment,
>> +					(enum kgd_memory_pool)pool,
>> +					(struct kgd_mem **)mem_obj);
>> +}
>> +
>> +void kfd_vidmem_free(struct kfd_dev *kfd, kfd_mem_obj mem_obj)
>> +{
>> +	kfd2kgd->free_mem(kfd->kgd, (struct kgd_mem *)mem_obj);
>> +}
>> +
>> +int kfd_vidmem_gpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj,
>> +			uint64_t *vmid0_address)
>> +{
>> +	return kfd2kgd->gpumap_mem(kfd->kgd,
>> +					(struct kgd_mem *)mem_obj,
>> +					vmid0_address);
> 
> As discussed previously this will not fly, pinning gpu memory is a big NACK.
> 
>> +}
>> +
>> +void kfd_vidmem_ungpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj)
>> +{
>> +	kfd2kgd->ungpumap_mem(kfd->kgd, (struct kgd_mem *)mem_obj);
>> +}
>> +
>> +int kfd_vidmem_kmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj, void **ptr)
>> +{
>> +	return kfd2kgd->kmap_mem(kfd->kgd, (struct kgd_mem *)mem_obj, ptr);
>> +}
>> +
>> +void kfd_vidmem_unkmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj)
>> +{
>> +	kfd2kgd->unkmap_mem(kfd->kgd, (struct kgd_mem *)mem_obj);
>> +}
>> +
>> +int kfd_vidmem_alloc_map(struct kfd_dev *kfd, kfd_mem_obj *mem_obj,
>> +			void **ptr, uint64_t *vmid0_address, size_t size)
>> +{
>> +	int retval;
>> +
>> +	retval = kfd_vidmem_alloc(kfd, size, PAGE_SIZE,
>> +				KFD_MEMPOOL_SYSTEM_WRITECOMBINE, mem_obj);
>> +	if (retval != 0)
>> +		goto fail_vidmem_alloc;
>> +
>> +	retval = kfd_vidmem_kmap(kfd, *mem_obj, ptr);
>> +	if (retval != 0)
>> +		goto fail_vidmem_kmap;
>> +
>> +	retval = kfd_vidmem_gpumap(kfd, *mem_obj, vmid0_address);
>> +	if (retval != 0)
>> +		goto fail_vidmem_gpumap;
>> +
>> +	return 0;
>> +
>> +fail_vidmem_gpumap:
>> +	kfd_vidmem_unkmap(kfd, *mem_obj);
>> +fail_vidmem_kmap:
>> +	kfd_vidmem_free(kfd, *mem_obj);
>> +fail_vidmem_alloc:
>> +	return retval;
>> +}
>> +
>> +void kfd_vidmem_free_unmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj)
>> +{
>> +	kfd_vidmem_ungpumap(kfd, mem_obj);
>> +	kfd_vidmem_unkmap(kfd, mem_obj);
>> +	kfd_vidmem_free(kfd, mem_obj);
>> +}
>> -- 
>> 1.9.1
>>
