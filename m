Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaHBUBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 16:01:07 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:12426
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754739AbaHBUBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 16:01:05 -0400
X-WSS-ID: 0N9P3LK-08-LK0-02
X-M-MSG: 
Message-ID: <53DD4372.3040108@amd.com>
Date: Sat, 2 Aug 2014 23:00:50 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-api@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>
Subject: Re: [PATCH v2 08/25] amdkfd: Add IOCTL set definitions of amdkfd
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-9-git-send-email-oded.gabbay@amd.com>
 <20140720165432.GB3068@gmail.com>
In-Reply-To: <20140720165432.GB3068@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.144]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(479174003)(51234002)(51704005)(24454002)(189002)(199002)(83506001)(83072002)(77982001)(92726001)(92566001)(2201001)(81542001)(23676002)(33656002)(84676001)(85852003)(101416001)(79102001)(68736004)(80316001)(83322001)(85306004)(4396001)(105586002)(36756003)(102836001)(87936001)(106466001)(107046002)(20776003)(76176999)(99396002)(64706001)(87266999)(81342001)(97736001)(50466002)(65816999)(54356999)(74502001)(65956001)(21056001)(50986999)(80022001)(86362001)(19580405001)(44976005)(76482001)(65806001)(46102001)(95666004)(47776003)(31966008)(19580395003)(74662001)(129583001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB037;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029174C036
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20/07/14 19:54, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:29:15PM +0300, Oded Gabbay wrote:
>> - KFD_IOC_GET_VERSION:
>> 	Retrieves the interface version of amdkfd
>>
>> - KFD_IOC_CREATE_QUEUE:
>> 	Creates a usermode queue that runs on a specific GPU device
>>
>> - KFD_IOC_DESTROY_QUEUE:
>> 	Destroys an existing usermode queue
>>
>> - KFD_IOC_SET_MEMORY_POLICY:
>> 	Sets the memory policy of the default and alternate aperture of the calling process
>>
>> - KFD_IOC_GET_CLOCK_COUNTERS:
>> 	Retrieves counters (timestamps) of CPU and GPU
>>
>> - KFD_IOC_GET_PROCESS_APERTURES:
>> 	Retrieves information about process apertures that were initialized
>> during the open() call of the amdkfd device
>>
>> - KFD_IOC_UPDATE_QUEUE:
>> 	Updates configuration of an existing usermode queue
>>
>> - KFD_IOC_PMC_ACQUIRE_ACCESS:
>> 	Acquires exclusive access (from other HSA processes) to the performance
>> counters of the GPU
>>
>> - KFD_IOC_PMC_RELEASE_ACCESS:
>> 	Releases exclusive access of the GPU's performance counters
> 
> Exclusive userspace access is recipie for failure. This must go and you must
> come up with better model. Which in my mind involve an ioctl for each command
> buffer submission.
> 
Removed these 2 ioctls in v3
>>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>  include/uapi/linux/kfd_ioctl.h | 133 +++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 133 insertions(+)
>>  create mode 100644 include/uapi/linux/kfd_ioctl.h
>>
>> diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
>> new file mode 100644
>> index 0000000..3cedd1a
>> --- /dev/null
>> +++ b/include/uapi/linux/kfd_ioctl.h
>> @@ -0,0 +1,133 @@
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
>> +#ifndef KFD_IOCTL_H_INCLUDED
>> +#define KFD_IOCTL_H_INCLUDED
>> +
>> +#include <linux/types.h>
>> +#include <linux/ioctl.h>
>> +
>> +#define KFD_IOCTL_CURRENT_VERSION 1
>> +
>> +/* The 64-bit ABI is the authoritative version. */
>> +#pragma pack(push, 1)
> 
> pagram pack must be remove do not use that.
> 
Removed in v3
>> +
>> +struct kfd_ioctl_get_version_args {
>> +	uint32_t min_supported_version;	/* from KFD */
>> +	uint32_t max_supported_version;	/* from KFD */
>> +};
>> +
>> +/* For kfd_ioctl_create_queue_args.queue_type. */
>> +#define KFD_IOC_QUEUE_TYPE_COMPUTE   0
>> +#define KFD_IOC_QUEUE_TYPE_SDMA      1
>> +
>> +struct kfd_ioctl_create_queue_args {
>> +	uint64_t ring_base_address;	/* to KFD */
>> +	uint64_t write_pointer_address;	/* from KFD */
>> +	uint64_t read_pointer_address;	/* from KFD */
>> +	uint64_t doorbell_address;	/* from KFD */
>> +
>> +	uint32_t ring_size;		/* to KFD */
>> +	uint32_t gpu_id;		/* to KFD */
>> +	uint32_t queue_type;		/* to KFD */
>> +	uint32_t queue_percentage;	/* to KFD */
>> +	uint32_t queue_priority;	/* to KFD */
>> +	uint32_t queue_id;		/* from KFD */
>> +};
>> +
>> +struct kfd_ioctl_destroy_queue_args {
>> +	uint32_t queue_id;		/* to KFD */
>> +};
>> +
>> +struct kfd_ioctl_update_queue_args {
>> +	uint64_t ring_base_address;	/* to KFD */
>> +
>> +	uint32_t queue_id;		/* to KFD */
>> +	uint32_t ring_size;		/* to KFD */
>> +	uint32_t queue_percentage;	/* to KFD */
>> +	uint32_t queue_priority;	/* to KFD */
>> +};
> 
> The queue_percentage and queue_priority really needs some explanations. I guess
> userspace would shed some light on those but still this should be properly explain.
> 
Added explanation in v3
>> +
>> +/* For kfd_ioctl_set_memory_policy_args.default_policy and alternate_policy */
>> +#define KFD_IOC_CACHE_POLICY_COHERENT 0
>> +#define KFD_IOC_CACHE_POLICY_NONCOHERENT 1
>> +
>> +struct kfd_ioctl_set_memory_policy_args {
>> +	uint64_t alternate_aperture_base;	/* to KFD */
>> +	uint64_t alternate_aperture_size;	/* to KFD */
>> +
>> +	uint32_t gpu_id;			/* to KFD */
>> +	uint32_t default_policy;		/* to KFD */
>> +	uint32_t alternate_policy;		/* to KFD */
>> +};
> 
> Same what is aperture in this context. I know about all this stuff but i have no
> idea what aperture is in this context.
> 
Added explanation in v3
>> +
>> +struct kfd_ioctl_get_clock_counters_args {
>> +	uint64_t gpu_clock_counter;	/* from KFD */
>> +	uint64_t cpu_clock_counter;	/* from KFD */
>> +	uint64_t system_clock_counter;	/* from KFD */
>> +	uint64_t system_clock_freq;	/* from KFD */
>> +
>> +	uint32_t gpu_id;		/* to KFD */
>> +};
> 
> Again comment about what kind of counter this is, monotonic, ...
> 
Added explanation in v3
>> +
>> +#define NUM_OF_SUPPORTED_GPUS 7
>> +
>> +struct kfd_process_device_apertures {
>> +	uint64_t lds_base;		/* from KFD */
>> +	uint64_t lds_limit;		/* from KFD */
>> +	uint64_t scratch_base;		/* from KFD */
>> +	uint64_t scratch_limit;		/* from KFD */
>> +	uint64_t gpuvm_base;		/* from KFD */
>> +	uint64_t gpuvm_limit;		/* from KFD */
>> +	uint32_t gpu_id;		/* from KFD */
>> +};
>> +
>> +struct kfd_ioctl_get_process_apertures_args {
>> +	struct kfd_process_device_apertures process_apertures[NUM_OF_SUPPORTED_GPUS];/* from KFD */
>> +	uint8_t num_of_nodes; /* from KFD, should be in the range [1 - NUM_OF_SUPPORTED_GPUS]*/
>> +};
> 
> I would rather see userspace provide a pointer to an array and the size of that
> array and possibly size of individual element. This would allow you to grow the
> kfd_process_device_apertures if needs be. Thought as i understand it this is a
> temporary driver.
> 
This is not going to change in the near or far future. I also agree that
we would probably see a common framework before NUM_OF_SUPPORTED_GPUS
increases.
If you insist, I'll try to squeeze it in at v4
>> +
>> +struct kfd_ioctl_pmc_acquire_access_args {
>> +	uint64_t trace_id;		/* to KFD */
>> +	uint32_t gpu_id;		/* to KFD */
>> +};
>> +
>> +struct kfd_ioctl_pmc_release_access_args {
>> +	uint64_t trace_id;		/* to KFD */
>> +	uint32_t gpu_id;		/* to KFD */
>> +};
> 
> As said above no ioctl to have some exclusive access you can not trust userspace
> that's rules NUMBER ONE.
> 
Removed in v3.
>> +
>> +#define KFD_IOC_MAGIC 'K'
>> +
>> +#define KFD_IOC_GET_VERSION		_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
>> +#define KFD_IOC_CREATE_QUEUE		_IOWR(KFD_IOC_MAGIC, 2, struct kfd_ioctl_create_queue_args)
>> +#define KFD_IOC_DESTROY_QUEUE		_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
>> +#define KFD_IOC_SET_MEMORY_POLICY	_IOW(KFD_IOC_MAGIC, 4, struct kfd_ioctl_set_memory_policy_args)
>> +#define KFD_IOC_GET_CLOCK_COUNTERS	_IOWR(KFD_IOC_MAGIC, 5, struct kfd_ioctl_get_clock_counters_args)
>> +#define KFD_IOC_GET_PROCESS_APERTURES	_IOR(KFD_IOC_MAGIC, 6, struct kfd_ioctl_get_process_apertures_args)
>> +#define KFD_IOC_UPDATE_QUEUE		_IOW(KFD_IOC_MAGIC, 7, struct kfd_ioctl_update_queue_args)
>> +#define KFD_IOC_PMC_ACQUIRE_ACCESS	_IOW(KFD_IOC_MAGIC, 12, struct kfd_ioctl_pmc_acquire_access_args)
>> +#define KFD_IOC_PMC_RELEASE_ACCESS	_IOW(KFD_IOC_MAGIC, 13, struct kfd_ioctl_pmc_release_access_args)
>> +
>> +#pragma pack(pop)
> 
> No pragma packing.
> 
Removed in v3
>> +
>> +#endif
>> -- 
>> 1.9.1
>>
Oded
