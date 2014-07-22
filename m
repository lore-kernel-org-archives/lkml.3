Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaGVIUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:20:06 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:48746
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753356AbaGVIUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:20:01 -0400
X-Greylist: delayed 65258 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2014 04:20:01 EDT
X-WSS-ID: 0N93TT2-08-95S-02
X-M-MSG: 
Message-ID: <53CE1E9C.8020105@amd.com>
Date: Tue, 22 Jul 2014 11:19:40 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>,
        =?ISO-8859-1?Q?Christian_K=F6ni?= =?ISO-8859-1?Q?g?= 
	<deathsimple@vodafone.de>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
References: <20140720174652.GE3068@gmail.com> <53CD0961.4070505@amd.com>
 <53CD17FD.3000908@vodafone.de> <20140721152511.GW15237@phenom.ffwll.local>
 <20140721155851.GB4519@gmail.com> <20140721170546.GB15237@phenom.ffwll.local>
 <53CD4DD2.10906@amd.com>
 <CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
 <53CD5ED9.2040600@amd.com> <20140721190306.GB5278@gmail.com>
 <20140722072851.GH15237@phenom.ffwll.local>
In-Reply-To: <20140722072851.GH15237@phenom.ffwll.local>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(51704005)(377454003)(479174003)(189002)(199002)(64706001)(46102001)(86362001)(21056001)(76176999)(33656002)(84676001)(81542001)(74502001)(102836001)(74662001)(85306003)(65956001)(83506001)(64126003)(23756003)(76482001)(106466001)(95666004)(105586002)(79102001)(80022001)(87936001)(44976005)(101416001)(77982001)(50466002)(81342001)(87266999)(92726001)(107046002)(47776003)(83322001)(80316001)(20776003)(93886003)(65806001)(36756003)(4396001)(19580395003)(107886001)(85852003)(19580405001)(99396002)(68736004)(31966008)(83072002)(65816999)(50986999)(97736001)(2201001)(92566001)(54356999)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB047;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 10:28, Daniel Vetter wrote:
> On Mon, Jul 21, 2014 at 03:03:07PM -0400, Jerome Glisse wrote:
>> On Mon, Jul 21, 2014 at 09:41:29PM +0300, Oded Gabbay wrote:
>>> On 21/07/14 21:22, Daniel Vetter wrote:
>>>> On Mon, Jul 21, 2014 at 7:28 PM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>>>>>> I'm not sure whether we can do the same trick with the hw scheduler. But
>>>>>> then unpinning hw contexts will drain the pipeline anyway, so I guess we
>>>>>> can just stop feeding the hw scheduler until it runs dry. And then unpin
>>>>>> and evict.
>>>>> So, I'm afraid but we can't do this for AMD Kaveri because:
>>>>
>>>> Well as long as you can drain the hw scheduler queue (and you can do
>>>> that, worst case you have to unmap all the doorbells and other stuff
>>>> to intercept further submission from userspace) you can evict stuff.
>>>
>>> I can't drain the hw scheduler queue, as I can't do mid-wave preemption.
>>> Moreover, if I use the dequeue request register to preempt a queue
>>> during a dispatch it may be that some waves (wave groups actually) of
>>> the dispatch have not yet been created, and when I reactivate the mqd,
>>> they should be created but are not. However, this works fine if you use
>>> the HIQ. the CP ucode correctly saves and restores the state of an
>>> outstanding dispatch. I don't think we have access to the state from
>>> software at all, so it's not a bug, it is "as designed".
>>>
>>
>> I think here Daniel is suggesting to unmapp the doorbell page, and track
>> each write made by userspace to it and while unmapped wait for the gpu to
>> drain or use some kind of fence on a special queue. Once GPU is drain we
>> can move pinned buffer, then remap the doorbell and update it to the last
>> value written by userspace which will resume execution to the next job.
>
> Exactly, just prevent userspace from submitting more. And if you have
> misbehaving userspace that submits too much, reset the gpu and tell it
> that you're sorry but won't schedule any more work.

I'm not sure how you intend to know if a userspace misbehaves or not. Can you 
elaborate ?

	Oded
>
> We have this already in i915 (since like all other gpus we're not
> preempting right now) and it works. There's some code floating around to
> even restrict the reset to _just_ the offending submission context, with
> nothing else getting corrupted.
>
> You can do all this with the doorbells and unmapping them, but it's a
> pain. Much easier if you have a real ioctl, and I haven't seen anyone with
> perf data indicating that an ioctl would be too much overhead on linux.
> Neither in this thread nor internally here at intel.
> -Daniel
>

