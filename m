Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaGKRIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:08:40 -0400
Received: from [207.46.163.144] ([207.46.163.144]:49831 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751045AbaGKRIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:08:39 -0400
X-WSS-ID: 0N8K4X1-07-87H-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: Alex Deucher <alexdeucher@gmail.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
CC: Oded Gabbay <oded.gabbay@gmail.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Maling list - DRI developers" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: RE: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes
 in KV
Thread-Topic: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and
 pipes in KV
Thread-Index: AQHPnIkE5u7uzYXY9UmcyTqCh3tvUpubTcyAgAADzgCAAAEXAP//xj7Q
Date: Fri, 11 Jul 2014 17:07:50 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01031826@storexdag02.amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <20140711160516.GC1870@gmail.com> <53C00E6E.4040908@amd.com>
 <CADnq5_NkXJuaeMWv8HogykiH8ida17U90gO0Ec7DMRxMcLbrkA@mail.gmail.com>
In-Reply-To: <CADnq5_NkXJuaeMWv8HogykiH8ida17U90gO0Ec7DMRxMcLbrkA@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(164054003)(377454003)(13464003)(189002)(24454002)(199002)(21056001)(50986999)(86362001)(85306003)(575784001)(4396001)(99396002)(105586002)(44976005)(50466002)(106116001)(53416004)(87936001)(84676001)(97736001)(20776003)(77096002)(64706001)(19580405001)(101416001)(85852003)(54356999)(2656002)(81542001)(93886003)(81342001)(92566001)(76176999)(47776003)(76482001)(55846006)(95666004)(107046002)(80022001)(79102001)(15202345003)(77982001)(33656002)(23676002)(106466001)(83322001)(92726001)(68736004)(83072002)(46102001)(31966008)(15975445006)(74662001)(19580395003)(74502001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB034;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02698DF457
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6BH8pL5022027



>-----Original Message-----
>From: dri-devel [mailto:dri-devel-bounces@lists.freedesktop.org] On Behalf
>Of Alex Deucher
>Sent: Friday, July 11, 2014 12:23 PM
>To: Koenig, Christian
>Cc: Oded Gabbay; Lewycky, Andrew; LKML; Maling list - DRI developers;
>Deucher, Alexander
>Subject: Re: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and
>pipes in KV
>
>On Fri, Jul 11, 2014 at 12:18 PM, Christian KÃ¶nig <christian.koenig@amd.com>
>wrote:
>> Am 11.07.2014 18:05, schrieb Jerome Glisse:
>>
>>> On Fri, Jul 11, 2014 at 12:50:02AM +0300, Oded Gabbay wrote:
>>>>
>>>> To support HSA on KV, we need to limit the number of vmids and pipes
>>>> that are available for radeon's use with KV.
>>>>
>>>> This patch reserves VMIDs 8-15 for KFD (so radeon can only use VMIDs
>>>> 0-7) and also makes radeon thinks that KV has only a single MEC with
>>>> a single pipe in it
>>>>
>>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>>
>>> Reviewed-by: JÃ©rÃ´me Glisse <jglisse@redhat.com>
>>
>>
>> At least fro the VMIDs on demand allocation should be trivial to
>> implement, so I would rather prefer this instead of a fixed assignment.
>
>IIRC, the way the CP hw scheduler works you have to give it a range of vmids
>and it assigns them dynamically as queues are mapped so effectively they
>are potentially in use once the CP scheduler is set up.
>
>Alex

Right. The SET_RESOURCES packet (kfd_pm4_headers.h, added in patch 49) allocates a range of HW queues, VMIDs and GDS to the HW scheduler, then the scheduler uses the allocated VMIDs to support a potentially larger number of user processes by dynamically mapping PASIDs to VMIDs and memory queue descriptors (MQDs) to HW queues.

BTW Oded I think we have some duplicated defines at the end of kfd_pm4_headers.h, if they are really duplicates it would be great to remove those before the pull request.

Thanks,
JB

>
>
>>
>> Christian.
>>
>>
>>>
>>>> ---
>>>>   drivers/gpu/drm/radeon/cik.c | 48
>>>> ++++++++++++++++++++++----------------------
>>>>   1 file changed, 24 insertions(+), 24 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/radeon/cik.c
>>>> b/drivers/gpu/drm/radeon/cik.c index 4bfc2c0..e0c8052 100644
>>>> --- a/drivers/gpu/drm/radeon/cik.c
>>>> +++ b/drivers/gpu/drm/radeon/cik.c
>>>> @@ -4662,12 +4662,11 @@ static int cik_mec_init(struct radeon_device
>>>> *rdev)
>>>>         /*
>>>>          * KV:    2 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 64 Queues total
>>>>          * CI/KB: 1 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 32 Queues
>>>> total
>>>> +        * Nonetheless, we assign only 1 pipe because all other
>>>> + pipes
>>>> will
>>>> +        * be handled by KFD
>>>>          */
>>>> -       if (rdev->family == CHIP_KAVERI)
>>>> -               rdev->mec.num_mec = 2;
>>>> -       else
>>>> -               rdev->mec.num_mec = 1;
>>>> -       rdev->mec.num_pipe = 4;
>>>> +       rdev->mec.num_mec = 1;
>>>> +       rdev->mec.num_pipe = 1;
>>>>         rdev->mec.num_queue = rdev->mec.num_mec * rdev-
>>mec.num_pipe * 8;
>>>>         if (rdev->mec.hpd_eop_obj == NULL) { @@ -4809,28 +4808,24 @@
>>>> static int cik_cp_compute_resume(struct radeon_device *rdev)
>>>>         /* init the pipes */
>>>>         mutex_lock(&rdev->srbm_mutex);
>>>> -       for (i = 0; i < (rdev->mec.num_pipe * rdev->mec.num_mec); i++) {
>>>> -               int me = (i < 4) ? 1 : 2;
>>>> -               int pipe = (i < 4) ? i : (i - 4);
>>>>   -             eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr + (i *
>>>> MEC_HPD_SIZE * 2);
>>>> +       eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr;
>>>>   -             cik_srbm_select(rdev, me, pipe, 0, 0);
>>>> +       cik_srbm_select(rdev, 0, 0, 0, 0);
>>>>   -             /* write the EOP addr */
>>>> -               WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
>>>> -               WREG32(CP_HPD_EOP_BASE_ADDR_HI,
>>>> upper_32_bits(eop_gpu_addr) >> 8);
>>>> +       /* write the EOP addr */
>>>> +       WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
>>>> +       WREG32(CP_HPD_EOP_BASE_ADDR_HI,
>upper_32_bits(eop_gpu_addr)
>>>> + >>
>>>> 8);
>>>>   -             /* set the VMID assigned */
>>>> -               WREG32(CP_HPD_EOP_VMID, 0);
>>>> +       /* set the VMID assigned */
>>>> +       WREG32(CP_HPD_EOP_VMID, 0);
>>>> +
>>>> +       /* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
>>>> +       tmp = RREG32(CP_HPD_EOP_CONTROL);
>>>> +       tmp &= ~EOP_SIZE_MASK;
>>>> +       tmp |= order_base_2(MEC_HPD_SIZE / 8);
>>>> +       WREG32(CP_HPD_EOP_CONTROL, tmp);
>>>>   -             /* set the EOP size, register value is 2^(EOP_SIZE+1)
>>>> dwords */
>>>> -               tmp = RREG32(CP_HPD_EOP_CONTROL);
>>>> -               tmp &= ~EOP_SIZE_MASK;
>>>> -               tmp |= order_base_2(MEC_HPD_SIZE / 8);
>>>> -               WREG32(CP_HPD_EOP_CONTROL, tmp);
>>>> -       }
>>>> -       cik_srbm_select(rdev, 0, 0, 0, 0);
>>>>         mutex_unlock(&rdev->srbm_mutex);
>>>>         /* init the queues.  Just two for now. */ @@ -5876,8
>>>> +5871,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct
>>>> radeon_ib *ib)
>>>>    */
>>>>   int cik_vm_init(struct radeon_device *rdev)
>>>>   {
>>>> -       /* number of VMs */
>>>> -       rdev->vm_manager.nvm = 16;
>>>> +       /*
>>>> +        * number of VMs
>>>> +        * VMID 0 is reserved for Graphics
>>>> +        * radeon compute will use VMIDs 1-7
>>>> +        * KFD will use VMIDs 8-15
>>>> +        */
>>>> +       rdev->vm_manager.nvm = 8;
>>>>         /* base offset of vram pages */
>>>>         if (rdev->flags & RADEON_IS_IGP) {
>>>>                 u64 tmp = RREG32(MC_VM_FB_OFFSET);
>>>> --
>>>> 1.9.1
>>>>
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>_______________________________________________
>dri-devel mailing list
>dri-devel@lists.freedesktop.org
>http://lists.freedesktop.org/mailman/listinfo/dri-devel
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
