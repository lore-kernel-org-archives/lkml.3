Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbaGWIcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:32:11 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:30266
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755655AbaGWIcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:32:07 -0400
X-WSS-ID: 0N95P1A-08-ZNC-02
X-M-MSG: 
Message-ID: <53CF72FA.9070806@amd.com>
Date: Wed, 23 Jul 2014 10:31:54 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        "Maarten Lankhorst" <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>	<53CE56ED.4040109@vodafone.de>
	<20140722132652.GO15237@phenom.ffwll.local>	<53CE6AFA.1060807@vodafone.de>
	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
	<53CE84AA.9030703@amd.com>
	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
	<53CE8A57.2000803@vodafone.de>	<53CF58FB.8070609@canonical.com>
	<53CF5B9F.1050800@amd.com>	<53CF5EFE.6070307@canonical.com>
	<53CF63C2.7070407@vodafone.de>
	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>
	<53CF6622.6060803@amd.com>
 <CAKMK7uHVh+gUXzQ+eYeV5rzHDxbkZ_9E3C7_m6=VOUzXRpALXQ@mail.gmail.com>
In-Reply-To: <CAKMK7uHVh+gUXzQ+eYeV5rzHDxbkZ_9E3C7_m6=VOUzXRpALXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.198]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(51704005)(24454002)(377454003)(55674003)(84676001)(77982001)(85306003)(59896001)(101416001)(4396001)(64126003)(80022001)(65806001)(65956001)(79102001)(105586002)(83506001)(47776003)(74662001)(20776003)(64706001)(106466001)(23676002)(85202003)(21056001)(81342001)(95666004)(68736004)(65816999)(76176999)(87266999)(54356999)(107046002)(50466002)(33656002)(87936001)(83322001)(86362001)(85852003)(80316001)(19580405001)(83072002)(44976005)(99396002)(19580395003)(50986999)(92726001)(46102001)(76482001)(36756003)(93886003)(110136001)(97736001)(102836001)(81542001)(85182001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB048;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 10:01, schrieb Daniel Vetter:
> On Wed, Jul 23, 2014 at 9:37 AM, Christian König
> <christian.koenig@amd.com> wrote:
>> Am 23.07.2014 09:31, schrieb Daniel Vetter:
>>> On Wed, Jul 23, 2014 at 9:26 AM, Christian König
>>> <deathsimple@vodafone.de> wrote:
>>>> It's not a locking problem I'm talking about here. Radeons lockup
>>>> handling
>>>> kicks in when anything calls into the driver from the outside, if you
>>>> have a
>>>> fence wait function that's called from the outside but doesn't handle
>>>> lockups you essentially rely on somebody else calling another radeon
>>>> function for the lockup to be resolved.
>>> So you don't have a timer in radeon that periodically checks whether
>>> progress is still being made? That's the approach we're using in i915,
>>> together with some tricks to kick any stuck waiters so that we can
>>> reliably step in and grab locks for the reset.
>>
>> We tried this approach, but it didn't worked at all.
>>
>> I already considered trying it again because of the upcoming fence
>> implementation, but reconsidering that when a driver is forced to change
>> it's handling because of the fence implementation that's just another hint
>> that there is something wrong here.
> Out of curiosity: What's the blocker for using a timer/scheduled work
> to reset radeon? Getting this right on i915 has been fairly tricky and
> we now have an elaborate multi-stage state machine to get the driver
> through a reset. So always interested in different solutions.

IIRC we would have needed a quite advanced multi-stage state machine as 
well and that was just to much overhead at this point.

One major problem was the power management in use back then, but that 
got replaced by DPM in the meantime. So it might be a good idea to try 
again.

What we currently do is marking the driver as "needs reset" and 
returning -EAGAIN and then the next IOCTL starts the reset procedure 
before doing anything else.

Christian.

> -Daniel

