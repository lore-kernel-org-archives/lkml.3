Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaHBTTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 15:19:13 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:44941
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754735AbaHBTTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 15:19:11 -0400
X-WSS-ID: 0N9P1NT-08-KTK-02
X-M-MSG: 
Message-ID: <53DD39A3.30104@amd.com>
Date: Sat, 2 Aug 2014 22:18:59 +0300
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
Subject: Re: [PATCH v2 14/25] amdkfd: Add mqd_manager module
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-15-git-send-email-oded.gabbay@amd.com>
 <20140721023351.GK3068@gmail.com>
In-Reply-To: <20140721023351.GK3068@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.144]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(479174003)(189002)(199002)(51704005)(106466001)(81542001)(87936001)(19580405001)(85852003)(20776003)(77982001)(83322001)(81342001)(105586002)(79102001)(74662001)(50466002)(19580395003)(4396001)(65806001)(65956001)(83506001)(21056001)(85306004)(74502001)(80022001)(64706001)(44976005)(33656002)(101416001)(76176999)(83072002)(47776003)(31966008)(86362001)(65816999)(92566001)(99396002)(36756003)(76482001)(107046002)(54356999)(97736001)(95666004)(46102001)(23676002)(68736004)(50986999)(102836001)(84676001)(92726001)(2201001)(19627235001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB035;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029174C036
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/07/14 05:33, Jerome Glisse wrote:
> On Thu, Jul 17, 2014 at 04:29:21PM +0300, Oded Gabbay wrote:
>> From: Ben Goz <ben.goz@amd.com>
>>
>> The mqd_manager module handles MQD data structures. MQD stands for Memory Queue Descriptor, which is used by the H/W to keep the usermode queue state in memory.
>>
>> Signed-off-by: Ben Goz <ben.goz@amd.com>
>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>> ---
>>  drivers/gpu/drm/radeon/amdkfd/Makefile          |   2 +-
>>  drivers/gpu/drm/radeon/amdkfd/cik_mqds.h        | 185 +++++++++++++++
>>  drivers/gpu/drm/radeon/amdkfd/cik_regs.h        | 220 ++++++++++++++++++
>>  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c | 291 ++++++++++++++++++++++++
>>  drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h |  54 +++++
>>  drivers/gpu/drm/radeon/amdkfd/kfd_priv.h        |   8 +
>>  6 files changed, 759 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/cik_mqds.h
>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/cik_regs.h
>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c
>>  create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h
>>
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
>> index dbff147..b5201f4 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/Makefile
>> +++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
>> @@ -6,6 +6,6 @@ ccflags-y := -Iinclude/drm
>>  
>>  amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
>>  		kfd_pasid.o kfd_doorbell.o kfd_vidmem.o kfd_aperture.o \
>> -		kfd_process.o kfd_queue.o
>> +		kfd_process.o kfd_queue.o kfd_mqd_manager.o
>>  
>>  obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/cik_mqds.h b/drivers/gpu/drm/radeon/amdkfd/cik_mqds.h
>> new file mode 100644
>> index 0000000..ce75604
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/cik_mqds.h
>> @@ -0,0 +1,185 @@
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
>> +#ifndef CIK_MQDS_H_
>> +#define CIK_MQDS_H_
>> +
>> +#pragma pack(push, 4)
> 
> No pragma pack.
> 
Fixed in v3.
>> +
>> +struct cik_hpd_registers {
>> +	u32 cp_hpd_roq_offsets;
>> +	u32 cp_hpd_eop_base_addr;
>> +	u32 cp_hpd_eop_base_addr_hi;
>> +	u32 cp_hpd_eop_vmid;
>> +	u32 cp_hpd_eop_control;
>> +};
>> +
>> +/* This structure represents mqd used for cp scheduling queue
>> + * taken from Gfx72_cp_program_spec.pdf
>> + */
>> +struct cik_compute_mqd {
>> +	u32 header;
>> +	u32 compute_dispatch_initiator;
>> +	u32 compute_dim_x;
>> +	u32 compute_dim_y;
>> +	u32 compute_dim_z;
>> +	u32 compute_start_x;
>> +	u32 compute_start_y;
>> +	u32 compute_start_z;
>> +	u32 compute_num_thread_x;
>> +	u32 compute_num_thread_y;
>> +	u32 compute_num_thread_z;
>> +	u32 compute_pipelinestat_enable;
>> +	u32 compute_perfcount_enable;
>> +	u32 compute_pgm_lo;
>> +	u32 compute_pgm_hi;
>> +	u32 compute_tba_lo;
>> +	u32 compute_tba_hi;
>> +	u32 compute_tma_lo;
>> +	u32 compute_tma_hi;
>> +	u32 compute_pgm_rsrc1;
>> +	u32 compute_pgm_rsrc2;
>> +	u32 compute_vmid;
>> +	u32 compute_resource_limits;
>> +	u32 compute_static_thread_mgmt_se0;
>> +	u32 compute_static_thread_mgmt_se1;
>> +	u32 compute_tmpring_size;
>> +	u32 compute_static_thread_mgmt_se2;
>> +	u32 compute_static_thread_mgmt_se3;
>> +	u32 compute_restart_x;
>> +	u32 compute_restart_y;
>> +	u32 compute_restart_z;
>> +	u32 compute_thread_trace_enable;
>> +	u32 compute_misc_reserved;
>> +	u32 compute_user_data[16];
>> +	u32 vgt_csinvoc_count_lo;
>> +	u32 vgt_csinvoc_count_hi;
>> +	u32 cp_mqd_base_addr51;
>> +	u32 cp_mqd_base_addr_hi;
>> +	u32 cp_hqd_active;
>> +	u32 cp_hqd_vmid;
>> +	u32 cp_hqd_persistent_state;
>> +	u32 cp_hqd_pipe_priority;
>> +	u32 cp_hqd_queue_priority;
>> +	u32 cp_hqd_quantum;
>> +	u32 cp_hqd_pq_base;
>> +	u32 cp_hqd_pq_base_hi;
>> +	u32 cp_hqd_pq_rptr;
>> +	u32 cp_hqd_pq_rptr_report_addr;
>> +	u32 cp_hqd_pq_rptr_report_addr_hi;
>> +	u32 cp_hqd_pq_wptr_poll_addr;
>> +	u32 cp_hqd_pq_wptr_poll_addr_hi;
>> +	u32 cp_hqd_pq_doorbell_control;
>> +	u32 cp_hqd_pq_wptr;
>> +	u32 cp_hqd_pq_control;
>> +	u32 cp_hqd_ib_base_addr;
>> +	u32 cp_hqd_ib_base_addr_hi;
>> +	u32 cp_hqd_ib_rptr;
>> +	u32 cp_hqd_ib_control;
>> +	u32 cp_hqd_iq_timer;
>> +	u32 cp_hqd_iq_rptr;
>> +	u32 cp_hqd_dequeue_request;
>> +	u32 cp_hqd_dma_offload;
>> +	u32 cp_hqd_sema_cmd;
>> +	u32 cp_hqd_msg_type;
>> +	u32 cp_hqd_atomic0_preop_lo;
>> +	u32 cp_hqd_atomic0_preop_hi;
>> +	u32 cp_hqd_atomic1_preop_lo;
>> +	u32 cp_hqd_atomic1_preop_hi;
>> +	u32 cp_hqd_hq_scheduler0;
>> +	u32 cp_hqd_hq_scheduler1;
>> +	u32 cp_mqd_control;
>> +	u32 reserved1[10];
>> +	u32 cp_mqd_query_time_lo;
>> +	u32 cp_mqd_query_time_hi;
>> +	u32 reserved2[4];
>> +	u32 cp_mqd_connect_start_time_lo;
>> +	u32 cp_mqd_connect_start_time_hi;
>> +	u32 cp_mqd_connect_end_time_lo;
>> +	u32 cp_mqd_connect_end_time_hi;
>> +	u32 cp_mqd_connect_end_wf_count;
>> +	u32 cp_mqd_connect_end_pq_rptr;
>> +	u32 cp_mqd_connect_end_pq_wptr;
>> +	u32 cp_mqd_connect_end_ib_rptr;
>> +	u32 reserved3[18];
>> +};
>> +
>> +/* This structure represents all *IQs
>> + * Taken from Gfx73_CPC_Eng_Init_Prog.pdf
>> + */
>> +struct cik_interface_mqd {
>> +	u32 reserved1[128];
>> +	u32 cp_mqd_base_addr;
>> +	u32 cp_mqd_base_addr_hi;
>> +	u32 cp_hqd_active;
>> +	u32 cp_hqd_vmid;
>> +	u32 cp_hqd_persistent_state;
>> +	u32 cp_hqd_pipe_priority;
>> +	u32 cp_hqd_queue_priority;
>> +	u32 cp_hqd_quantum;
>> +	u32 cp_hqd_pq_base;
>> +	u32 cp_hqd_pq_base_hi;
>> +	u32 cp_hqd_pq_rptr;
>> +	u32 cp_hqd_pq_rptr_report_addr;
>> +	u32 cp_hqd_pq_rptr_report_addr_hi;
>> +	u32 cp_hqd_pq_wptr_poll_addr;
>> +	u32 cp_hqd_pq_wptr_poll_addr_hi;
>> +	u32 cp_hqd_pq_doorbell_control;
>> +	u32 cp_hqd_pq_wptr;
>> +	u32 cp_hqd_pq_control;
>> +	u32 cp_hqd_ib_base_addr;
>> +	u32 cp_hqd_ib_base_addr_hi;
>> +	u32 cp_hqd_ib_rptr;
>> +	u32 cp_hqd_ib_control;
>> +	u32 cp_hqd_iq_timer;
>> +	u32 cp_hqd_iq_rptr;
>> +	u32 cp_hqd_dequeue_request;
>> +	u32 cp_hqd_dma_offload;
>> +	u32 cp_hqd_sema_cmd;
>> +	u32 cp_hqd_msg_type;
>> +	u32 cp_hqd_atomic0_preop_lo;
>> +	u32 cp_hqd_atomic0_preop_hi;
>> +	u32 cp_hqd_atomic1_preop_lo;
>> +	u32 cp_hqd_atomic1_preop_hi;
>> +	u32 cp_hqd_hq_status0;
>> +	u32 cp_hqd_hq_control0;
>> +	u32 cp_mqd_control;
>> +	u32 reserved2[3];
>> +	u32 cp_hqd_hq_status1;
>> +	u32 cp_hqd_hq_control1;
>> +	u32 reserved3[16];
>> +	u32 cp_hqd_hq_status2;
>> +	u32 cp_hqd_hq_control2;
>> +	u32 cp_hqd_hq_status3;
>> +	u32 cp_hqd_hq_control3;
>> +	u32 reserved4[2];
>> +	u32 cp_mqd_query_time_lo;
>> +	u32 cp_mqd_query_time_hi;
>> +	u32 reserved5[48];
>> +	u32 cp_mqd_skip_process[16];
>> +};
> 
> I have not fully check but very few of the above fields are use. So please
> do strip this structure to only used field we need to keep stack use as low
> as possible. Moreover the whole reserved* business kind of tell me that this
> is done to match register layout which i would rather avoid being use as a
> struct.
> 
The struct cik_mqd, which also includes struct cik_hqd_registers,
describe the mqd itself. The mqd is not registers perse, but rather a
structure that is common interface between the CPU and GPU. Although we
don't initalize all its members (as some of them are for the GPU usage),
I believe this is the proper way to use it. Do you have another suggestion ?

>> +
>> +#pragma pack(pop)
>> +
>> +
>> +#endif /* CIK_MQDS_H_ */
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/cik_regs.h b/drivers/gpu/drm/radeon/amdkfd/cik_regs.h
>> new file mode 100644
>> index 0000000..a6404e3
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/cik_regs.h
>> @@ -0,0 +1,220 @@
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
>> +#ifndef CIK_REGS_H
>> +#define CIK_REGS_H
>> +
>> +#define IH_VMID_0_LUT					0x3D40u
>> +
>> +#define BIF_DOORBELL_CNTL				0x530Cu
>> +
>> +#define	SRBM_GFX_CNTL					0xE44
>> +#define	PIPEID(x)					((x) << 0)
>> +#define	MEID(x)						((x) << 2)
>> +#define	VMID(x)						((x) << 4)
>> +#define	QUEUEID(x)					((x) << 8)
>> +
>> +#define	SQ_CONFIG					0x8C00
>> +
>> +#define	SH_MEM_BASES					0x8C28
>> +/* if PTR32, these are the bases for scratch and lds */
>> +#define	PRIVATE_BASE(x)					((x) << 0) /* scratch */
>> +#define	SHARED_BASE(x)					((x) << 16) /* LDS */
>> +#define	SH_MEM_APE1_BASE				0x8C2C
>> +/* if PTR32, this is the base location of GPUVM */
>> +#define	SH_MEM_APE1_LIMIT				0x8C30
>> +/* if PTR32, this is the upper limit of GPUVM */
>> +#define	SH_MEM_CONFIG					0x8C34
>> +#define	PTR32						(1 << 0)
>> +#define PRIVATE_ATC					(1 << 1)
>> +#define	ALIGNMENT_MODE(x)				((x) << 2)
>> +#define	SH_MEM_ALIGNMENT_MODE_DWORD			0
>> +#define	SH_MEM_ALIGNMENT_MODE_DWORD_STRICT		1
>> +#define	SH_MEM_ALIGNMENT_MODE_STRICT			2
>> +#define	SH_MEM_ALIGNMENT_MODE_UNALIGNED			3
>> +#define	DEFAULT_MTYPE(x)				((x) << 4)
>> +#define	APE1_MTYPE(x)					((x) << 7)
>> +
>> +/* valid for both DEFAULT_MTYPE and APE1_MTYPE */
>> +#define	MTYPE_CACHED					0
>> +#define	MTYPE_NONCACHED					3
>> +
>> +
>> +#define SH_STATIC_MEM_CONFIG				0x9604u
>> +
>> +#define	TC_CFG_L1_LOAD_POLICY0				0xAC68
>> +#define	TC_CFG_L1_LOAD_POLICY1				0xAC6C
>> +#define	TC_CFG_L1_STORE_POLICY				0xAC70
>> +#define	TC_CFG_L2_LOAD_POLICY0				0xAC74
>> +#define	TC_CFG_L2_LOAD_POLICY1				0xAC78
>> +#define	TC_CFG_L2_STORE_POLICY0				0xAC7C
>> +#define	TC_CFG_L2_STORE_POLICY1				0xAC80
>> +#define	TC_CFG_L2_ATOMIC_POLICY				0xAC84
>> +#define	TC_CFG_L1_VOLATILE				0xAC88
>> +#define	TC_CFG_L2_VOLATILE				0xAC8C
>> +
>> +#define CP_PQ_WPTR_POLL_CNTL				0xC20C
>> +#define	WPTR_POLL_EN					(1 << 31)
>> +
>> +#define CPC_INT_CNTL					0xC2D0
>> +#define CP_ME1_PIPE0_INT_CNTL				0xC214
>> +#define CP_ME1_PIPE1_INT_CNTL				0xC218
>> +#define CP_ME1_PIPE2_INT_CNTL				0xC21C
>> +#define CP_ME1_PIPE3_INT_CNTL				0xC220
>> +#define CP_ME2_PIPE0_INT_CNTL				0xC224
>> +#define CP_ME2_PIPE1_INT_CNTL				0xC228
>> +#define CP_ME2_PIPE2_INT_CNTL				0xC22C
>> +#define CP_ME2_PIPE3_INT_CNTL				0xC230
>> +#define DEQUEUE_REQUEST_INT_ENABLE			(1 << 13)
>> +#define WRM_POLL_TIMEOUT_INT_ENABLE			(1 << 17)
>> +#define PRIV_REG_INT_ENABLE				(1 << 23)
>> +#define TIME_STAMP_INT_ENABLE				(1 << 26)
>> +#define GENERIC2_INT_ENABLE				(1 << 29)
>> +#define GENERIC1_INT_ENABLE				(1 << 30)
>> +#define GENERIC0_INT_ENABLE				(1 << 31)
>> +#define CP_ME1_PIPE0_INT_STATUS				0xC214
>> +#define CP_ME1_PIPE1_INT_STATUS				0xC218
>> +#define CP_ME1_PIPE2_INT_STATUS				0xC21C
>> +#define CP_ME1_PIPE3_INT_STATUS				0xC220
>> +#define CP_ME2_PIPE0_INT_STATUS				0xC224
>> +#define CP_ME2_PIPE1_INT_STATUS				0xC228
>> +#define CP_ME2_PIPE2_INT_STATUS				0xC22C
>> +#define CP_ME2_PIPE3_INT_STATUS				0xC230
>> +#define DEQUEUE_REQUEST_INT_STATUS			(1 << 13)
>> +#define WRM_POLL_TIMEOUT_INT_STATUS			(1 << 17)
>> +#define PRIV_REG_INT_STATUS				(1 << 23)
>> +#define TIME_STAMP_INT_STATUS				(1 << 26)
>> +#define GENERIC2_INT_STATUS				(1 << 29)
>> +#define GENERIC1_INT_STATUS				(1 << 30)
>> +#define GENERIC0_INT_STATUS				(1 << 31)
>> +
>> +#define CP_HPD_EOP_BASE_ADDR				0xC904
>> +#define CP_HPD_EOP_BASE_ADDR_HI				0xC908
>> +#define CP_HPD_EOP_VMID					0xC90C
>> +#define CP_HPD_EOP_CONTROL				0xC910
>> +#define	EOP_SIZE(x)					((x) << 0)
>> +#define	EOP_SIZE_MASK					(0x3f << 0)
>> +#define CP_MQD_BASE_ADDR				0xC914
>> +#define CP_MQD_BASE_ADDR_HI				0xC918
>> +#define CP_HQD_ACTIVE					0xC91C
>> +#define CP_HQD_VMID					0xC920
>> +
>> +#define CP_HQD_PERSISTENT_STATE				0xC924u
>> +#define	DEFAULT_CP_HQD_PERSISTENT_STATE			(0x33U << 8)
>> +
>> +#define CP_HQD_PIPE_PRIORITY				0xC928u
>> +#define CP_HQD_QUEUE_PRIORITY				0xC92Cu
>> +#define CP_HQD_QUANTUM					0xC930u
>> +#define	QUANTUM_EN					1U
>> +#define	QUANTUM_SCALE_1MS				(1U << 4)
>> +#define	QUANTUM_DURATION(x)				((x) << 8)
>> +
>> +#define CP_HQD_PQ_BASE					0xC934
>> +#define CP_HQD_PQ_BASE_HI				0xC938
>> +#define CP_HQD_PQ_RPTR					0xC93C
>> +#define CP_HQD_PQ_RPTR_REPORT_ADDR			0xC940
>> +#define CP_HQD_PQ_RPTR_REPORT_ADDR_HI			0xC944
>> +#define CP_HQD_PQ_WPTR_POLL_ADDR			0xC948
>> +#define CP_HQD_PQ_WPTR_POLL_ADDR_HI			0xC94C
>> +#define CP_HQD_PQ_DOORBELL_CONTROL			0xC950
>> +#define	DOORBELL_OFFSET(x)				((x) << 2)
>> +#define	DOORBELL_OFFSET_MASK				(0x1fffff << 2)
>> +#define	DOORBELL_SOURCE					(1 << 28)
>> +#define	DOORBELL_SCHD_HIT				(1 << 29)
>> +#define	DOORBELL_EN					(1 << 30)
>> +#define	DOORBELL_HIT					(1 << 31)
>> +#define CP_HQD_PQ_WPTR					0xC954
>> +#define CP_HQD_PQ_CONTROL				0xC958
>> +#define	QUEUE_SIZE(x)					((x) << 0)
>> +#define	QUEUE_SIZE_MASK					(0x3f << 0)
>> +#define	RPTR_BLOCK_SIZE(x)				((x) << 8)
>> +#define	RPTR_BLOCK_SIZE_MASK				(0x3f << 8)
>> +#define	MIN_AVAIL_SIZE(x)				((x) << 20)
>> +#define	PQ_ATC_EN					(1 << 23)
>> +#define	PQ_VOLATILE					(1 << 26)
>> +#define	NO_UPDATE_RPTR					(1 << 27)
>> +#define	UNORD_DISPATCH					(1 << 28)
>> +#define	ROQ_PQ_IB_FLIP					(1 << 29)
>> +#define	PRIV_STATE					(1 << 30)
>> +#define	KMD_QUEUE					(1 << 31)
>> +
>> +#define	DEFAULT_RPTR_BLOCK_SIZE				RPTR_BLOCK_SIZE(5)
>> +#define	DEFAULT_MIN_AVAIL_SIZE				MIN_AVAIL_SIZE(3)
>> +
>> +#define CP_HQD_IB_BASE_ADDR				0xC95Cu
>> +#define CP_HQD_IB_BASE_ADDR_HI				0xC960u
>> +#define CP_HQD_IB_RPTR					0xC964u
>> +#define CP_HQD_IB_CONTROL				0xC968u
>> +#define	IB_ATC_EN					(1U << 23)
>> +#define	DEFAULT_MIN_IB_AVAIL_SIZE			(3U << 20)
>> +
>> +#define CP_HQD_DEQUEUE_REQUEST				0xC974
>> +#define	DEQUEUE_REQUEST_DRAIN				1
>> +#define DEQUEUE_REQUEST_RESET				2
>> +#define		DEQUEUE_INT					(1U << 8)
>> +
>> +#define CP_HQD_SEMA_CMD					0xC97Cu
>> +#define CP_HQD_MSG_TYPE					0xC980u
>> +#define CP_HQD_ATOMIC0_PREOP_LO				0xC984u
>> +#define CP_HQD_ATOMIC0_PREOP_HI				0xC988u
>> +#define CP_HQD_ATOMIC1_PREOP_LO				0xC98Cu
>> +#define CP_HQD_ATOMIC1_PREOP_HI				0xC990u
>> +#define CP_HQD_HQ_SCHEDULER0				0xC994u
>> +#define CP_HQD_HQ_SCHEDULER1				0xC998u
>> +
>> +
>> +#define CP_MQD_CONTROL					0xC99C
>> +#define	MQD_VMID(x)					((x) << 0)
>> +#define	MQD_VMID_MASK					(0xf << 0)
>> +#define	MQD_CONTROL_PRIV_STATE_EN			(1U << 8)
>> +
>> +#define GRBM_GFX_INDEX					0x30800
>> +#define	INSTANCE_INDEX(x)				((x) << 0)
>> +#define	SH_INDEX(x)					((x) << 8)
>> +#define	SE_INDEX(x)					((x) << 16)
>> +#define	SH_BROADCAST_WRITES				(1 << 29)
>> +#define	INSTANCE_BROADCAST_WRITES			(1 << 30)
>> +#define	SE_BROADCAST_WRITES				(1 << 31)
>> +
>> +#define SQC_CACHES					0x30d20
>> +#define SQC_POLICY					0x8C38u
>> +#define SQC_VOLATILE					0x8C3Cu
>> +
>> +#define CP_PERFMON_CNTL					0x36020
>> +
>> +#define ATC_VMID0_PASID_MAPPING				0x339Cu
>> +#define	ATC_VMID_PASID_MAPPING_UPDATE_STATUS		0x3398u
>> +#define	ATC_VMID_PASID_MAPPING_VALID			(1U << 31)
>> +
>> +#define ATC_VM_APERTURE0_CNTL				0x3310u
>> +#define	ATS_ACCESS_MODE_NEVER				0
>> +#define	ATS_ACCESS_MODE_ALWAYS				1
>> +
>> +#define ATC_VM_APERTURE0_CNTL2				0x3318u
>> +#define ATC_VM_APERTURE0_HIGH_ADDR			0x3308u
>> +#define ATC_VM_APERTURE0_LOW_ADDR			0x3300u
>> +#define ATC_VM_APERTURE1_CNTL				0x3314u
>> +#define ATC_VM_APERTURE1_CNTL2				0x331Cu
>> +#define ATC_VM_APERTURE1_HIGH_ADDR			0x330Cu
>> +#define ATC_VM_APERTURE1_LOW_ADDR			0x3304u
>> +
>> +#endif
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c b/drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c
>> new file mode 100644
>> index 0000000..5f9f9b9
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.c
>> @@ -0,0 +1,291 @@
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
>> +#include <linux/printk.h>
>> +#include <linux/slab.h>
>> +#include "kfd_priv.h"
>> +#include "kfd_mqd_manager.h"
>> +#include "cik_mqds.h"
>> +#include "cik_regs.h"
>> +#include "../cik_reg.h"
>> +
>> +inline uint32_t lower_32(uint64_t x)
>> +{
>> +	return (uint32_t)x;
>> +}
>> +
>> +inline uint32_t upper_32(uint64_t x)
>> +{
>> +	return (uint32_t)(x >> 32);
>> +}
> 
> Do use kernel macro upper_32_bits or lower_32_bits. Each time you do something
> like that go check for existing macro.
> 
Done in v3
>> +
>> +inline void busy_wait(unsigned long ms)
>> +{
>> +	while (time_before(jiffies, ms))
>> +		cpu_relax();
>> +}
>> +
>> +static inline struct cik_mqd *get_mqd(void *mqd)
>> +{
>> +	return (struct cik_mqd *)mqd;
>> +}
>> +
>> +static int init_mqd(struct mqd_manager *mm, void **mqd, kfd_mem_obj *mqd_mem_obj,
>> +		uint64_t *gart_addr, struct queue_properties *q)
>> +{
>> +	uint64_t addr;
>> +	struct cik_mqd *m;
>> +	int retval;
>> +
>> +	BUG_ON(!mm || !q || !mqd);
>> +
>> +	pr_debug("kfd: In func %s\n", __func__);
>> +
>> +	retval = kfd_vidmem_alloc_map(
>> +				mm->dev,
>> +				mqd_mem_obj,
>> +				(void **)&m,
>> +				&addr,
>> +				ALIGN(sizeof(struct cik_mqd), 256));
>> +
>> +	if (retval != 0)
>> +		return -ENOMEM;
>> +
>> +	memset(m, 0, sizeof(struct cik_mqd));
>> +
>> +	m->header = 0xC0310800;
>> +	m->pipeline_stat_enable = 1;
>> +	m->static_thread_mgmt01[0] = 0xFFFFFFFF;
>> +	m->static_thread_mgmt01[1] = 0xFFFFFFFF;
>> +	m->static_thread_mgmt23[0] = 0xFFFFFFFF;
>> +	m->static_thread_mgmt23[1] = 0xFFFFFFFF;
>> +
>> +	m->queue_state.cp_hqd_persistent_state = DEFAULT_CP_HQD_PERSISTENT_STATE;
>> +
>> +	m->queue_state.cp_mqd_control             = MQD_CONTROL_PRIV_STATE_EN;
>> +	m->queue_state.cp_mqd_base_addr           = lower_32(addr);
>> +	m->queue_state.cp_mqd_base_addr_hi        = upper_32(addr);
>> +
>> +	m->queue_state.cp_hqd_ib_control = DEFAULT_MIN_IB_AVAIL_SIZE | IB_ATC_EN;
>> +	/* Although WinKFD writes this, I suspect it should not be necessary. */
>> +	m->queue_state.cp_hqd_ib_control = IB_ATC_EN | DEFAULT_MIN_IB_AVAIL_SIZE;
>> +
>> +	m->queue_state.cp_hqd_quantum = QUANTUM_EN | QUANTUM_SCALE_1MS | QUANTUM_DURATION(10);
>> +
>> +	m->queue_state.cp_hqd_pipe_priority = 1;
>> +	m->queue_state.cp_hqd_queue_priority = 15;
>> +
>> +	*mqd = m;
>> +	if (gart_addr != NULL)
>> +		*gart_addr = addr;
>> +	retval = mm->update_mqd(mm, m, q);
>> +
>> +	return retval;
>> +}
>> +
>> +static void uninit_mqd(struct mqd_manager *mm, void *mqd, kfd_mem_obj mqd_mem_obj)
>> +{
>> +	BUG_ON(!mm || !mqd);
>> +	kfd_vidmem_free_unmap(mm->dev, mqd_mem_obj);
>> +}
>> +
>> +static int load_mqd(struct mqd_manager *mm, void *mqd, uint32_t pipe_id, uint32_t queue_id, uint32_t __user *wptr)
>> +{
>> +	return kfd2kgd->hqd_load(mm->dev->kgd, mqd, pipe_id, queue_id, wptr);
>> +
>> +}
>> +
>> +static int update_mqd(struct mqd_manager *mm, void *mqd, struct queue_properties *q)
>> +{
>> +	struct cik_mqd *m;
>> +
>> +	BUG_ON(!mm || !q || !mqd);
>> +
>> +	pr_debug("kfd: In func %s\n", __func__);
>> +
>> +	m = get_mqd(mqd);
>> +	m->queue_state.cp_hqd_pq_control = DEFAULT_RPTR_BLOCK_SIZE | DEFAULT_MIN_AVAIL_SIZE | PQ_ATC_EN;
>> +	/* calculating queue size which is log base 2 of actual queue size -1 dwords and another -1 for ffs */
>> +	m->queue_state.cp_hqd_pq_control |= ffs(q->queue_size / sizeof(unsigned int)) - 1 - 1;
>> +	m->queue_state.cp_hqd_pq_base = lower_32((uint64_t)q->queue_address >> 8);
>> +	m->queue_state.cp_hqd_pq_base_hi = upper_32((uint64_t)q->queue_address >> 8);
>> +	m->queue_state.cp_hqd_pq_rptr_report_addr = lower_32((uint64_t)q->read_ptr);
>> +	m->queue_state.cp_hqd_pq_rptr_report_addr_hi = upper_32((uint64_t)q->read_ptr);
>> +	m->queue_state.cp_hqd_pq_doorbell_control = DOORBELL_EN | DOORBELL_OFFSET(q->doorbell_off);
>> +
>> +	m->queue_state.cp_hqd_vmid = q->vmid;
>> +
>> +	m->queue_state.cp_hqd_active = 0;
>> +	q->is_active = false;
>> +	if (q->queue_size > 0 &&
>> +			q->queue_address != 0 &&
>> +			q->queue_percent > 0) {
>> +		m->queue_state.cp_hqd_active = 1;
>> +		q->is_active = true;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int destroy_mqd(struct mqd_manager *mm, bool is_reset, unsigned int timeout, uint32_t pipe_id, uint32_t queue_id)
>> +{
>> +	return kfd2kgd->hqd_destroy(mm->dev->kgd, is_reset, timeout, pipe_id, queue_id);
>> +}
>> +
>> +bool is_occupied(struct mqd_manager *mm, uint64_t queue_address, uint32_t pipe_id, uint32_t queue_id)
>> +{
>> +
>> +	return kfd2kgd->hqd_is_occupies(mm->dev->kgd, queue_address, pipe_id, queue_id);
>> +
>> +}
>> +
>> +/*
>> + * HIQ MQD Implementation
>> + */
> 
> A more useful comment than that.
Done in v3
> 
>> +
>> +static int init_mqd_hiq(struct mqd_manager *mm, void **mqd, kfd_mem_obj *mqd_mem_obj,
>> +		uint64_t *gart_addr, struct queue_properties *q)
>> +{
>> +	uint64_t addr;
>> +	struct cik_mqd *m;
>> +	int retval;
>> +
>> +	BUG_ON(!mm || !q || !mqd || !mqd_mem_obj);
>> +
>> +	pr_debug("kfd: In func %s\n", __func__);
>> +
>> +	retval = kfd_vidmem_alloc_map(
>> +				mm->dev,
>> +				mqd_mem_obj,
>> +				(void **)&m,
>> +				&addr,
>> +				ALIGN(sizeof(struct cik_mqd), PAGE_SIZE));
>> +
>> +	if (retval != 0)
>> +		return -ENOMEM;
>> +
>> +	memset(m, 0, sizeof(struct cik_mqd));
>> +
>> +	m->header = 0xC0310800;
>> +	m->pipeline_stat_enable = 1;
>> +	m->static_thread_mgmt01[0] = 0xFFFFFFFF;
>> +	m->static_thread_mgmt01[1] = 0xFFFFFFFF;
>> +	m->static_thread_mgmt23[0] = 0xFFFFFFFF;
>> +	m->static_thread_mgmt23[1] = 0xFFFFFFFF;
>> +
>> +	m->queue_state.cp_hqd_persistent_state = DEFAULT_CP_HQD_PERSISTENT_STATE;
>> +
>> +	m->queue_state.cp_mqd_control             = MQD_CONTROL_PRIV_STATE_EN;
>> +	m->queue_state.cp_mqd_base_addr           = lower_32(addr);
>> +	m->queue_state.cp_mqd_base_addr_hi        = upper_32(addr);
>> +
>> +	m->queue_state.cp_hqd_ib_control = DEFAULT_MIN_IB_AVAIL_SIZE;
>> +
>> +	m->queue_state.cp_hqd_quantum = QUANTUM_EN | QUANTUM_SCALE_1MS | QUANTUM_DURATION(10);
>> +
>> +	m->queue_state.cp_hqd_pipe_priority = 1;
>> +	m->queue_state.cp_hqd_queue_priority = 15;
>> +
>> +	*mqd = m;
>> +	if (gart_addr)
>> +		*gart_addr = addr;
>> +	retval = mm->update_mqd(mm, m, q);
>> +
>> +	return retval;
>> +}
>> +
>> +static int update_mqd_hiq(struct mqd_manager *mm, void *mqd, struct queue_properties *q)
>> +{
>> +	struct cik_mqd *m;
>> +
>> +	BUG_ON(!mm || !q || !mqd);
>> +
>> +	pr_debug("kfd: In func %s\n", __func__);
>> +
>> +	m = get_mqd(mqd);
>> +	m->queue_state.cp_hqd_pq_control = DEFAULT_RPTR_BLOCK_SIZE | DEFAULT_MIN_AVAIL_SIZE | PRIV_STATE | KMD_QUEUE;
>> +	/* calculating queue size which is log base 2 of actual queue size -1 dwords */
>> +	m->queue_state.cp_hqd_pq_control |= ffs(q->queue_size / sizeof(unsigned int)) - 1 - 1;
>> +	m->queue_state.cp_hqd_pq_base = lower_32((uint64_t)q->queue_address >> 8);
>> +	m->queue_state.cp_hqd_pq_base_hi = upper_32((uint64_t)q->queue_address >> 8);
>> +	m->queue_state.cp_hqd_pq_rptr_report_addr = lower_32((uint64_t)q->read_ptr);
>> +	m->queue_state.cp_hqd_pq_rptr_report_addr_hi = upper_32((uint64_t)q->read_ptr);
>> +	m->queue_state.cp_hqd_pq_doorbell_control = DOORBELL_EN | DOORBELL_OFFSET(q->doorbell_off);
>> +
>> +	m->queue_state.cp_hqd_vmid = q->vmid;
>> +
>> +	m->queue_state.cp_hqd_active = 0;
>> +	q->is_active = false;
>> +	if (q->queue_size > 0 &&
>> +			q->queue_address != 0 &&
>> +			q->queue_percent > 0) {
>> +		m->queue_state.cp_hqd_active = 1;
>> +		q->is_active = true;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +struct mqd_manager *mqd_manager_init(enum KFD_MQD_TYPE type, struct kfd_dev *dev)
>> +{
>> +	struct mqd_manager *mqd;
>> +
>> +	BUG_ON(!dev);
>> +	BUG_ON(type >= KFD_MQD_TYPE_MAX);
>> +
>> +	pr_debug("kfd: In func %s\n", __func__);
>> +
>> +	mqd = kzalloc(sizeof(struct mqd_manager), GFP_KERNEL);
>> +	if (!mqd)
>> +		return NULL;
>> +
>> +	mqd->dev = dev;
>> +
>> +	switch (type) {
>> +	case KFD_MQD_TYPE_CIK_CP:
>> +	case KFD_MQD_TYPE_CIK_COMPUTE:
>> +		mqd->init_mqd = init_mqd;
>> +		mqd->uninit_mqd = uninit_mqd;
>> +		mqd->load_mqd = load_mqd;
>> +		mqd->update_mqd = update_mqd;
>> +		mqd->destroy_mqd = destroy_mqd;
>> +		mqd->is_occupied = is_occupied;
>> +		break;
>> +	case KFD_MQD_TYPE_CIK_HIQ:
>> +		mqd->init_mqd = init_mqd_hiq;
>> +		mqd->uninit_mqd = uninit_mqd;
>> +		mqd->load_mqd = load_mqd;
>> +		mqd->update_mqd = update_mqd_hiq;
>> +		mqd->destroy_mqd = destroy_mqd;
>> +		mqd->is_occupied = is_occupied;
>> +		break;
>> +	default:
>> +		kfree(mqd);
>> +		return NULL;
>> +		break;
>> +	}
>> +
>> +	return mqd;
>> +}
>> +
>> +/* SDMA queues should be implemented here when the cp will supports them */
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h b/drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h
>> new file mode 100644
>> index 0000000..a6b0007
>> --- /dev/null
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_mqd_manager.h
>> @@ -0,0 +1,54 @@
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
>> +#ifndef KFD_MQD_MANAGER_H_
>> +#define KFD_MQD_MANAGER_H_
>> +
>> +#include "kfd_priv.h"
>> +
>> +struct mqd_manager {
>> +	int	(*init_mqd)(struct mqd_manager *mm, void **mqd,
>> +			kfd_mem_obj *mqd_mem_obj, uint64_t *gart_addr,
>> +			struct queue_properties *q);
>> +
>> +	int	(*load_mqd)(struct mqd_manager *mm, void *mqd,
>> +				uint32_t pipe_id, uint32_t queue_id,
>> +				uint32_t __user *wptr);
>> +
>> +	int	(*update_mqd)(struct mqd_manager *mm, void *mqd,
>> +				struct queue_properties *q);
>> +
>> +	int	(*destroy_mqd)(struct mqd_manager *mm, bool is_reset,
>> +				unsigned int timeout, uint32_t pipe_id,
>> +				uint32_t queue_id);
>> +
>> +	void	(*uninit_mqd)(struct mqd_manager *mm, void *mqd,
>> +				kfd_mem_obj mqd_mem_obj);
>> +	bool	(*is_occupied)(struct mqd_manager *mm, uint64_t queue_address,
>> +				uint32_t pipe_id, uint32_t queue_id);
>> +
>> +	struct mutex	mqd_mutex;
>> +	struct kfd_dev	*dev;
>> +};
> 
> Would be nice to have this interface documented. For reference see how ttm
> document things (include/drm/ttm/*.h)
> 
Done in v3

	Oded
>> +
>> +#endif /* KFD_MQD_MANAGER_H_ */
>> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> index 94ff1c3..76494757 100644
>> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
>> @@ -179,6 +179,14 @@ struct queue {
>>  	struct kfd_dev		*device;
>>  };
>>  
>> +enum KFD_MQD_TYPE {
>> +	KFD_MQD_TYPE_CIK_COMPUTE = 0, /* for no cp scheduling */
>> +	KFD_MQD_TYPE_CIK_HIQ, /* for hiq */
>> +	KFD_MQD_TYPE_CIK_CP, /* for cp queues and diq */
>> +	KFD_MQD_TYPE_CIK_SDMA, /* for sdma queues */
>> +	KFD_MQD_TYPE_MAX
>> +};
>> +
>>  /* Data that is per-process-per device. */
>>  struct kfd_process_device {
>>  	/*
>> -- 
>> 1.9.1
>>
