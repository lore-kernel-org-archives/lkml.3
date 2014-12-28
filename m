Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaL1Lhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 06:37:32 -0500
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:31664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751861AbaL1LhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 06:37:25 -0500
X-WSS-ID: 0NHAIY4-08-FFL-02
X-M-MSG: 
Message-ID: <549FEB52.4020103@amd.com>
Date: Sun, 28 Dec 2014 13:36:50 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        <iommu@lists.linux-foundation.org>,
        =?windows-1252?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        "Arnd Bergmann" <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 0/2] Change order of linkage in kernel makefiles for amdkfd
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
 <20141225132058.GA32005@mithrandir> <1621810.aTt9O4Ghzs@avalon>
In-Reply-To: <1621810.aTt9O4Ghzs@avalon>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(479174004)(51444003)(24454002)(199003)(377454003)(51704005)(106466001)(77096005)(2950100001)(76176999)(62966003)(86362001)(54356999)(33656002)(80316001)(19580395003)(36756003)(50466002)(59896002)(105586002)(68736005)(23746002)(15975445007)(107046002)(77156002)(97736003)(99396003)(47776003)(64706001)(20776003)(21056001)(65956001)(101416001)(87266999)(84676001)(120916001)(4396001)(31966008)(65806001)(50986999)(46102003)(92566001)(87936001)(83506001)(129583001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR02MB204;
X-Forefront-PRVS: 0439571D1D
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2014 11:37:19.7098
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR02MB204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/26/2014 11:19 AM, Laurent Pinchart wrote:
> Hi Thierry,
>
> On Thursday 25 December 2014 14:20:59 Thierry Reding wrote:
>> On Mon, Dec 22, 2014 at 01:07:13PM +0200, Oded Gabbay wrote:
>>> This small patch-set, was created to solve the bug described at
>>> https://bugzilla.kernel.org/show_bug.cgi?id=89661 (Kernel panic when
>>> trying use amdkfd driver on Kaveri). It replaces the previous patch-set
>>> called [PATCH 0/3] Use workqueue for device init in amdkfd
>>> (http://lists.freedesktop.org/archives/dri-devel/2014-December/074401.html
>>> )
>>>
>>> That bug appears only when radeon, amdkfd and amd_iommu_v2 are compiled
>>> inside the kernel (not as modules). In that case, the correct loading
>>> order, as determined by the exported symbol used by each driver, is
>>> not enforced anymore and the kernel loads them based on who was linked
>>> first. That makes radeon load first, amdkfd second and amd_iommu_v2
>>> third.
>>>
>>> Because the initialization of a device in amdkfd is initiated by radeon,
>>> and can only be completed if amdkfd and amd_iommu_v2 were loaded and
>>> initialized, then in the case mentioned above, this initalization fails
>>> and there is a kernel panic as some pointers are not initialized but
>>> used nontheless.
>>>
>>> To solve this bug, this patch-set moves iommu/ before gpu/ in
>>> drivers/Makefile and also moves amdkfd/ before radeon/ in
>>> drivers/gpu/drm/Makefile.
>>>
>>> The rationale is that in general, AMD GPU devices are dependent on AMD
>>> IOMMU controller functionality to allow the GPU to access a process's
>>> virtual memory address space, without the need for pinning the memory.
>>> That's why it makes sense to initialize the iommu/ subsystem ahead of the
>>> gpu/ subsystem.
>>
>> I strongly object to this patch set. This makes assumptions about how
>> the build system influences probe order. That's bad because seemingly
>> unrelated changes could easily break this in the future.
>>
>> We already have ways to solve this kind of dependency (driver probe
>> deferral), and I think you should be using it to solve this particular
>> problem rather than some linking order hack.
>
> While I agree with you that probe deferral is the way to go, I believe linkage
> ordering can still be used as an optimization to avoid deferring probe in the
> most common cases. I'm thus not opposed to moving iommu/ earlier in link order
> (provided we can properly test for side effects, as the jump is pretty large),
> but not as a replacement for probe deferral.

My thoughts exactly. If this was some extreme use case, than it would be 
justified to solve it with probe deferral. But I think that for most common 
cases, GPU are dependent on IOMMU and *not* vice-versa.

BTW, my first try at solving this was to use probe deferral (using workqueue), 
but the feedback I got from Christian and Dave was that moving iommu/ linkage 
before gpu/ was a much more simpler solution.

In addition, Linus said he doesn't object to this "band-aid". See: 
https://lkml.org/lkml/2014/12/25/152

	Oded
>
>> Coincidentally there's a separate thread currently going on that deals
>> with IOMMUs and probe order. The solution being worked on is currently
>> somewhat ARM-specific, so adding a couple of folks for visibility. It
>> looks like we're going to need something more generic since this is a
>> problem that even the "big" architectures need to solve.
>
