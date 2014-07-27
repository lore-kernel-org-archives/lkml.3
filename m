Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaG0MkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 08:40:25 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:40372
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751290AbaG0MkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 08:40:23 -0400
X-WSS-ID: 0N9DF74-07-XLR-02
X-M-MSG: 
Message-ID: <53D4F32C.1040306@amd.com>
Date: Sun, 27 Jul 2014 14:40:12 +0200
From: =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Oded Gabbay <oded.gabbay@amd.com>, Jerome Glisse <j.glisse@gmail.com>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?windows-1252?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v2 15/25] amdkfd: Add kernel queue module
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-16-git-send-email-oded.gabbay@amd.com>
 <20140721024208.GL3068@gmail.com> <53D4DCFE.20800@amd.com>
In-Reply-To: <53D4DCFE.20800@amd.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.26]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(24454002)(479174003)(74502001)(97736001)(74662001)(36756003)(68736004)(77982001)(4396001)(83506001)(93886003)(31966008)(76482001)(79102001)(84676001)(23746002)(46102001)(21056001)(102836001)(101416001)(50466002)(86362001)(87936001)(105586002)(107046002)(33656002)(95666004)(85306003)(99396002)(92726001)(92566001)(65816999)(76176999)(87266999)(54356999)(83072002)(85852003)(50986999)(65956001)(65806001)(44976005)(80022001)(81542001)(80316001)(81342001)(83322001)(47776003)(106466001)(20776003)(64706001)(64126003)(19580395003)(19580405001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB044;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0285201563
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.07.2014 um 13:05 schrieb Oded Gabbay:
> On 21/07/14 05:42, Jerome Glisse wrote:
>> On Thu, Jul 17, 2014 at 04:29:22PM +0300, Oded Gabbay wrote:
>>> From: Ben Goz <ben.goz@amd.com>
>>>
>>> The kernel queue module enables the amdkfd to establish kernel 
>>> queues, not exposed to user space.
>>>
>>> The kernel queues are used for HIQ (HSA Interface Queue) and DIQ 
>>> (Debug Interface Queue) operations
>>>
>>> Signed-off-by: Ben Goz <ben.goz@amd.com>
>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>> ---
>>>   drivers/gpu/drm/radeon/amdkfd/Makefile             |   3 +-
>>>   .../drm/radeon/amdkfd/kfd_device_queue_manager.h   | 101 +++
>>>   drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c   | 305 +++++++++
>>>   drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h   |  66 ++
>>>   drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h    | 682 
>>> +++++++++++++++++++++
>>>   drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h    | 107 ++++
>>>   drivers/gpu/drm/radeon/amdkfd/kfd_priv.h           |  32 +
>>>   7 files changed, 1295 insertions(+), 1 deletion(-)
>>>   create mode 100644 
>>> drivers/gpu/drm/radeon/amdkfd/kfd_device_queue_manager.h
>>>   create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
>>>   create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
>>>   create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
>>>   create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
>>>
>>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c 
>>> b/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
>>> new file mode 100644
>>> index 0000000..b212524
>>> --- /dev/null
>>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.c
>>> +
>>> +static int sync_with_hw(struct kernel_queue *kq, unsigned long 
>>> timeout_ms)
>>> +{
>>> +    unsigned long org_timeout_ms;
>>> +
>>> +    BUG_ON(!kq);
>>> +
>>> +    org_timeout_ms = timeout_ms;
>>> +    timeout_ms += jiffies * 1000 / HZ;
>>> +    while (*kq->wptr_kernel != *kq->rptr_kernel) {
>>
>> I am not a fan of this kind of busy wait even with the cpu_relax 
>> below. Won't
>> there be some interrupt you can wait on (signaled through a wait 
>> queue perhaps) ?
>>
> So there is an interrupt but we don't use it for two reasons:
> 1. According to our thunk spec (thunk is the userspace bits of 
> amdkfd), all ioctls calls to amdkfd must be synchronous, meaning that 
> when the ioctl returns to thunk, the operation has completed. The 
> sync_with_hw function is called during the create/destroy/update queue 
> ioctls and we must wait to its completion before returning from the 
> ioctl. Therefore, there is no point in using interrupt here as we will 
> also need to wait for the interrupt before returning. It is especially 
> important in the destroy path, as the runtime library above the thunk 
> release the memory of the queue once it returns from the thunk's 
> destroy function.
>
> 2. Simpler code. The operations of adding/destroying queue require 
> allocations and releases of various memory objects (runlists, indirect 
> buffers). Adding an interrupt context in the middle of this would make 
> the code a lot more complex than it should be, IMO.

How about using a wait_queue? That would allow the IOCTL to be 
synchronous, is rather simple to implement and still don't busy wait for 
any hardware state to be reached.

Regards,
Christian.

>
>>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h 
>>> b/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
>>> new file mode 100644
>>> index 0000000..abfb9c8
>>> --- /dev/null
>>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_kernel_queue.h
>>> @@ -0,0 +1,66 @@
>>> +/*
>>> + * Copyright 2014 Advanced Micro Devices, Inc.
>>> + *
>>> + * Permission is hereby granted, free of charge, to any person 
>>> obtaining a
>>> + * copy of this software and associated documentation files (the 
>>> "Software"),
>>> + * to deal in the Software without restriction, including without 
>>> limitation
>>> + * the rights to use, copy, modify, merge, publish, distribute, 
>>> sublicense,
>>> + * and/or sell copies of the Software, and to permit persons to 
>>> whom the
>>> + * Software is furnished to do so, subject to the following 
>>> conditions:
>>> + *
>>> + * The above copyright notice and this permission notice shall be 
>>> included in
>>> + * all copies or substantial portions of the Software.
>>> + *
>>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
>>> EXPRESS OR
>>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
>>> MERCHANTABILITY,
>>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO 
>>> EVENT SHALL
>>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, 
>>> DAMAGES OR
>>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
>>> OTHERWISE,
>>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE 
>>> USE OR
>>> + * OTHER DEALINGS IN THE SOFTWARE.
>>> + *
>>> + */
>>> +
>>> +#ifndef KFD_KERNEL_QUEUE_H_
>>> +#define KFD_KERNEL_QUEUE_H_
>>> +
>>> +#include <linux/list.h>
>>> +#include <linux/types.h>
>>> +#include "kfd_priv.h"
>>> +
>>> +struct kernel_queue {
>>> +    /* interface */
>>> +    bool    (*initialize)(struct kernel_queue *kq, struct kfd_dev 
>>> *dev,
>>> +            enum kfd_queue_type type, unsigned int queue_size);
>>> +    void    (*uninitialize)(struct kernel_queue *kq);
>>> +    int    (*acquire_packet_buffer)(struct kernel_queue *kq,
>>> +            size_t packet_size_in_dwords, unsigned int **buffer_ptr);
>>> +    void    (*submit_packet)(struct kernel_queue *kq);
>>> +    int    (*sync_with_hw)(struct kernel_queue *kq, unsigned long 
>>> timeout_ms);
>>> +    void    (*rollback_packet)(struct kernel_queue *kq);
>>> +
>>> +    /* data */
>>> +    struct kfd_dev        *dev;
>>> +    struct mqd_manager    *mqd;
>>> +    struct queue        *queue;
>>> +    qptr_t            pending_wptr;
>>> +    unsigned int        nop_packet;
>>> +
>>> +    kfd_mem_obj        rptr_mem;
>>> +    qptr_t            *rptr_kernel;
>>> +    uint64_t        rptr_gpu_addr;
>>> +    kfd_mem_obj        wptr_mem;
>>> +    qptr_t            *wptr_kernel;
>>> +    uint64_t        wptr_gpu_addr;
>>> +    kfd_mem_obj        pq;
>>> +    uint64_t        pq_gpu_addr;
>>> +    qptr_t            *pq_kernel_addr;
>>> +
>>> +    kfd_mem_obj        fence_mem_obj;
>>> +    uint64_t        fence_gpu_addr;
>>> +    void            *fence_kernel_address;
>>> +
>>> +    struct list_head    list;
>>> +};
>>> +
>>> +#endif /* KFD_KERNEL_QUEUE_H_ */
>>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h 
>>> b/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
>>> new file mode 100644
>>> index 0000000..95e46f8
>>> --- /dev/null
>>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_headers.h
>>> @@ -0,0 +1,682 @@
>>> +/*
>>> + * Copyright 2014 Advanced Micro Devices, Inc.
>>> + *
>>> + * Permission is hereby granted, free of charge, to any person 
>>> obtaining a
>>> + * copy of this software and associated documentation files (the 
>>> "Software"),
>>> + * to deal in the Software without restriction, including without 
>>> limitation
>>> + * the rights to use, copy, modify, merge, publish, distribute, 
>>> sublicense,
>>> + * and/or sell copies of the Software, and to permit persons to 
>>> whom the
>>> + * Software is furnished to do so, subject to the following 
>>> conditions:
>>> + *
>>> + * The above copyright notice and this permission notice shall be 
>>> included in
>>> + * all copies or substantial portions of the Software.
>>> + *
>>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
>>> EXPRESS OR
>>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
>>> MERCHANTABILITY,
>>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO 
>>> EVENT SHALL
>>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, 
>>> DAMAGES OR
>>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
>>> OTHERWISE,
>>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE 
>>> USE OR
>>> + * OTHER DEALINGS IN THE SOFTWARE.
>>> + *
>>> + */
>>> +
>>> +#ifndef KFD_PM4_HEADERS_H_
>>> +#define KFD_PM4_HEADERS_H_
>>> +
>>> +#ifndef PM4_HEADER_DEFINED
>>> +#define PM4_HEADER_DEFINED
>>> +
>>> +union PM4_TYPE_3_HEADER {
>>> +    struct {
>>> +        unsigned int predicate:1;    /* < 0 for diq packets */
>>> +        unsigned int shader_type:1;    /* < 0 for diq packets */
>>> +        unsigned int reserved1:6;    /* < reserved */
>>> +        unsigned int opcode:8;        /* < IT opcode */
>>> +        unsigned int count:14;        /* < number of DWORDs - 1 in 
>>> the information body. */
>>> +        unsigned int type:2;        /* < packet identifier. It 
>>> should be 3 for type 3 packets */
>>> +    };
>>> +    unsigned int u32all;
>>> +};
>>
>> Do not build packet that way this will be broken on PPC you might
>> not care but we try to be little endian safe. Refer to radeon on
>> how to build packet. So the whole union stuff below is broken.
>>
> Agreed, but I would like to postpone this fix if possible to later 
> stage (rc stage).
>>> +#endif
>>> +
>
>>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h 
>>> b/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
>>> new file mode 100644
>>> index 0000000..b72fa3b
>>> --- /dev/null
>>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_pm4_opcodes.h
>>> @@ -0,0 +1,107 @@
>>> +/*
>>> + * Copyright 2014 Advanced Micro Devices, Inc.
>>> + *
>>> + * Permission is hereby granted, free of charge, to any person 
>>> obtaining a
>>> + * copy of this software and associated documentation files (the 
>>> "Software"),
>>> + * to deal in the Software without restriction, including without 
>>> limitation
>>> + * the rights to use, copy, modify, merge, publish, distribute, 
>>> sublicense,
>>> + * and/or sell copies of the Software, and to permit persons to 
>>> whom the
>>> + * Software is furnished to do so, subject to the following 
>>> conditions:
>>> + *
>>> + * The above copyright notice and this permission notice shall be 
>>> included in
>>> + * all copies or substantial portions of the Software.
>>> + *
>>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
>>> EXPRESS OR
>>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
>>> MERCHANTABILITY,
>>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO 
>>> EVENT SHALL
>>> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, 
>>> DAMAGES OR
>>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
>>> OTHERWISE,
>>> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE 
>>> USE OR
>>> + * OTHER DEALINGS IN THE SOFTWARE.
>>> + *
>>> + */
>>> +
>>> +
>>> +#ifndef KFD_PM4_OPCODES_H
>>> +#define KFD_PM4_OPCODES_H
>>> +
>>> +enum it_opcode_type {
>>> +    IT_NOP                               = 0x10,
>>> +    IT_SET_BASE                          = 0x11,
>>> +    IT_CLEAR_STATE                       = 0x12,
>>> +    IT_INDEX_BUFFER_SIZE                 = 0x13,
>>> +    IT_DISPATCH_DIRECT                   = 0x15,
>>> +    IT_DISPATCH_INDIRECT                 = 0x16,
>>> +    IT_ATOMIC_GDS                        = 0x1D,
>>> +    IT_OCCLUSION_QUERY                   = 0x1F,
>>> +    IT_SET_PREDICATION                   = 0x20,
>>> +    IT_REG_RMW                           = 0x21,
>>> +    IT_COND_EXEC                         = 0x22,
>>> +    IT_PRED_EXEC                         = 0x23,
>>> +    IT_DRAW_INDIRECT                     = 0x24,
>>> +    IT_DRAW_INDEX_INDIRECT               = 0x25,
>>> +    IT_INDEX_BASE                        = 0x26,
>>> +    IT_DRAW_INDEX_2                      = 0x27,
>>> +    IT_CONTEXT_CONTROL                   = 0x28,
>>> +    IT_INDEX_TYPE                        = 0x2A,
>>> +    IT_DRAW_INDIRECT_MULTI               = 0x2C,
>>> +    IT_DRAW_INDEX_AUTO                   = 0x2D,
>>> +    IT_NUM_INSTANCES                     = 0x2F,
>>> +    IT_DRAW_INDEX_MULTI_AUTO             = 0x30,
>>> +    IT_INDIRECT_BUFFER_CNST              = 0x33,
>>> +    IT_STRMOUT_BUFFER_UPDATE             = 0x34,
>>> +    IT_DRAW_INDEX_OFFSET_2               = 0x35,
>>> +    IT_DRAW_PREAMBLE                     = 0x36,
>>> +    IT_WRITE_DATA                        = 0x37,
>>> +    IT_DRAW_INDEX_INDIRECT_MULTI         = 0x38,
>>> +    IT_MEM_SEMAPHORE                     = 0x39,
>>> +    IT_COPY_DW                           = 0x3B,
>>> +    IT_WAIT_REG_MEM                      = 0x3C,
>>> +    IT_INDIRECT_BUFFER                   = 0x3F,
>>> +    IT_COPY_DATA                         = 0x40,
>>> +    IT_PFP_SYNC_ME                       = 0x42,
>>> +    IT_SURFACE_SYNC                      = 0x43,
>>> +    IT_COND_WRITE                        = 0x45,
>>> +    IT_EVENT_WRITE                       = 0x46,
>>> +    IT_EVENT_WRITE_EOP                   = 0x47,
>>> +    IT_EVENT_WRITE_EOS                   = 0x48,
>>> +    IT_RELEASE_MEM                       = 0x49,
>>> +    IT_PREAMBLE_CNTL                     = 0x4A,
>>> +    IT_DMA_DATA                          = 0x50,
>>> +    IT_ACQUIRE_MEM                       = 0x58,
>>> +    IT_REWIND                            = 0x59,
>>> +    IT_LOAD_UCONFIG_REG                  = 0x5E,
>>> +    IT_LOAD_SH_REG                       = 0x5F,
>>> +    IT_LOAD_CONFIG_REG                   = 0x60,
>>> +    IT_LOAD_CONTEXT_REG                  = 0x61,
>>> +    IT_SET_CONFIG_REG                    = 0x68,
>>> +    IT_SET_CONTEXT_REG                   = 0x69,
>>> +    IT_SET_CONTEXT_REG_INDIRECT          = 0x73,
>>> +    IT_SET_SH_REG                        = 0x76,
>>> +    IT_SET_SH_REG_OFFSET                 = 0x77,
>>> +    IT_SET_QUEUE_REG                     = 0x78,
>>> +    IT_SET_UCONFIG_REG                   = 0x79,
>>> +    IT_SCRATCH_RAM_WRITE                 = 0x7D,
>>> +    IT_SCRATCH_RAM_READ                  = 0x7E,
>>> +    IT_LOAD_CONST_RAM                    = 0x80,
>>> +    IT_WRITE_CONST_RAM                   = 0x81,
>>> +    IT_DUMP_CONST_RAM                    = 0x83,
>>> +    IT_INCREMENT_CE_COUNTER              = 0x84,
>>> +    IT_INCREMENT_DE_COUNTER              = 0x85,
>>> +    IT_WAIT_ON_CE_COUNTER                = 0x86,
>>> +    IT_WAIT_ON_DE_COUNTER_DIFF           = 0x88,
>>> +    IT_SWITCH_BUFFER                     = 0x8B,
>>> +    IT_SET_RESOURCES                     = 0xA0,
>>> +    IT_MAP_PROCESS                       = 0xA1,
>>> +    IT_MAP_QUEUES                        = 0xA2,
>>> +    IT_UNMAP_QUEUES                      = 0xA3,
>>> +    IT_QUERY_STATUS                      = 0xA4,
>>> +    IT_RUN_LIST                          = 0xA5,
>>> +};
>>> +
>>> +#define PM4_TYPE_0 0
>>> +#define PM4_TYPE_2 2
>>> +#define PM4_TYPE_3 3
>>
>> Reusing existing radeon define sounds like a good idea here.
> Agreed, but I would like to postpone this fix if possible to later 
> stage (rc stage).
>
>>
>>> +
>>> +#endif /* KFD_PM4_OPCODES_H */
>>> +
>>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h 
>>> b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>>> index 76494757..25f23c5 100644
>>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>>> @@ -49,6 +49,15 @@
>>>   #define KFD_MMAP_DOORBELL_START    (((1ULL << 32)*1) >> PAGE_SHIFT)
>>>   #define KFD_MMAP_DOORBELL_END    (((1ULL << 32)*2) >> PAGE_SHIFT)
>>
>> Both of this define do not seems to be use, which is somewhat of a 
>> relief when i
>> look at them.
>>
> Actually they are in use, in kfd_mmap(), kfd_doorbell_mmap() and 
> map_doorbells()
>
>     Oded
>

