Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaG0LJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 07:09:42 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:56479
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751619AbaG0LJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 07:09:40 -0400
X-WSS-ID: 0N9DAZZ-07-VDD-02
X-M-MSG: 
Message-ID: <53D4DDDC.4090705@amd.com>
Date: Sun, 27 Jul 2014 14:09:16 +0300
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
Subject: Re: [PATCH v2 13/25] amdkfd: Add queue module
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-14-git-send-email-oded.gabbay@amd.com>
 <20140720230604.GI3068@gmail.com>
In-Reply-To: <20140720230604.GI3068@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(189002)(199002)(479174003)(31966008)(81542001)(76482001)(36756003)(23746002)(46102001)(81342001)(85306003)(95666004)(65956001)(80022001)(65806001)(20776003)(64126003)(47776003)(64706001)(79102001)(83322001)(19580405001)(80316001)(19580395003)(21056001)(44976005)(77982001)(105586002)(106466001)(68736004)(87936001)(4396001)(97736001)(74662001)(74502001)(102836001)(33656002)(92726001)(101416001)(92566001)(85852003)(84676001)(83072002)(83506001)(76176999)(107046002)(87266999)(54356999)(50986999)(110136001)(65816999)(99396002)(86362001)(50466002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB043;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0285201563
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/14 02:06, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:29:20PM +0300, Oded Gabbay wrote:
>> From: Ben Goz <ben.goz@amd.com>
>>
>> The queue module enables allocating and initializing queues uniformly.
>>
>> Signed-off-by: Ben Goz <ben.goz@amd.com>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>   drivers/gpu/drm/radeon/amdkfd/Makefile    |   2 +-
>>   drivers/gpu/drm/radeon/amdkfd/kfd_priv.h  |  48 +++++++++++++
>>   drivers/gpu/drm/radeon/amdkfd/kfd_queue.c | 109 ++++++++++++++++++++++++++++++
>>   3 files changed, 158 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
>> index daf75a8..dbff147 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/Makefile
>> +++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
>> @@ -6,6 +6,6 @@ ccflags-y := -Iinclude/drm
>>
>>   amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
>>   		kfd_pasid.o kfd_doorbell.o kfd_vidmem.o kfd_aperture.o \
>> -		kfd_process.o
>> +		kfd_process.o kfd_queue.o
>>
>>   obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> index 604c317..94ff1c3 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> @@ -65,6 +65,9 @@ typedef unsigned int pasid_t;
>>   /* Type that represents a HW doorbell slot. */
>>   typedef u32 doorbell_t;
>>
>> +/* Type that represents queue pointer */
>> +typedef u32 qptr_t;
>> +
>>   struct kfd_device_info {
>>   	const struct kfd_scheduler_class *scheduler_class;
>>   	unsigned int max_pasid_bits;
>> @@ -125,12 +128,57 @@ void kfd_vidmem_unkmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
>>   int kfd_vidmem_alloc_map(struct kfd_dev *kfd, kfd_mem_obj *mem_obj, void **ptr,
>>   			uint64_t *vmid0_address, size_t size);
>>   void kfd_vidmem_free_unmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
>> +
>>   /* Character device interface */
>>   int kfd_chardev_init(void);
>>   void kfd_chardev_exit(void);
>>   struct device *kfd_chardev(void);
>>
>>
>> +enum kfd_queue_type  {
>> +	KFD_QUEUE_TYPE_COMPUTE,
>> +	KFD_QUEUE_TYPE_SDMA,
>> +	KFD_QUEUE_TYPE_HIQ,
>> +	KFD_QUEUE_TYPE_DIQ
>> +};
>> +
>> +struct queue_properties {
>> +	enum kfd_queue_type type;
>> +	unsigned int queue_id;
>> +	uint64_t queue_address;
>> +	uint64_t  queue_size;
>> +	uint32_t priority;
>> +	uint32_t queue_percent;
>> +	qptr_t *read_ptr;
>> +	qptr_t *write_ptr;
>> +	qptr_t *doorbell_ptr;
>> +	qptr_t doorbell_off;
>> +	bool is_interop;
>> +	bool is_active;
>> +	/* Not relevant for user mode queues in cp scheduling */
>> +	unsigned int vmid;
>> +};
>> +
>> +struct queue {
>> +	struct list_head list;
>> +	void *mqd;
>> +	/* kfd_mem_obj contains the mqd */
>> +	kfd_mem_obj mqd_mem_obj;
>> +	uint64_t gart_mqd_addr; /* needed for cp scheduling */
>> +	struct queue_properties properties;
>> +
>> +	/*
>> +	 * Used by the queue device manager to track the hqd slot per queue
>> +	 * when using no cp scheduling
>> +	 */
>> +	uint32_t mec;
>> +	uint32_t pipe;
>> +	uint32_t queue;
>> +
>> +	struct kfd_process	*process;
>> +	struct kfd_dev		*device;
>> +};
>> +
>>   /* Data that is per-process-per device. */
>>   struct kfd_process_device {
>>   	/*
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_queue.c b/drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
>> new file mode 100644
>> index 0000000..646b6d1
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_queue.c
>> @@ -0,0 +1,109 @@
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
>> +#include <linux/slab.h>
>> +#include "kfd_priv.h"
>> +
>> +void print_queue_properties(struct queue_properties *q)
>> +{
>> +	if (!q)
>> +		return;
>> +
>> +	pr_debug("Printing queue properties\n"
>> +			"Queue Type: %u\n"
>> +			"Queue Size: %llu\n"
>> +			"Queue percent: %u\n"
>> +			"Queue Address: 0x%llX\n"
>> +			"Queue Id: %u\n"
>> +			"Queue Process Vmid: %u\n"
>> +			"Queue Read Pointer: 0x%p\n"
>> +			"Queue Write Pointer: 0x%p\n"
>> +			"Queue Doorbell Pointer: 0x%p\n"
>> +			"Queue Doorbell Offset: %u\n",  q->type,
>> +							q->queue_size,
>> +							q->queue_percent,
>> +							q->queue_address,
>> +							q->queue_id,
>> +							q->vmid,
>> +							q->read_ptr,
>> +							q->write_ptr,
>> +							q->doorbell_ptr,
>> +							q->doorbell_off);
>
> One pr_debug call per line.
Done in v3
>
>> +}
>> +
>> +void print_queue(struct queue *q)
>> +{
>> +	if (!q)
>> +		return;
>> +	pr_debug("Printing queue\n"
>> +			"Queue Type: %u\n"
>> +			"Queue Size: %llu\n"
>> +			"Queue percent: %u\n"
>> +			"Queue Address: 0x%llX\n"
>> +			"Queue Id: %u\n"
>> +			"Queue Process Vmid: %u\n"
>> +			"Queue Read Pointer: 0x%p\n"
>> +			"Queue Write Pointer: 0x%p\n"
>> +			"Queue Doorbell Pointer: 0x%p\n"
>> +			"Queue Doorbell Offset: %u\n"
>> +			"Queue MQD Address: 0x%p\n"
>> +			"Queue MQD Gart: 0x%llX\n"
>> +			"Queue Process Address: 0x%p\n"
>> +			"Queue Device Address: 0x%p\n",
>> +					q->properties.type,
>> +					q->properties.queue_size,
>> +					q->properties.queue_percent,
>> +					q->properties.queue_address,
>> +					q->properties.queue_id,
>> +					q->properties.vmid,
>> +					q->properties.read_ptr,
>> +					q->properties.write_ptr,
>> +					q->properties.doorbell_ptr,
>> +					q->properties.doorbell_off,
>> +					q->mqd,
>> +					q->gart_mqd_addr,
>> +					q->process,
>> +					q->device);
>
> Ditto
Done in v3
>
>> +}
>> +
>> +int init_queue(struct queue **q, struct queue_properties properties)
>> +{
>> +	struct queue *tmp;
>> +
>> +	BUG_ON(!q);
>> +
>> +	tmp = kzalloc(sizeof(struct queue), GFP_KERNEL);
>> +	if (!tmp)
>> +		return -ENOMEM;
>> +
>> +	memset(&tmp->properties, 0, sizeof(struct queue_properties));
>
> memset uselss because of the memcpy below.
Removed in v3.
	Oded
>
>> +	memcpy(&tmp->properties, &properties, sizeof(struct queue_properties));
>> +
>> +	*q = tmp;
>> +	return 0;
>> +}
>> +
>> +void uninit_queue(struct queue *q)
>> +{
>> +	kfree(q);
>> +}
>> --
>> 1.9.1
>>

