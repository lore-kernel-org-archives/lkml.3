Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaL2LJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 06:09:29 -0500
Received: from mail-bn1bon0113.outbound.protection.outlook.com ([157.56.111.113]:3584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751114AbaL2LJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 06:09:27 -0500
X-WSS-ID: 0NHC7Y4-07-0NT-02
X-M-MSG: 
Message-ID: <54A12028.7020303@amd.com>
Date: Mon, 29 Dec 2014 10:34:32 +0100
From: =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Oded Gabbay <oded.gabbay@amd.com>
CC: Thierry Reding <thierry.reding@gmail.com>, David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        "Alexander Deucher" <Alexander.Deucher@amd.com>,
        <iommu@lists.linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/2] Change order of linkage in kernel makefiles for amdkfd
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
 <1621810.aTt9O4Ghzs@avalon> <549FEB52.4020103@amd.com>
 <1678486.9ZXZnn5och@avalon>
In-Reply-To: <1678486.9ZXZnn5och@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.155.179]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51444003)(199003)(51704005)(189002)(24454002)(479174004)(377454003)(20776003)(77096005)(2950100001)(50986999)(15975445007)(120916001)(77156002)(87266999)(54356999)(93886004)(23746002)(80316001)(50466002)(76176999)(4396001)(59896002)(64706001)(46102003)(21056001)(47776003)(106466001)(107046002)(97736003)(86362001)(64126003)(92566001)(62966003)(83506001)(65806001)(87936001)(68736005)(65816999)(99396003)(101416001)(84676001)(36756003)(31966008)(33656002)(19580395003)(129583001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Forefront-PRVS: 0440AC9990
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 09:34:54.1920
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.12.2014 um 09:16 schrieb Laurent Pinchart:
> Hi Oded,
>
> On Sunday 28 December 2014 13:36:50 Oded Gabbay wrote:
>> On 12/26/2014 11:19 AM, Laurent Pinchart wrote:
>>> On Thursday 25 December 2014 14:20:59 Thierry Reding wrote:
>>>> On Mon, Dec 22, 2014 at 01:07:13PM +0200, Oded Gabbay wrote:
>>>>> This small patch-set, was created to solve the bug described at
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=89661 (Kernel panic when
>>>>> trying use amdkfd driver on Kaveri). It replaces the previous patch-set
>>>>> called [PATCH 0/3] Use workqueue for device init in amdkfd
>>>>> (http://lists.freedesktop.org/archives/dri-devel/2014-December/074401.ht
>>>>> ml)
>>>>>
>>>>> That bug appears only when radeon, amdkfd and amd_iommu_v2 are compiled
>>>>> inside the kernel (not as modules). In that case, the correct loading
>>>>> order, as determined by the exported symbol used by each driver, is
>>>>> not enforced anymore and the kernel loads them based on who was linked
>>>>> first. That makes radeon load first, amdkfd second and amd_iommu_v2
>>>>> third.
>>>>>
>>>>> Because the initialization of a device in amdkfd is initiated by radeon,
>>>>> and can only be completed if amdkfd and amd_iommu_v2 were loaded and
>>>>> initialized, then in the case mentioned above, this initalization fails
>>>>> and there is a kernel panic as some pointers are not initialized but
>>>>> used nontheless.
>>>>>
>>>>> To solve this bug, this patch-set moves iommu/ before gpu/ in
>>>>> drivers/Makefile and also moves amdkfd/ before radeon/ in
>>>>> drivers/gpu/drm/Makefile.
>>>>>
>>>>> The rationale is that in general, AMD GPU devices are dependent on AMD
>>>>> IOMMU controller functionality to allow the GPU to access a process's
>>>>> virtual memory address space, without the need for pinning the memory.
>>>>> That's why it makes sense to initialize the iommu/ subsystem ahead of
>>>>> the gpu/ subsystem.
>>>> I strongly object to this patch set. This makes assumptions about how
>>>> the build system influences probe order. That's bad because seemingly
>>>> unrelated changes could easily break this in the future.
>>>>
>>>> We already have ways to solve this kind of dependency (driver probe
>>>> deferral), and I think you should be using it to solve this particular
>>>> problem rather than some linking order hack.
>>> While I agree with you that probe deferral is the way to go, I believe
>>> linkage ordering can still be used as an optimization to avoid deferring
>>> probe in the most common cases. I'm thus not opposed to moving iommu/
>>> earlier in link order (provided we can properly test for side effects, as
>>> the jump is pretty large), but not as a replacement for probe deferral.
>> My thoughts exactly. If this was some extreme use case, than it would be
>> justified to solve it with probe deferral. But I think that for most common
>> cases, GPU are dependent on IOMMU and *not* vice-versa.

Fixing this through deferred probing sounds like the correct long term 
solution to me as well.

But what Thierry is referring to here is probably the approach of 
returning -EAGAIN from the probe method (at least that was the last 
status when I looked into this).

The problem with this approach is the interface design between radeon 
and amdkfd. amdkfd simply doesn't have a probe method which gets called 
when the hardware is detected and can return -EAGAIN. Instead amdkfd is 
called by radeon after hardware initialization when it is way to late 
for such a thing.

>>
>> BTW, my first try at solving this was to use probe deferral (using
>> workqueue), but the feedback I got from Christian and Dave was that moving
>> iommu/ linkage before gpu/ was a much more simpler solution.
> To clarify my position, I believe changing the link order can be a worthwhile
> optimization, but I'm uncertain about the long term viability of that change
> as a fix. Probe deferral has been introduced because not all probe ordering
> issues can be fixed through link ordering, so we should fix the problem
> properly.
>
> This being said, if modifying the link order can help for now without
> introducing negative side effects, it would only postpone the real fix, so I'm
> not opposed to it.

Yeah, that sounds like the right approach to me as well. In general I 
would prefer that modules compiled into the kernel load by the order of 
their symbol dependency just like standalone modules do.

That's what Rusty proposed more than 10 years ago when he reworked the 
module system and I'm actually not sure why it was never done this way. 
I can only find the initial patch to do so in the mail history, but not 
why it was rejected.

Regards,
Christian.

>
>> In addition, Linus said he doesn't object to this "band-aid". See:
>> https://lkml.org/lkml/2014/12/25/152
>>
>> 	Oded
>>
>>>> Coincidentally there's a separate thread currently going on that deals
>>>> with IOMMUs and probe order. The solution being worked on is currently
>>>> somewhat ARM-specific, so adding a couple of folks for visibility. It
>>>> looks like we're going to need something more generic since this is a
>>>> problem that even the "big" architectures need to solve.

