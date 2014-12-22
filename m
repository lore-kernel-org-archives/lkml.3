Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaLVKWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:22:42 -0500
Received: from mail-bl2on0115.outbound.protection.outlook.com ([65.55.169.115]:54816
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753977AbaLVKWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:22:41 -0500
X-WSS-ID: 0NGZBHO-07-6MJ-02
X-M-MSG: 
Message-ID: <5497F0DA.6050805@amd.com>
Date: Mon, 22 Dec 2014 12:22:18 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        "Dave Airlie" <airlied@gmail.com>
CC: "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH 1/3] amdkfd: Don't clear *kfd2kgd on kfd_module_init
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
 <1419108374-7020-2-git-send-email-oded.gabbay@amd.com>
 <5496AEAD.3090003@vodafone.de>	<5496B04C.50502@amd.com>
 <5496BAE0.5090901@vodafone.de>	<5496C5EA.7050200@amd.com>
 <5496CA0F.8000800@amd.com>	<5496EDF1.7080106@vodafone.de>
 <5496EF34.70302@amd.com>	<5496F0DD.40903@vodafone.de>
 <5497C98C.2080208@amd.com>
 <CAPM=9tzpvmu=6X32-jc4VeVTZENW9iQDq6aB1dxo6TkbkKOpkQ@mail.gmail.com>
 <5497CB91.2080306@amd.com> <5497DD0E.7040400@vodafone.de>
 <5497E3D7.1060405@amd.com>
In-Reply-To: <5497E3D7.1060405@amd.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(479174004)(199003)(24454002)(51704005)(377454003)(189002)(36756003)(97736003)(47776003)(20776003)(93886004)(21056001)(68736005)(65806001)(15975445007)(65956001)(107046002)(59896002)(4396001)(31966008)(23676002)(62966003)(1720100001)(77156002)(50466002)(64126003)(64706001)(46102003)(2950100001)(92566001)(77096005)(86362001)(87936001)(101416001)(106466001)(87266999)(54356999)(105586002)(76176999)(84676001)(83506001)(120916001)(33656002)(19580395003)(99396003)(19580405001)(80316001)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB208;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 10:22:37.3341
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/22/2014 11:26 AM, Oded Gabbay wrote:
>
>
> On 12/22/2014 10:57 AM, Christian König wrote:
>> Am 22.12.2014 um 08:43 schrieb Oded Gabbay:
>>>
>>>
>>> On 12/22/2014 09:40 AM, Dave Airlie wrote:
>>>>>>>>> There should be, but when the modules are compiled in, they are loaded
>>>>>>>>> based on
>>>>>>>>> link order only, if they are in the same group, and the groups are
>>>>>>>>> loaded by a
>>>>>>>>> pre-defined order.
>>>>>>>>
>>>>>>>> Is that really still up to date? I've seen effort to change that
>>>>>>>> something like
>>>>>>>> 10+ years ago when Rusty reworked the module system. And it is comming
>>>>>>>> up on the
>>>>>>>> lists again from time to time.
>>>>>>>
>>>>>>>  From what I can see in the Makefile rules, code and google, yes, that's
>>>>>>> still
>>>>>>> the situation. If someone will prove me wrong I will be more than happy
>>>>>>> to
>>>>>>> correct my code.
>>>>>>>>
>>>>>>>>
>>>>>>>>> I don't want to move iommu before gpu, so I don't have a solution for
>>>>>>>>> the
>>>>>>>>> order between amdkfd and amd_iommu_v2.
>>>>>>>>
>>>>>>>> Why not? That's still better than creating a kernel workqueue,
>>>>>>>> scheduling one
>>>>>>>> work item on it, rescheduling the task until everything is completed and
>>>>>>>> you can
>>>>>>>> continue.
>>>>>>>
>>>>>>> Because I don't know the consequences of moving an entire subsystem in
>>>>>>> front
>>>>>>> of another one. In addition, even if everyone agrees, I'm pretty sure
>>>>>>> that
>>>>>>> Linus won't be happy to do that in -rc stages. So maybe this is something
>>>>>>> to
>>>>>>> consider for 3.20 merge window, but I would still like to provide a
>>>>>>> solution
>>>>>>> for 3.19.
>>>>>>
>>>>>>
>>>>>> Yeah, true indeed. How about depending on everything being compiled as
>>>>>> module
>>>>>> for 3.19 then? Still better than having such a hack in the driver for as a
>>>>>> temporary workaround for one release.
>>>>>>
>>>>> I thought about it, but because this problem was originally reported by a
>>>>> user that told us he couldn't use modules because of his setup, I decided
>>>>> not to.
>>>>> I assume there are other users out there who needs this option (compiled
>>>>> everything in the kernel - embedded ?), so I don't want to make their life
>>>>> harder.
>>>>>
>>>>> In addition, saying it is a workaround for one release is true in case
>>>>> moving iommu subsystem in front of gpu subsystem is acceptable and doesn't
>>>>> cause other problems, unknown at this point.
>>>>>
>>>>> Bottom line, my personal preference is to help the users _now_ and if a
>>>>> better fix is found in the future, change the code accordingly.
>>>>
>>>> My guess is moving the iommu subsystem in front of the GPU would be rational.
>>>>
>>>> It does seem like it would generally have a depend in that order.
>>>>
>>>> Dave.
>>>>
>>> Dave,
>>> I agree, but don't you think it is too risky for -rc stages ?
>>> If not, I can try it and if it works on KV, I can submit a patch.
>>> But if you do think it is risky, what do you recommend for 3.19 ? Do the fix I
>>> suggested or disable build-in compilation option ?
>>
>> I would say create the patch of changing the order (should be trivial), describe
>> in detail in the commit message what this is supposed to fix and why such an
>> severe change was done in -rc1 and submit it upstream.
>>
>> We can still revert it in -rc2 if it breaks anything.
>>
>> Christian.
>>
>>>
>>>     Oded
>>
>
> OK, I'll try it on my machine and if it works, I will send the patch to the list.
>
>      Oded
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

So I checked it and all my HSA tests are passing on KV machine.
I will send the patches today. Please discard the current patch-set.

	Oded
