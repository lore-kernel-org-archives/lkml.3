Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbaGWIgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:36:23 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:49307
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755655AbaGWIgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:36:19 -0400
X-WSS-ID: 0N95P8D-07-HZB-02
X-M-MSG: 
Message-ID: <53CF73EF.5000506@amd.com>
Date: Wed, 23 Jul 2014 11:35:59 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Jerome Glisse <j.glisse@gmail.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Andrew Lewycky" <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>, "Sellek, Tom" <Tom.Sellek@amd.com>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
References: <20140721155851.GB4519@gmail.com>
	<20140721170546.GB15237@phenom.ffwll.local>	<53CD4DD2.10906@amd.com>
	<CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
	<53CD5ED9.2040600@amd.com>	<20140721190306.GB5278@gmail.com>
	<20140722072851.GH15237@phenom.ffwll.local>	<53CE1E9C.8020105@amd.com>
	<CAKMK7uH+okhn4YGOzrXZ1LM3S2myxdu=_63LGMduwV-WZn06CA@mail.gmail.com>
	<53CE346B.1080601@amd.com>	<20140722111515.GJ15237@phenom.ffwll.local>
	<53CF5B30.50209@amd.com>
 <CAKMK7uFtSStEewVivbXAT1VC4t2Y+suTaEmQA4=UptK1UBLSmg@mail.gmail.com>
In-Reply-To: <CAKMK7uFtSStEewVivbXAT1VC4t2Y+suTaEmQA4=UptK1UBLSmg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377454003)(479174003)(199002)(51704005)(24454002)(189002)(4396001)(23676002)(102836001)(65816999)(101416001)(36756003)(106466001)(64706001)(47776003)(95666004)(85306003)(83072002)(85852003)(99396002)(81342001)(20776003)(87936001)(105586002)(46102001)(84676001)(50986999)(87266999)(54356999)(65956001)(76176999)(65806001)(80022001)(83506001)(19580405001)(77982001)(83322001)(97736001)(107046002)(92726001)(74662001)(76482001)(33656002)(21056001)(81542001)(110136001)(93886003)(19580395003)(59896001)(68736004)(44976005)(50466002)(79102001)(80316001)(64126003)(86362001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB040;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/14 10:05, Daniel Vetter wrote:
> On Wed, Jul 23, 2014 at 8:50 AM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>> On 22/07/14 14:15, Daniel Vetter wrote:
>>>
>>> On Tue, Jul 22, 2014 at 12:52:43PM +0300, Oded Gabbay wrote:
>>>>
>>>> On 22/07/14 12:21, Daniel Vetter wrote:
>>>>>
>>>>> On Tue, Jul 22, 2014 at 10:19 AM, Oded Gabbay <oded.gabbay@amd.com>
>>>>> wrote:
>>>>>>>
>>>>>>> Exactly, just prevent userspace from submitting more. And if you have
>>>>>>> misbehaving userspace that submits too much, reset the gpu and tell it
>>>>>>> that you're sorry but won't schedule any more work.
>>>>>>
>>>>>>
>>>>>> I'm not sure how you intend to know if a userspace misbehaves or not.
>>>>>> Can
>>>>>> you elaborate ?
>>>>>
>>>>>
>>>>> Well that's mostly policy, currently in i915 we only have a check for
>>>>> hangs, and if userspace hangs a bit too often then we stop it. I guess
>>>>> you can do that with the queue unmapping you've describe in reply to
>>>>> Jerome's mail.
>>>>> -Daniel
>>>>>
>>>> What do you mean by hang ? Like the tdr mechanism in Windows (checks if a
>>>> gpu job takes more than 2 seconds, I think, and if so, terminates the
>>>> job).
>>>
>>>
>>> Essentially yes. But we also have some hw features to kill jobs quicker,
>>> e.g. for media workloads.
>>> -Daniel
>>>
>>
>> Yeah, so this is what I'm talking about when I say that you and Jerome come
>> from a graphics POV and amdkfd come from a compute POV, no offense intended.
>>
>> For compute jobs, we simply can't use this logic to terminate jobs. Graphics
>> are mostly Real-Time while compute jobs can take from a few ms to a few
>> hours!!! And I'm not talking about an entire application runtime but on a
>> single submission of jobs by the userspace app. We have tests with jobs that
>> take between 20-30 minutes to complete. In theory, we can even imagine a
>> compute job which takes 1 or 2 days (on larger APUs).
>>
>> Now, I understand the question of how do we prevent the compute job from
>> monopolizing the GPU, and internally here we have some ideas that we will
>> probably share in the next few days, but my point is that I don't think we
>> can terminate a compute job because it is running for more than x seconds.
>> It is like you would terminate a CPU process which runs more than x seconds.
>>
>> I think this is a *very* important discussion (detecting a misbehaved
>> compute process) and I would like to continue it, but I don't think moving
>> the job submission from userspace control to kernel control will solve this
>> core problem.
>
> Well graphics gets away with cooperative scheduling since usually
> people want to see stuff within a few frames, so we can legitimately
> kill jobs after a fairly short timeout. Imo if you want to allow
> userspace to submit compute jobs that are atomic and take a few
> minutes to hours with no break-up in between and no hw means to
> preempt then that design is screwed up. We really can't tell the core
> vm that "sorry we will hold onto these gobloads of memory you really
> need now for another few hours". Pinning memory like that essentially
> without a time limit is restricted to root.
> -Daniel
>

First of all, I don't see the relation to memory pinning here. I already said on 
this thread that amdkfd does NOT pin local memory. The only memory we allocate 
is system memory, and we map it to the gart, and we can limit that memory by 
limiting max # of queues and max # of process through kernel parameters. Most of 
the memory used is allocated via regular means by the userspace, which is 
usually pageable.

Second, it is important to remember that this problem only exists in KV. In CZ, 
the GPU can context switch between waves (by doing mid-wave preemption). So even 
long running waves are getting switched on and off constantly and there is no 
monopolizing of GPU resources.

Third, even in KV, we can kill waves. The question is when and how to recognize 
it. I think it would be sufficient for now if we expose this ability to the kernel.

	Oded
