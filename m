Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaGUJfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:35:13 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:26532
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754105AbaGUJfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:35:10 -0400
X-WSS-ID: 0N922LW-08-PCE-02
X-M-MSG: 
Message-ID: <53CCDEB2.4020809@amd.com>
Date: Mon, 21 Jul 2014 11:34:42 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>, Oded Gabbay <oded.gabbay@amd.com>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
References: <53C7D645.3070607@amd.com> <20140720174652.GE3068@gmail.com>
 <20140721070128.GU15237@phenom.ffwll.local>
In-Reply-To: <20140721070128.GU15237@phenom.ffwll.local>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.155.138]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(24454002)(189002)(199002)(54356999)(80022001)(99396002)(15975445006)(76176999)(33656002)(102836001)(15202345003)(65816999)(92566001)(31966008)(106466001)(105586002)(92726001)(21056001)(97736001)(65956001)(64706001)(101416001)(83506001)(84676001)(85306003)(86362001)(20776003)(23756003)(81542001)(81342001)(50986999)(19580395003)(46102001)(68736004)(19580405001)(83322001)(107886001)(83072002)(59896001)(77982001)(74502001)(87936001)(107046002)(79102001)(4396001)(85852003)(47776003)(2201001)(87266999)(76482001)(44976005)(50466002)(95666004)(74662001)(36756003)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB048;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0279B3DD0D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 21.07.2014 09:01, schrieb Daniel Vetter:
> On Sun, Jul 20, 2014 at 01:46:53PM -0400, Jerome Glisse wrote:
>> On Thu, Jul 17, 2014 at 04:57:25PM +0300, Oded Gabbay wrote:
>>> Forgot to cc mailing list on cover letter. Sorry.
>>>
>>> As a continuation to the existing discussion, here is a v2 patch series
>>> restructured with a cleaner history and no totally-different-early-versions
>>> of the code.
>>>
>>> Instead of 83 patches, there are now a total of 25 patches, where 5 of them
>>> are modifications to radeon driver and 18 of them include only amdkfd code.
>>> There is no code going away or even modified between patches, only added.
>>>
>>> The driver was renamed from radeon_kfd to amdkfd and moved to reside under
>>> drm/radeon/amdkfd. This move was done to emphasize the fact that this driver
>>> is an AMD-only driver at this point. Having said that, we do foresee a
>>> generic hsa framework being implemented in the future and in that case, we
>>> will adjust amdkfd to work within that framework.
>>>
>>> As the amdkfd driver should support multiple AMD gfx drivers, we want to
>>> keep it as a seperate driver from radeon. Therefore, the amdkfd code is
>>> contained in its own folder. The amdkfd folder was put under the radeon
>>> folder because the only AMD gfx driver in the Linux kernel at this point
>>> is the radeon driver. Having said that, we will probably need to move it
>>> (maybe to be directly under drm) after we integrate with additional AMD gfx
>>> drivers.
>>>
>>> For people who like to review using git, the v2 patch set is located at:
>>> http://cgit.freedesktop.org/~gabbayo/linux/log/?h=kfd-next-3.17-v2
>>>
>>> Written by Oded Gabbayh <oded.gabbay@amd.com>
>> So quick comments before i finish going over all patches. There is many
>> things that need more documentation espacialy as of right now there is
>> no userspace i can go look at.
>>
>> There few show stopper, biggest one is gpu memory pinning this is a big
>> no, that would need serious arguments for any hope of convincing me on
>> that side.
>>
>> It might be better to add a drivers/gpu/drm/amd directory and add common
>> stuff there.
>>
>> Given that this is not intended to be final HSA api AFAICT then i would
>> say this far better to avoid the whole kfd module and add ioctl to radeon.
>> This would avoid crazy communication btw radeon and kfd.
>>
>> The whole aperture business needs some serious explanation. Especialy as
>> you want to use userspace address there is nothing to prevent userspace
>> program from allocating things at address you reserve for lds, scratch,
>> ... only sane way would be to move those lds, scratch inside the virtual
>> address reserved for kernel (see kernel memory map).
>>
>> The whole business of locking performance counter for exclusive per process
>> access is a big NO. Which leads me to the questionable usefullness of user
>> space command ring. I only see issues with that. First and foremost i would
>> need to see solid figures that kernel ioctl or syscall has a higher an
>> overhead that is measurable in any meaning full way against a simple
>> function call. I know the userspace command ring is a big marketing features
>> that please ignorant userspace programmer. But really this only brings issues
>> and for absolutely not upside afaict.
>>
>> So i would rather see a very simple ioctl that write the doorbell and might
>> do more than that in case of ring/queue overcommit where it would first have
>> to wait for a free ring/queue to schedule stuff. This would also allow sane
>> implementation of things like performance counter that could be acquire by
>> kernel for duration of a job submitted by userspace. While still not optimal
>> this would be better that userspace locking.
> Quick aside and mostly off the record: In i915 we plan to have the first
> implementation exactly as Jerome suggests here:
> - New flag at context creationg for svm/seamless-gpgpu contexts.
> - New ioctl in i915 for submitting stuff to the hw (through doorbell or
>    whatever else we want to do). The ring in the ctx would be under the
>    kernel's control.

And looking at the existing Radeon code, that's exactly what we are 
already doing with the compute queues on CIK as well. We just use the 
existing command submission interface, cause when you use an IOCTL 
anyway it's not beneficial any more to do all the complex scheduling and 
other stuff directly on the hardware.

What's mostly missing in the existing module is proper support for 
accessing the CPU address space through IOMMUv2.

Christian.

> Of course there's lots of GEM stuff we don't need at all for such
> contexts, but there's still lots of shared code. Imo creating a 2nd driver
> has too much interface surface and so is a maintainence hell.
>
> And the ioctl submission gives us flexibility in case the hw doesn't quite
> live up to promise (e.g. scheduling, cmd parsing, ...).
> -Daniel

