Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbaGWHhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:37:20 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:29116
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756512AbaGWHhS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:37:18 -0400
X-WSS-ID: 0N95MHY-08-X9W-02
X-M-MSG: 
Message-ID: <53CF6622.6060803@amd.com>
Date: Wed, 23 Jul 2014 09:37:06 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5p?= =?UTF-8?B?Zw==?= 
	<deathsimple@vodafone.de>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
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
In-Reply-To: <CAKMK7uGJj+UwcnnzA+fj_=uWPN3i0sneWkoD+wfPJ_8Q6Y-DQg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.198]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(377454003)(24454002)(92726001)(83322001)(83072002)(19580405001)(68736004)(44976005)(93886003)(99396002)(4396001)(85852003)(76176999)(87936001)(85182001)(87266999)(46102001)(19580395003)(33656002)(97736001)(85306003)(101416001)(23676002)(50986999)(102836001)(21056001)(83506001)(76482001)(20776003)(65806001)(95666004)(36756003)(64126003)(81342001)(79102001)(81542001)(107046002)(106466001)(85202003)(64706001)(86362001)(80316001)(54356999)(65816999)(77982001)(47776003)(59896001)(74662001)(65956001)(50466002)(105586002)(84676001)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB036;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 09:31, schrieb Daniel Vetter:
> On Wed, Jul 23, 2014 at 9:26 AM, Christian König
> <deathsimple@vodafone.de> wrote:
>> It's not a locking problem I'm talking about here. Radeons lockup handling
>> kicks in when anything calls into the driver from the outside, if you have a
>> fence wait function that's called from the outside but doesn't handle
>> lockups you essentially rely on somebody else calling another radeon
>> function for the lockup to be resolved.
> So you don't have a timer in radeon that periodically checks whether
> progress is still being made? That's the approach we're using in i915,
> together with some tricks to kick any stuck waiters so that we can
> reliably step in and grab locks for the reset.

We tried this approach, but it didn't worked at all.

I already considered trying it again because of the upcoming fence 
implementation, but reconsidering that when a driver is forced to change 
it's handling because of the fence implementation that's just another 
hint that there is something wrong here.

Christian.

> -Daniel

