Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbaGWKNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:13:17 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:52248
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757588AbaGWKNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:13:15 -0400
X-WSS-ID: 0N95TPW-08-3RR-02
X-M-MSG: 
Message-ID: <53CF8AB1.2000009@amd.com>
Date: Wed, 23 Jul 2014 12:13:05 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?UTF-8?B?Q2hyaXM=?= =?UTF-8?B?dGlhbiBLw7ZuaWc=?= 
	<deathsimple@vodafone.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>
	<53CE8A57.2000803@vodafone.de>	<53CF58FB.8070609@canonical.com>
	<53CF5B9F.1050800@amd.com>	<53CF5EFE.6070307@canonical.com>
	<53CF63C2.7070407@vodafone.de>
	<CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>
	<53CF6622.6060803@amd.com>	<53CF699D.9070902@canonical.com>
	<53CF6B18.5070107@vodafone.de>
	<CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>
	<53CF7035.2060808@amd.com>	<53CF7191.2090008@canonical.com>
	<CAKMK7uGLqzePAREsWhX0D1oN4FdqKwPgAL6x8sULpJSqYH5LwA@mail.gmail.com>
	<53CF765E.7020802@vodafone.de>
	<CAKMK7uE1G-EjbJ2RAXC3ZfkaCo=Gber5PJuRG623Yoz9D=FmGw@mail.gmail.com>
	<53CF8010.9060809@amd.com>
	<CAKMK7uEowhvc+4Jc6t2NAeE1joFaohJ6cP7sU-Akut6b3ta=1g@mail.gmail.com>
	<53CF822E.7050601@amd.com>
	<CAKMK7uG85KV94PTqkzvY8RPxg6ApRKHVZrD20e48GHZM=s06=w@mail.gmail.com>
 <CAKMK7uHEgdU+Uz-OnRGvT_wFjOXHpZmgZcrORsBrST_MY5_ADA@mail.gmail .com>
 <53CF84C7.2020507@vodafone.de> <53CF8693.1040006@canonical.com >
In-Reply-To: <53CF8693.1040006@canonical.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.198]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(377454003)(199002)(24454002)(189002)(377424004)(44976005)(93886003)(85852003)(33656002)(101416001)(31966008)(47776003)(46102001)(84676001)(80022001)(86362001)(64126003)(76176999)(102836001)(79102001)(99396002)(68736004)(20776003)(74502001)(85306003)(50986999)(81542001)(85202003)(77982001)(92726001)(81342001)(19580395003)(106466001)(87936001)(76482001)(74662001)(80316001)(65816999)(21056001)(107046002)(97736001)(64706001)(19580405001)(65806001)(87266999)(83322001)(105586002)(50466002)(83072002)(95666004)(54356999)(85182001)(92566001)(23676002)(36756003)(65956001)(4396001)(83506001)(59896001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 11:55, schrieb Maarten Lankhorst:
> op 23-07-14 11:47, Christian König schreef:
>> Am 23.07.2014 11:44, schrieb Daniel Vetter:
>>> On Wed, Jul 23, 2014 at 11:39 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>>>> The scheduler needs to keep track of a lot of fences, so I think we'll
>>>> have to register callbacks, not a simple wait function. We must keep
>>>> track of all the non-i915 fences for all oustanding batches. Also, the
>>>> scheduler doesn't eliminate the hw queue, only keep it much slower so
>>>> that we can sneak in higher priority things.
>>>>
>>>> Really, scheduler or not is orthogonal.
>>> Also see my other comment about interactions between wait_fence and
>>> the i915 reset logic. We can't actually use it from within the
>>> scheduler code since that would deadlock.
>> Yeah, I see. You would need some way to abort the waiting on other devices fences in case of a lockup.
>>
>> What about an userspace thread to offload waiting and command submission to?
> You would still need enable_signaling, else polling on the dma-buf wouldn't work. ;-)
> Can't wait synchronously with multiple shared fences, need to poll for that.

No you don't. Just make a list of fences you need to wait for and wait 
for each after another. But having an thread for each command submission 
context doesn't sounds like the best solution anyway.

> And the dma-buf would still have fences belonging to both drivers, and it would still call from outside the driver.

Calling from outside the driver is fine as long as the driver can do 
everything necessary to complete it's work and isn't forced into any 
ugly hacks and things that are not 100% reliable.

So I don't see much other approach as integrating recovery code for not 
firing interrupts and some kind of lockup handling into the fence code 
as well.

Christian.

>
> ~Maarten
>

