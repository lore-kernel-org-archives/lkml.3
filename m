Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaLVHfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:35:00 -0500
Received: from mail-bl2on0107.outbound.protection.outlook.com ([65.55.169.107]:44529
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110AbaLVHe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:34:58 -0500
X-WSS-ID: 0NGZ3Q6-07-YR7-02
X-M-MSG: 
Message-ID: <5497C98C.2080208@amd.com>
Date: Mon, 22 Dec 2014 09:34:36 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        <dri-devel@lists.freedesktop.org>
CC: <Alexander.Deucher@amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, "Elifaz, Dana" <Dana.Elifaz@amd.com>
Subject: Re: [PATCH 1/3] amdkfd: Don't clear *kfd2kgd on kfd_module_init
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
 <1419108374-7020-2-git-send-email-oded.gabbay@amd.com>
 <5496AEAD.3090003@vodafone.de> <5496B04C.50502@amd.com>
 <5496BAE0.5090901@vodafone.de> <5496C5EA.7050200@amd.com>
 <5496CA0F.8000800@amd.com> <5496EDF1.7080106@vodafone.de>
 <5496EF34.70302@amd.com> <5496F0DD.40903@vodafone.de>
In-Reply-To: <5496F0DD.40903@vodafone.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(199003)(189002)(51704005)(24454002)(479174004)(64706001)(107046002)(4396001)(101416001)(54356999)(50986999)(31966008)(93886004)(50466002)(65956001)(21056001)(15395725005)(47776003)(86362001)(20776003)(65806001)(23676002)(19580405001)(80316001)(83506001)(59896002)(33656002)(19580395003)(105586002)(106466001)(97736003)(46102003)(68736005)(2950100001)(92566001)(76176999)(77096005)(84676001)(87936001)(64126003)(62966003)(77156002)(99396003)(1720100001)(36756003)(87266999)(120916001)(15975445007)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB199;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB199;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 07:34:55.4305
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB199
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/21/2014 06:10 PM, Christian König wrote:
> Am 21.12.2014 um 17:03 schrieb Oded Gabbay:
>>
>>
>> On 12/21/2014 05:57 PM, Christian König wrote:
>>>> There should be, but when the modules are compiled in, they are loaded based on
>>>> link order only, if they are in the same group, and the groups are loaded by a
>>>> pre-defined order.
>>> Is that really still up to date? I've seen effort to change that something like
>>> 10+ years ago when Rusty reworked the module system. And it is comming up on the
>>> lists again from time to time.
>> From what I can see in the Makefile rules, code and google, yes, that's still
>> the situation. If someone will prove me wrong I will be more than happy to
>> correct my code.
>>>
>>>> I don't want to move iommu before gpu, so I don't have a solution for the
>>>> order between amdkfd and amd_iommu_v2.
>>> Why not? That's still better than creating a kernel workqueue, scheduling one
>>> work item on it, rescheduling the task until everything is completed and you can
>>> continue.
>> Because I don't know the consequences of moving an entire subsystem in front
>> of another one. In addition, even if everyone agrees, I'm pretty sure that
>> Linus won't be happy to do that in -rc stages. So maybe this is something to
>> consider for 3.20 merge window, but I would still like to provide a solution
>> for 3.19.
>
> Yeah, true indeed. How about depending on everything being compiled as module
> for 3.19 then? Still better than having such a hack in the driver for as a
> temporary workaround for one release.
>
I thought about it, but because this problem was originally reported by a user 
that told us he couldn't use modules because of his setup, I decided not to.
I assume there are other users out there who needs this option (compiled 
everything in the kernel - embedded ?), so I don't want to make their life harder.

In addition, saying it is a workaround for one release is true in case moving 
iommu subsystem in front of gpu subsystem is acceptable and doesn't cause other 
problems, unknown at this point.

Bottom line, my personal preference is to help the users _now_ and if a better 
fix is found in the future, change the code accordingly.

	Oded

> Christian.
>
>>
>>     Oded
>>>
>>> Christian.
>>>
>>> Am 21.12.2014 um 14:24 schrieb Oded Gabbay:
>>>>
>>>>
>>>> On 12/21/2014 03:06 PM, Oded Gabbay wrote:
>>>>>
>>>>>
>>>>> On 12/21/2014 02:19 PM, Christian König wrote:
>>>>>> Am 21.12.2014 um 12:34 schrieb Oded Gabbay:
>>>>>>>
>>>>>>>
>>>>>>> On 12/21/2014 01:27 PM, Christian König wrote:
>>>>>>>> Am 20.12.2014 um 21:46 schrieb Oded Gabbay:
>>>>>>>>> When amdkfd and radeon are compiled inside the kernel image (not as
>>>>>>>>> modules),
>>>>>>>>> radeon will load before amdkfd and will set *kfd2kgd to its interface
>>>>>>>>> structure. Therefore, we must not set *kfd2kgd to NULL when amdkfd is
>>>>>>>>> loaded
>>>>>>>>> because it will override radeon's initialization and cause kernel BUG.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
>>>>>>>>
>>>>>>>> You should probably rather fix the dependency between the two modules to
>>>>>>>> get an
>>>>>>>> determined load order instead of doing such nasty workarounds.
>>>>>>>>
>>>>>>>> Christian.
>>>>>>>
>>>>>>> The problem is that when modules are compiled inside the kernel, there is NO
>>>>>>> determined load order and there is no mechanism to enforce that. If there
>>>>>>> is/was such a mechanism, I would of course prefer to use it.
>>>>>>
>>>>>> There should be an determined order based on the symbol use, otherwise
>>>>>> initializing most of the kernel modules wouldn't work as expected. For
>>>>>> example
>>>>>> radeon depends on the drm module must be loaded before radeon is loaded.
>>>>> There should be, but when the modules are compiled in, they are loaded
>>>>> based on
>>>>> link order only, if they are in the same group, and the groups are loaded by a
>>>>> pre-defined order.
>>>>> The groups are: pure, core, postcore, arch, subsys, fs, device (which
>>>>> represents
>>>>> all the modules) and late. See init.h
>>>>>
>>>>> So radeon, amdkfd and amd_iommu_v2 are all in device group, and in the group
>>>>> they are ordered by their link order.
>>>>>
>>>>> Yes, radeon loads after drm, because drm*.o are before radeon*.o in the
>>>>> Makefile. See
>>>>> http://stackoverflow.com/questions/5669647/linux-order-of-statically-linked-module-loading
>>>>>
>>>>>
>>>>>
>>>>
>>>> So I tried moving amdkfd inside the Makefile before radeon, and that made
>>>> amdkfd load before radeon did. This solves my first problem - order between
>>>> amdkfd and radeon. However, amd_iommu_v2 doesn't belong to the drm Makefile,
>>>> and I don't want to move iommu before gpu, so I don't have a solution for the
>>>> order between amdkfd and amd_iommu_v2.
>>>>
>>>>     Oded
>>>>>
>>>>>
>>>>>>
>>>>>>>
>>>>>>> Actually, I don't understand why the kernel doesn't enforce the order
>>>>>>> according to the use of exported symbols, like it does with modules.
>>>>>>
>>>>>> Yeah, that's indeed rather strange. There must be something in the amdkfd
>>>>>> code
>>>>>> which broke that somehow.
>>>>> IMO, that's a far-fetched guess. Could you point to something more specific ?
>>>>>
>>>>>>
>>>>>> As far as I understand you the desired init order is radeon and amd_iommu_v2
>>>>>> first and then amdkfd, right?
>>>>> Actually no. The preferred order is amd_iommu_v2, amdkfd and radeon last. This
>>>>> is the order that happens when all three are built as modules. More
>>>>> accurately,
>>>>> radeon inits, but its init triggers amdkfd init, which triggers amd_iommu_v2
>>>>> init. So before radeon reaches its probe stage, all the modules were
>>>>> initialized.
>>>>>
>>>>> So what happens when you boot with radeon,
>>>>>> amd_iommu_v2 and amdkfd blacklisted for automatically load and only load
>>>>>> amdkfd
>>>>>> manually?
>>>>> As said above, that's ok.
>>>>>>
>>>>>>> There will always be dependencies between kgd (radeon) and amdkfd and
>>>>>>> between
>>>>>>> amdkfd and amd_iommu_v2. I don't think I can eliminate those
>>>>>>> dependencies, not
>>>>>>> without a very complex solution. And the fact that this complex solution
>>>>>>> occurs only in a very specific use case (all modules compiled in), makes me
>>>>>>> less inclined to do that.
>>>>>>>
>>>>>>> So I don't see it as a "nasty workaround". I would call it just a
>>>>>>> "workaround"
>>>>>>> for a specific use case, which should be solved by a generic solution to the
>>>>>>> kernel enforcing load orders.
>>>>>>
>>>>>> The normal kernel module handling already should provide the correct init
>>>>>> order,
>>>>>> so I would still call this a rather nasty workaround because we couldn't find
>>>>>> the underlying problem.
>>>>> Well, the normal kernel module handling doesn't work when all modules are
>>>>> compiled in. I'm not a huge expert on this issue so I had Joerg Roedel help me
>>>>> analyze this (thanks Joerg) and he agreed that there is no enforcement of
>>>>> order
>>>>> in this case.
>>>>>
>>>>>>
>>>>>> Christian.
>>>>>>
>>>>>>>
>>>>>>>     Oded
>>>>>>>>
>>>>>>>>> ---
>>>>>>>>>   drivers/gpu/drm/amd/amdkfd/kfd_module.c | 5 ++---
>>>>>>>>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>>>>>>>>> b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>>>>>>>>> index 95d5af1..236562f 100644
>>>>>>>>> --- a/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>>>>>>>>> +++ b/drivers/gpu/drm/amd/amdkfd/kfd_module.c
>>>>>>>>> @@ -34,7 +34,7 @@
>>>>>>>>>   #define KFD_DRIVER_MINOR    7
>>>>>>>>>   #define KFD_DRIVER_PATCHLEVEL    0
>>>>>>>>> -const struct kfd2kgd_calls *kfd2kgd;
>>>>>>>>> +const struct kfd2kgd_calls *kfd2kgd = NULL;
>>>>>>>>>   static const struct kgd2kfd_calls kgd2kfd = {
>>>>>>>>>       .exit        = kgd2kfd_exit,
>>>>>>>>>       .probe        = kgd2kfd_probe,
>>>>>>>>> @@ -84,14 +84,13 @@ EXPORT_SYMBOL(kgd2kfd_init);
>>>>>>>>>   void kgd2kfd_exit(void)
>>>>>>>>>   {
>>>>>>>>> +    kfd2kgd = NULL;
>>>>>>>>>   }
>>>>>>>>>   static int __init kfd_module_init(void)
>>>>>>>>>   {
>>>>>>>>>       int err;
>>>>>>>>> -    kfd2kgd = NULL;
>>>>>>>>> -
>>>>>>>>>       /* Verify module parameters */
>>>>>>>>>       if ((sched_policy < KFD_SCHED_POLICY_HWS) ||
>>>>>>>>>           (sched_policy > KFD_SCHED_POLICY_NO_HWS)) {
>>>>>>>>
>>>>>>
>>>>> _______________________________________________
>>>>> dri-devel mailing list
>>>>> dri-devel@lists.freedesktop.org
>>>>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
