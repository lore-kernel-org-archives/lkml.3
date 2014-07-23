Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaGWGup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:50:45 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:17896
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756470AbaGWGun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:50:43 -0400
X-WSS-ID: 0N95KCE-07-DFG-02
X-M-MSG: 
Message-ID: <53CF5B30.50209@amd.com>
Date: Wed, 23 Jul 2014 09:50:24 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>,
        =?windows-1252?Q?Christian_K=F6?= =?windows-1252?Q?nig?= 
	<deathsimple@vodafone.de>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?windows-1252?Q?Michel_D=E4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>, "Sellek, Tom" <Tom.Sellek@amd.com>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
References: <20140721155851.GB4519@gmail.com>
 <20140721170546.GB15237@phenom.ffwll.local> <53CD4DD2.10906@amd.com>
 <CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
 <53CD5ED9.2040600@amd.com> <20140721190306.GB5278@gmail.com>
 <20140722072851.GH15237@phenom.ffwll.local> <53CE1E9C.8020105@amd.com>
 <CAKMK7uH+okhn4YGOzrXZ1LM3S2myxdu=_63LGMduwV-WZn06CA@mail.gmail.com>
 <53CE346B.1080601@amd.com> <20140722111515.GJ15237@phenom.ffwll.local>
In-Reply-To: <20140722111515.GJ15237@phenom.ffwll.local>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(51704005)(199002)(189002)(377454003)(479174003)(81542001)(102836001)(81342001)(101416001)(107046002)(105586002)(65806001)(80022001)(65956001)(46102001)(86362001)(20776003)(47776003)(64706001)(85306003)(107886001)(64126003)(95666004)(106466001)(87936001)(97736001)(76482001)(4396001)(83506001)(23746002)(99396002)(84676001)(44976005)(74662001)(68736004)(79102001)(65816999)(19580395003)(83322001)(2201001)(77982001)(85852003)(19580405001)(33656002)(54356999)(76176999)(50986999)(50466002)(36756003)(92726001)(83072002)(21056001)(93886003)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 14:15, Daniel Vetter wrote:
> On Tue, Jul 22, 2014 at 12:52:43PM +0300, Oded Gabbay wrote:
>> On 22/07/14 12:21, Daniel Vetter wrote:
>>> On Tue, Jul 22, 2014 at 10:19 AM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>>>>> Exactly, just prevent userspace from submitting more. And if you have
>>>>> misbehaving userspace that submits too much, reset the gpu and tell it
>>>>> that you're sorry but won't schedule any more work.
>>>>
>>>> I'm not sure how you intend to know if a userspace misbehaves or not. Can
>>>> you elaborate ?
>>>
>>> Well that's mostly policy, currently in i915 we only have a check for
>>> hangs, and if userspace hangs a bit too often then we stop it. I guess
>>> you can do that with the queue unmapping you've describe in reply to
>>> Jerome's mail.
>>> -Daniel
>>>
>> What do you mean by hang ? Like the tdr mechanism in Windows (checks if a
>> gpu job takes more than 2 seconds, I think, and if so, terminates the job).
>
> Essentially yes. But we also have some hw features to kill jobs quicker,
> e.g. for media workloads.
> -Daniel
>

Yeah, so this is what I'm talking about when I say that you and Jerome come from 
a graphics POV and amdkfd come from a compute POV, no offense intended.

For compute jobs, we simply can't use this logic to terminate jobs. Graphics are 
mostly Real-Time while compute jobs can take from a few ms to a few hours!!! And 
I'm not talking about an entire application runtime but on a single submission 
of jobs by the userspace app. We have tests with jobs that take between 20-30 
minutes to complete. In theory, we can even imagine a compute job which takes 1 
or 2 days (on larger APUs).

Now, I understand the question of how do we prevent the compute job from 
monopolizing the GPU, and internally here we have some ideas that we will 
probably share in the next few days, but my point is that I don't think we can 
terminate a compute job because it is running for more than x seconds. It is 
like you would terminate a CPU process which runs more than x seconds.

I think this is a *very* important discussion (detecting a misbehaved compute 
process) and I would like to continue it, but I don't think moving the job 
submission from userspace control to kernel control will solve this core problem.

	Oded
