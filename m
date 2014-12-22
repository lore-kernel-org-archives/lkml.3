Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaLVHnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:43:41 -0500
Received: from mail-by2on0108.outbound.protection.outlook.com ([207.46.100.108]:39276
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753184AbaLVHng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:43:36 -0500
X-WSS-ID: 0NGZ44F-08-4F0-02
X-M-MSG: 
Message-ID: <5497CB91.2080306@amd.com>
Date: Mon, 22 Dec 2014 09:43:13 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] amdkfd: Don't clear *kfd2kgd on kfd_module_init
References: <1419108374-7020-1-git-send-email-oded.gabbay@amd.com>
	<1419108374-7020-2-git-send-email-oded.gabbay@amd.com>
	<5496AEAD.3090003@vodafone.de>	<5496B04C.50502@amd.com>
	<5496BAE0.5090901@vodafone.de>	<5496C5EA.7050200@amd.com>
	<5496CA0F.8000800@amd.com>	<5496EDF1.7080106@vodafone.de>
	<5496EF34.70302@amd.com>	<5496F0DD.40903@vodafone.de>
	<5497C98C.2080208@amd.com>
 <CAPM=9tzpvmu=6X32-jc4VeVTZENW9iQDq6aB1dxo6TkbkKOpkQ@mail.gmail.com>
In-Reply-To: <CAPM=9tzpvmu=6X32-jc4VeVTZENW9iQDq6aB1dxo6TkbkKOpkQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(24454002)(377454003)(479174004)(189002)(199003)(46102003)(97736003)(101416001)(120916001)(21056001)(54356999)(99396003)(76176999)(93886004)(59896002)(50986999)(87266999)(50466002)(62966003)(87936001)(20776003)(1411001)(64706001)(77156002)(33656002)(2950100001)(4396001)(83506001)(65956001)(65806001)(68736005)(77096005)(64126003)(84676001)(31966008)(47776003)(80316001)(106466001)(92566001)(110136001)(23676002)(36756003)(86362001)(105586002)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 07:43:32.7659
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/22/2014 09:40 AM, Dave Airlie wrote:
>>>>>> There should be, but when the modules are compiled in, they are loaded
>>>>>> based on
>>>>>> link order only, if they are in the same group, and the groups are
>>>>>> loaded by a
>>>>>> pre-defined order.
>>>>>
>>>>> Is that really still up to date? I've seen effort to change that
>>>>> something like
>>>>> 10+ years ago when Rusty reworked the module system. And it is comming
>>>>> up on the
>>>>> lists again from time to time.
>>>>
>>>>  From what I can see in the Makefile rules, code and google, yes, that's
>>>> still
>>>> the situation. If someone will prove me wrong I will be more than happy
>>>> to
>>>> correct my code.
>>>>>
>>>>>
>>>>>> I don't want to move iommu before gpu, so I don't have a solution for
>>>>>> the
>>>>>> order between amdkfd and amd_iommu_v2.
>>>>>
>>>>> Why not? That's still better than creating a kernel workqueue,
>>>>> scheduling one
>>>>> work item on it, rescheduling the task until everything is completed and
>>>>> you can
>>>>> continue.
>>>>
>>>> Because I don't know the consequences of moving an entire subsystem in
>>>> front
>>>> of another one. In addition, even if everyone agrees, I'm pretty sure
>>>> that
>>>> Linus won't be happy to do that in -rc stages. So maybe this is something
>>>> to
>>>> consider for 3.20 merge window, but I would still like to provide a
>>>> solution
>>>> for 3.19.
>>>
>>>
>>> Yeah, true indeed. How about depending on everything being compiled as
>>> module
>>> for 3.19 then? Still better than having such a hack in the driver for as a
>>> temporary workaround for one release.
>>>
>> I thought about it, but because this problem was originally reported by a
>> user that told us he couldn't use modules because of his setup, I decided
>> not to.
>> I assume there are other users out there who needs this option (compiled
>> everything in the kernel - embedded ?), so I don't want to make their life
>> harder.
>>
>> In addition, saying it is a workaround for one release is true in case
>> moving iommu subsystem in front of gpu subsystem is acceptable and doesn't
>> cause other problems, unknown at this point.
>>
>> Bottom line, my personal preference is to help the users _now_ and if a
>> better fix is found in the future, change the code accordingly.
>
> My guess is moving the iommu subsystem in front of the GPU would be rational.
>
> It does seem like it would generally have a depend in that order.
>
> Dave.
>
Dave,
I agree, but don't you think it is too risky for -rc stages ?
If not, I can try it and if it works on KV, I can submit a patch.
But if you do think it is risky, what do you recommend for 3.19 ? Do the fix I 
suggested or disable build-in compilation option ?

	Oded
