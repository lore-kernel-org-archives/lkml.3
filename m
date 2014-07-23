Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbaGWJg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:36:57 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:4422
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753112AbaGWJg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:36:56 -0400
X-WSS-ID: 0N95S1D-08-2D3-02
X-M-MSG: 
Message-ID: <53CF822E.7050601@amd.com>
Date: Wed, 23 Jul 2014 11:36:46 +0200
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
	<53CE6AFA.1060807@vodafone.de>
	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
	<53CE84AA.9030703@amd.com>
	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
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
In-Reply-To: <CAKMK7uEowhvc+4Jc6t2NAeE1joFaohJ6cP7sU-Akut6b3ta=1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.198]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(24454002)(199002)(189002)(377454003)(80022001)(21056001)(110136001)(76482001)(64706001)(50466002)(77982001)(50986999)(4396001)(93886003)(87936001)(79102001)(97736001)(65806001)(59896001)(65956001)(19580395003)(85852003)(102836001)(87266999)(54356999)(83072002)(76176999)(83506001)(85306003)(65816999)(84676001)(105586002)(33656002)(68736004)(85182001)(64126003)(36756003)(106466001)(74662001)(20776003)(99396002)(107046002)(85202003)(101416001)(23676002)(86362001)(83322001)(47776003)(46102001)(81542001)(44976005)(81342001)(95666004)(19580405001)(92726001)(80316001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB039;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 11:30, schrieb Daniel Vetter:
> On Wed, Jul 23, 2014 at 11:27 AM, Christian König
> <christian.koenig@amd.com> wrote:
>> You submit a job to the hardware and then block the job to wait for radeon
>> to be finished? Well than this would indeed require a hardware reset, but
>> wouldn't that make the whole problem even worse?
>>
>> I mean currently we block one userspace process to wait for other hardware
>> to be finished with a buffer, but what you are describing here blocks the
>> whole hardware to wait for other hardware which in the end blocks all
>> userspace process accessing the hardware.
> There is nothing new here with prime - if one context hangs the gpu it
> blocks everyone else on i915.
>
>> Talking about alternative approaches wouldn't it be simpler to just offload
>> the waiting to a different kernel or userspace thread?
> Well this is exactly what we'll do once we have the scheduler. But
> this is an orthogonal issue imo.

Mhm, could have the scheduler first?

Cause that sounds like reducing the necessary fence interface to just a 
fence->wait function.

Christian.

> -Daniel

