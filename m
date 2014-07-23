Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbaGWWBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:01:55 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:59367
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933437AbaGWWBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:01:53 -0400
X-WSS-ID: 0N96QIX-08-03R-02
X-M-MSG: 
Message-ID: <53D030C5.3030207@amd.com>
Date: Thu, 24 Jul 2014 01:01:41 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Bridgman, John" <John.Bridgman@amd.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "David Airlie" <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
References: <53C7D645.3070607@amd.com> <20140720174652.GE3068@gmail.com>
 <53CD0961.4070505@amd.com> <53CD17FD.3000908@vodafone.de>
 <20140721152511.GW15237@phenom.ffwll.local> <20140721155851.GB4519@gmail.com>
 <20140721170546.GB15237@phenom.ffwll.local>
 <20140723135931.79541a86@jbarnes-desktop>
 <D89D60253BB73A4E8C62F9FD18A939CA01067410@storexdag02.amd.com>
In-Reply-To: <D89D60253BB73A4E8C62F9FD18A939CA01067410@storexdag02.amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.155.207]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51404002)(199002)(51704005)(24454002)(52314003)(13464003)(189002)(377454003)(479174003)(59896001)(46102001)(81342001)(44976005)(4396001)(83322001)(107046002)(15202345003)(64706001)(83072002)(50466002)(54356999)(101416001)(97736001)(15975445006)(105586002)(106466001)(85306003)(107886001)(86362001)(50986999)(19580395003)(76176999)(92566001)(81542001)(65806001)(80022001)(76482001)(99396002)(74502001)(95666004)(87266999)(21056001)(92726001)(65956001)(33656002)(87936001)(64126003)(85852003)(80316001)(83506001)(65816999)(36756003)(79102001)(20776003)(19580405001)(31966008)(47776003)(68736004)(23676002)(102836001)(77982001)(84676001)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB043;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/14 00:46, Bridgman, John wrote:
> 
>> -----Original Message----- From: dri-devel
>> [mailto:dri-devel-bounces@lists.freedesktop.org] On Behalf Of Jesse
>> Barnes Sent: Wednesday, July 23, 2014 5:00 PM To:
>> dri-devel@lists.freedesktop.org Subject: Re: [PATCH v2 00/25]
>> AMDKFD kernel driver
>> 
>> On Mon, 21 Jul 2014 19:05:46 +0200 daniel at ffwll.ch (Daniel
>> Vetter) wrote:
>> 
>>> On Mon, Jul 21, 2014 at 11:58:52AM -0400, Jerome Glisse wrote:
>>>> On Mon, Jul 21, 2014 at 05:25:11PM +0200, Daniel Vetter wrote:
>>>>> On Mon, Jul 21, 2014 at 03:39:09PM +0200, Christian K?nig
>>>>> wrote:
>>>>>> Am 21.07.2014 14:36, schrieb Oded Gabbay:
>>>>>>> On 20/07/14 20:46, Jerome Glisse wrote:
>> 
>> [snip!!]
> My BlackBerry thumb thanks you ;)
>> 
>>>>>> 
>>>>>> The main questions here are if it's avoid able to pin down
>>>>>> the memory and if the memory is pinned down at driver load,
>>>>>> by request from userspace or by anything else.
>>>>>> 
>>>>>> As far as I can see only the "mqd per userspace queue"
>>>>>> might be a bit questionable, everything else sounds
>>>>>> reasonable.
>>>>> 
>>>>> Aside, i915 perspective again (i.e. how we solved this):
>>>>> When scheduling away from contexts we unpin them and put them
>>>>> into the lru. And in the shrinker we have a last-ditch
>>>>> callback to switch to a default context (since you can't ever
>>>>> have no context once you've started) which means we can evict
>>>>> any context object if it's
>> getting in the way.
>>>> 
>>>> So Intel hardware report through some interrupt or some channel
>>>> when it is not using a context ? ie kernel side get
>>>> notification when some user context is done executing ?
>>> 
>>> Yes, as long as we do the scheduling with the cpu we get
>>> interrupts for context switches. The mechanic is already
>>> published in the execlist patches currently floating around. We
>>> get a special context switch interrupt.
>>> 
>>> But we have this unpin logic already on the current code where
>>> we switch contexts through in-line cs commands from the kernel.
>>> There we obviously use the normal batch completion events.
>> 
>> Yeah and we can continue that going forward.  And of course if your
>> hw can do page faulting, you don't need to pin the normal data
>> buffers.
>> 
>> Usually there are some special buffers that need to be pinned for
>> longer periods though, anytime the context could be active.  Sounds
>> like in this case the userland queues, which makes some sense.  But
>> maybe for smaller systems the size limit could be clamped to
>> something smaller than 128M.  Or tie it into the rlimit somehow,
>> just like we do for mlock() stuff.
>> 
> Yeah, even the queues are in pageable memory, it's just a ~256 byte
> structure per queue (the Memory Queue Descriptor) that describes the
> queue to hardware, plus a couple of pages for each process using HSA
> to hold things like doorbells. Current thinking is to limit #
> processes using HSA to ~256 and #queues per process to ~1024 by
> default in the initial code, although my guess is that we could take
> the #queues per process default limit even lower.
> 

So my mistake. struct cik_mqd is actually 604 bytes, and it is allocated
on 256 boundary.
I had in mind to reserve 64MB of gart by default, which translates to
512 queues per process, with 128 processes. Add 2 kernel module
parameters, # of max-queues-per-process and # of max-processes (default
is, as I said, 512 and 128) for better control of system admin.

	Oded

>>>> The issue with radeon hardware AFAICT is that the hardware do
>>>> not report any thing about the userspace context running ie you
>>>> do not get notification when a context is not use. Well AFAICT.
>>>> Maybe hardware
>> do provide that.
>>> 
>>> I'm not sure whether we can do the same trick with the hw
>>> scheduler. But then unpinning hw contexts will drain the pipeline
>>> anyway, so I guess we can just stop feeding the hw scheduler
>>> until it runs dry. And then unpin and evict.
>> 
>> Yeah we should have an idea which contexts have been fed to the
>> scheduler, at least with kernel based submission.  With userspace
>> submission we'll be in a tougher spot...  but as you say we can
>> always idle things and unpin everything under pressure.  That's a
>> really big hammer to apply though.
>> 
>>>> Like the VMID is a limited resources so you have to dynamicly
>>>> bind them so maybe we can only allocate pinned buffer for each
>>>> VMID and then when binding a PASID to a VMID it also copy back
>>>> pinned buffer to
>> pasid unpinned copy.
>>> 
>>> Yeah, pasid assignment will be fun. Not sure whether Jesse's
>>> patches will do this already. We _do_ already have fun with ctx
>>> id assigments though since we move them around (and the hw id is
>>> the ggtt address afaik). So we need to remap them already. Not
>>> sure on the details for pasid mapping, iirc it's a separate field
>>> somewhere in the context struct. Jesse knows the details.
>> 
>> The PASID space is a bit bigger, 20 bits iirc.  So we probably
>> won't run out quickly or often.  But when we do I thought we could
>> apply the same trick Linux uses for ASID management on SPARC and
>> ia64 (iirc on sparc anyway, maybe MIPS too): "allocate" a PASID
>> everytime you need one, but don't tie it to the process at all,
>> just use it as a counter that lets you know when you need to do a
>> full TLB flush, then start the allocation process over.  This lets
>> you minimize TLB flushing and gracefully handles oversubscription.
> 
> IIRC we have a 9-bit limit for PASID on current hardware, although
> that will go up in future.
>> 
>> My current code doesn't bother though; context creation will fail
>> if we run out of PASIDs on a given device.
>> 
>> -- Jesse Barnes, Intel Open Source Technology Center 
>> _______________________________________________ dri-devel mailing
>> list dri-devel@lists.freedesktop.org 
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> _______________________________________________ dri-devel mailing
> list dri-devel@lists.freedesktop.org 
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

