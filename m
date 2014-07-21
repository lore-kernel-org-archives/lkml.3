Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbaGUR3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:29:17 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:37920
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932320AbaGUR3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:29:15 -0400
X-WSS-ID: 0N92OK6-08-4C3-02
X-M-MSG: 
Message-ID: <53CD4DD2.10906@amd.com>
Date: Mon, 21 Jul 2014 20:28:50 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Andrew Lewycky" <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
References: <53C7D645.3070607@amd.com> <20140720174652.GE3068@gmail.com>
 <53CD0961.4070505@amd.com> <53CD17FD.3000908@vodafone.de>
 <20140721152511.GW15237@phenom.ffwll.local> <20140721155851.GB4519@gmail.com>
 <20140721170546.GB15237@phenom.ffwll.local>
In-Reply-To: <20140721170546.GB15237@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.224.155.153]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(199002)(189002)(479174003)(51704005)(51404002)(52314003)(65956001)(81342001)(87936001)(47776003)(74502001)(76176999)(85306003)(21056001)(101416001)(33656002)(79102001)(20776003)(83072002)(92566001)(2201001)(97736001)(65806001)(92726001)(50986999)(54356999)(64706001)(83322001)(86362001)(107886001)(93886003)(36756003)(81542001)(77982001)(85852003)(15202345003)(64126003)(44976005)(76482001)(80022001)(4396001)(106466001)(15975445006)(68736004)(31966008)(95666004)(46102001)(102836001)(84676001)(19580405001)(65816999)(83506001)(99396002)(74662001)(23676002)(19580395003)(50466002)(107046002)(105586002)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB041;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0279B3DD0D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/14 20:05, Daniel Vetter wrote:
> On Mon, Jul 21, 2014 at 11:58:52AM -0400, Jerome Glisse wrote:
>> On Mon, Jul 21, 2014 at 05:25:11PM +0200, Daniel Vetter wrote:
>>> On Mon, Jul 21, 2014 at 03:39:09PM +0200, Christian König wrote:
>>>> Am 21.07.2014 14:36, schrieb Oded Gabbay:
>>>>> On 20/07/14 20:46, Jerome Glisse wrote:
>>>>>> On Thu, Jul 17, 2014 at 04:57:25PM +0300, Oded Gabbay wrote:
>>>>>>> Forgot to cc mailing list on cover letter. Sorry.
>>>>>>>
>>>>>>> As a continuation to the existing discussion, here is a v2 patch series
>>>>>>> restructured with a cleaner history and no
>>>>>>> totally-different-early-versions
>>>>>>> of the code.
>>>>>>>
>>>>>>> Instead of 83 patches, there are now a total of 25 patches, where 5 of
>>>>>>> them
>>>>>>> are modifications to radeon driver and 18 of them include only amdkfd
>>>>>>> code.
>>>>>>> There is no code going away or even modified between patches, only
>>>>>>> added.
>>>>>>>
>>>>>>> The driver was renamed from radeon_kfd to amdkfd and moved to reside
>>>>>>> under
>>>>>>> drm/radeon/amdkfd. This move was done to emphasize the fact that this
>>>>>>> driver
>>>>>>> is an AMD-only driver at this point. Having said that, we do foresee a
>>>>>>> generic hsa framework being implemented in the future and in that
>>>>>>> case, we
>>>>>>> will adjust amdkfd to work within that framework.
>>>>>>>
>>>>>>> As the amdkfd driver should support multiple AMD gfx drivers, we want
>>>>>>> to
>>>>>>> keep it as a seperate driver from radeon. Therefore, the amdkfd code is
>>>>>>> contained in its own folder. The amdkfd folder was put under the radeon
>>>>>>> folder because the only AMD gfx driver in the Linux kernel at this
>>>>>>> point
>>>>>>> is the radeon driver. Having said that, we will probably need to move
>>>>>>> it
>>>>>>> (maybe to be directly under drm) after we integrate with additional
>>>>>>> AMD gfx
>>>>>>> drivers.
>>>>>>>
>>>>>>> For people who like to review using git, the v2 patch set is located
>>>>>>> at:
>>>>>>> http://cgit.freedesktop.org/~gabbayo/linux/log/?h=kfd-next-3.17-v2
>>>>>>>
>>>>>>> Written by Oded Gabbayh <oded.gabbay@amd.com>
>>>>>>
>>>>>> So quick comments before i finish going over all patches. There is many
>>>>>> things that need more documentation espacialy as of right now there is
>>>>>> no userspace i can go look at.
>>>>> So quick comments on some of your questions but first of all, thanks for
>>>>> the time you dedicated to review the code.
>>>>>>
>>>>>> There few show stopper, biggest one is gpu memory pinning this is a big
>>>>>> no, that would need serious arguments for any hope of convincing me on
>>>>>> that side.
>>>>> We only do gpu memory pinning for kernel objects. There are no userspace
>>>>> objects that are pinned on the gpu memory in our driver. If that is the
>>>>> case, is it still a show stopper ?
>>>>>
>>>>> The kernel objects are:
>>>>> - pipelines (4 per device)
>>>>> - mqd per hiq (only 1 per device)
>>>>> - mqd per userspace queue. On KV, we support up to 1K queues per process,
>>>>> for a total of 512K queues. Each mqd is 151 bytes, but the allocation is
>>>>> done in 256 alignment. So total *possible* memory is 128MB
>>>>> - kernel queue (only 1 per device)
>>>>> - fence address for kernel queue
>>>>> - runlists for the CP (1 or 2 per device)
>>>>
>>>> The main questions here are if it's avoid able to pin down the memory and if
>>>> the memory is pinned down at driver load, by request from userspace or by
>>>> anything else.
>>>>
>>>> As far as I can see only the "mqd per userspace queue" might be a bit
>>>> questionable, everything else sounds reasonable.
>>>
>>> Aside, i915 perspective again (i.e. how we solved this): When scheduling
>>> away from contexts we unpin them and put them into the lru. And in the
>>> shrinker we have a last-ditch callback to switch to a default context
>>> (since you can't ever have no context once you've started) which means we
>>> can evict any context object if it's getting in the way.
>>
>> So Intel hardware report through some interrupt or some channel when it is
>> not using a context ? ie kernel side get notification when some user context
>> is done executing ?
> 
> Yes, as long as we do the scheduling with the cpu we get interrupts for
> context switches. The mechanic is already published in the execlist
> patches currently floating around. We get a special context switch
> interrupt.
> 
> But we have this unpin logic already on the current code where we switch
> contexts through in-line cs commands from the kernel. There we obviously
> use the normal batch completion events.
> 
>> The issue with radeon hardware AFAICT is that the hardware do not report any
>> thing about the userspace context running ie you do not get notification when
>> a context is not use. Well AFAICT. Maybe hardware do provide that.
> 
> I'm not sure whether we can do the same trick with the hw scheduler. But
> then unpinning hw contexts will drain the pipeline anyway, so I guess we
> can just stop feeding the hw scheduler until it runs dry. And then unpin
> and evict.
So, I'm afraid but we can't do this for AMD Kaveri because:

a. The hw scheduler doesn't inform us which queues it is going to
execute next. We feed it a runlist of queues, which can be very large
(we have a test that runs 1000 queues on the same runlist, but we can
put a lot more). All the MQDs of those queues must be pinned in memory
as long as the runlist is in effect. The runlist is in effect until
either a queue is deleted or a queue is added (or something more extreme
happens, like the process terminates).

b. The hw scheduler takes care of VMID to PASID mapping. We don't
program the ATC registers manually, the internal CP does that
dynamically, so we basically have over-subscription of processes as
well. Therefore, we can't ping MQDs based on VMID binding.

I don't see AMD moving back to SW scheduling, as it doesn't scale well
with the number of processes and queues and our next gen APU will have a
lot more queues than what we have on KV

	Oded
> 
>> Like the VMID is a limited resources so you have to dynamicly bind them so
>> maybe we can only allocate pinned buffer for each VMID and then when binding
>> a PASID to a VMID it also copy back pinned buffer to pasid unpinned copy.
> 
> Yeah, pasid assignment will be fun. Not sure whether Jesse's patches will
> do this already. We _do_ already have fun with ctx id assigments though
> since we move them around (and the hw id is the ggtt address afaik). So we
> need to remap them already. Not sure on the details for pasid mapping,
> iirc it's a separate field somewhere in the context struct. Jesse knows
> the details.
> -Daniel
> 

