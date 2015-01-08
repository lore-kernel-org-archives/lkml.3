Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbbAHOQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:16:06 -0500
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:60928
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752422AbbAHOQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:16:03 -0500
X-WSS-ID: 0NHV3MH-08-1EQ-02
X-M-MSG: 
Message-ID: <54AE910E.5060803@amd.com>
Date: Thu, 8 Jan 2015 16:15:42 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtg==?= =?UTF-8?B?bmln?= 
	<christian.koenig@amd.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        "Alexander Deucher" <Alexander.Deucher@amd.com>,
        <iommu@lists.linux-foundation.org>, "Arnd Bergmann" <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/2] Change order of linkage in kernel makefiles for amdkfd
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
 <1621810.aTt9O4Ghzs@avalon> <549FEB52.4020103@amd.com>
 <1678486.9ZXZnn5och@avalon> <54A12028.7020303@amd.com>
 <20150105154657.GJ12010@ulmo.nvidia.com>
In-Reply-To: <20150105154657.GJ12010@ulmo.nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(51444003)(51704005)(479174004)(377454003)(199003)(24454002)(92566001)(101416001)(33656002)(4396001)(106466001)(59896002)(76176999)(23676002)(105586002)(93886004)(87266999)(50986999)(65816999)(54356999)(99396003)(84676001)(21056001)(87936001)(107046002)(36756003)(120916001)(83506001)(80316001)(19580395003)(68736005)(77096005)(64706001)(47776003)(20776003)(65806001)(97736003)(50466002)(62966003)(65956001)(64126003)(86362001)(77156002)(2950100001)(31966008)(46102003)(15975445007)(129583001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB208;
X-Forefront-PRVS: 0450A714CB
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2015 14:15:57.8828
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,
Generally I agree with the issues you describe in the current design.
One task in our 2015 workplan is to change the whole method amdkfd is loaded, so 
it can independently load at any time, regardless of the order of loading 
between it and radeon and amd_iommu_v2. To reach that goal, I assume we will 
have to use some form of deferred probing.

However, for the moment, this is the best band-aid I could think of, and 
choosing between this band-aid or no band-aid at all, I prefer the former any day.

	Oded


On 01/05/2015 05:46 PM, Thierry Reding wrote:
> On Mon, Dec 29, 2014 at 10:34:32AM +0100, Christian König wrote:
>> Am 29.12.2014 um 09:16 schrieb Laurent Pinchart:
>>> Hi Oded,
>>>
>>> On Sunday 28 December 2014 13:36:50 Oded Gabbay wrote:
>>>> On 12/26/2014 11:19 AM, Laurent Pinchart wrote:
>>>>> On Thursday 25 December 2014 14:20:59 Thierry Reding wrote:
>>>>>> On Mon, Dec 22, 2014 at 01:07:13PM +0200, Oded Gabbay wrote:
>>>>>>> This small patch-set, was created to solve the bug described at
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=89661 (Kernel panic when
>>>>>>> trying use amdkfd driver on Kaveri). It replaces the previous patch-set
>>>>>>> called [PATCH 0/3] Use workqueue for device init in amdkfd
>>>>>>> (http://lists.freedesktop.org/archives/dri-devel/2014-December/074401.ht
>>>>>>> ml)
>>>>>>>
>>>>>>> That bug appears only when radeon, amdkfd and amd_iommu_v2 are compiled
>>>>>>> inside the kernel (not as modules). In that case, the correct loading
>>>>>>> order, as determined by the exported symbol used by each driver, is
>>>>>>> not enforced anymore and the kernel loads them based on who was linked
>>>>>>> first. That makes radeon load first, amdkfd second and amd_iommu_v2
>>>>>>> third.
>>>>>>>
>>>>>>> Because the initialization of a device in amdkfd is initiated by radeon,
>>>>>>> and can only be completed if amdkfd and amd_iommu_v2 were loaded and
>>>>>>> initialized, then in the case mentioned above, this initalization fails
>>>>>>> and there is a kernel panic as some pointers are not initialized but
>>>>>>> used nontheless.
>>>>>>>
>>>>>>> To solve this bug, this patch-set moves iommu/ before gpu/ in
>>>>>>> drivers/Makefile and also moves amdkfd/ before radeon/ in
>>>>>>> drivers/gpu/drm/Makefile.
>>>>>>>
>>>>>>> The rationale is that in general, AMD GPU devices are dependent on AMD
>>>>>>> IOMMU controller functionality to allow the GPU to access a process's
>>>>>>> virtual memory address space, without the need for pinning the memory.
>>>>>>> That's why it makes sense to initialize the iommu/ subsystem ahead of
>>>>>>> the gpu/ subsystem.
>>>>>> I strongly object to this patch set. This makes assumptions about how
>>>>>> the build system influences probe order. That's bad because seemingly
>>>>>> unrelated changes could easily break this in the future.
>>>>>>
>>>>>> We already have ways to solve this kind of dependency (driver probe
>>>>>> deferral), and I think you should be using it to solve this particular
>>>>>> problem rather than some linking order hack.
>>>>> While I agree with you that probe deferral is the way to go, I believe
>>>>> linkage ordering can still be used as an optimization to avoid deferring
>>>>> probe in the most common cases. I'm thus not opposed to moving iommu/
>>>>> earlier in link order (provided we can properly test for side effects, as
>>>>> the jump is pretty large), but not as a replacement for probe deferral.
>>>> My thoughts exactly. If this was some extreme use case, than it would be
>>>> justified to solve it with probe deferral. But I think that for most common
>>>> cases, GPU are dependent on IOMMU and *not* vice-versa.
>>
>> Fixing this through deferred probing sounds like the correct long term
>> solution to me as well.
>>
>> But what Thierry is referring to here is probably the approach of returning
>> -EAGAIN from the probe method (at least that was the last status when I
>> looked into this).
>
> -EPROBE_DEFER would be the one that I was referring to.
>
>> The problem with this approach is the interface design between radeon and
>> amdkfd. amdkfd simply doesn't have a probe method which gets called when the
>> hardware is detected and can return -EAGAIN. Instead amdkfd is called by
>> radeon after hardware initialization when it is way to late for such a
>> thing.
>
> That sounds like a pretty brittle design. It sounds like nowhere in the
> code you've encoded this dependency and you rely on symbols only to
> ensure probe ordering.
>
> Couldn't you simply make radeon check for availability of the IOMMU
> early and defer probing if it's not there yet? Or if radeon depends on
> the IOMMU via amdkfd, then perhaps calling into amdkfd to check for the
> availability of the IOMMU would be a more correct representation of the
> dependency.
>
>>>> BTW, my first try at solving this was to use probe deferral (using
>>>> workqueue), but the feedback I got from Christian and Dave was that moving
>>>> iommu/ linkage before gpu/ was a much more simpler solution.
>>> To clarify my position, I believe changing the link order can be a worthwhile
>>> optimization, but I'm uncertain about the long term viability of that change
>>> as a fix. Probe deferral has been introduced because not all probe ordering
>>> issues can be fixed through link ordering, so we should fix the problem
>>> properly.
>>>
>>> This being said, if modifying the link order can help for now without
>>> introducing negative side effects, it would only postpone the real fix, so I'm
>>> not opposed to it.
>>
>> Yeah, that sounds like the right approach to me as well.
>
> I don't think that's a good approach at all. It doesn't encode the
> dependency anywhere. All you have is some Makefile that lists a bunch of
> directories. What happens if anybody was to change that order for some
> other reason? If you're not Cc'ed on the patch and nobody else NAK's it
> because they are accidentally aware of the dependency that patch is
> going to break radeon.
>
>> In general I would prefer that modules compiled into the kernel load
>> by the order of their symbol dependency just like standalone modules
>> do.
>
> That I generally agree with. But it can't be a replacement for properly
> describing the runtime dependencies between modules. There can be other
> reasons than link order that influence probe ordering. What if the IOMMU
> driver for some reason gains deferred probe support and therefore
> doesn't succeed on the first probe? Or only sometimes.
>
> Properly describing the dependency is the only way to prevent any of
> that.
>
> Thierry
>


