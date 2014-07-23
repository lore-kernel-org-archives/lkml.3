Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbaGWMgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:36:20 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:43601
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753005AbaGWMgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:36:17 -0400
X-WSS-ID: 0N960CC-07-S8O-02
X-M-MSG: 
Message-ID: <53CFAC38.9050501@amd.com>
Date: Wed, 23 Jul 2014 14:36:08 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?UTF-8?B?Q2hyaXM=?= =?UTF-8?B?dGlhbiBLw7ZuaWc=?= 
	<deathsimple@vodafone.de>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>
	<53CF58FB.8070609@canonical.com>	<53CF5B9F.1050800@amd.com>
	<53CF5EFE.6070307@canonical.com>	<53CF63C2.7070407@vodafone.de>
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
	<53CF84C7.2020507@vodafone.de>	<53CF8693.1040006@canonical.com>
	<53CF8AB1.2000009@amd.com>
 <CAKMK7uEgGzKb3Vsnz0FCgFCcSM39QntEisg0JMg=HOvnwLCZgw@mail.gmail.com>
In-Reply-To: <CAKMK7uEgGzKb3Vsnz0FCgFCcSM39QntEisg0JMg=HOvnwLCZgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.198]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(377454003)(51704005)(24454002)(74662001)(68736004)(19580395003)(23676002)(83322001)(110136001)(65816999)(79102001)(84676001)(99396002)(83506001)(74502001)(44976005)(21056001)(93886003)(19580405001)(33656002)(50466002)(36756003)(59896001)(85182001)(92566001)(85852003)(77982001)(87266999)(80316001)(83072002)(50986999)(54356999)(76176999)(92726001)(80022001)(65956001)(46102001)(65806001)(85306003)(47776003)(64706001)(86362001)(20776003)(102836001)(81342001)(81542001)(105586002)(107046002)(101416001)(97736001)(106466001)(87936001)(31966008)(85202003)(4396001)(76482001)(64126003)(95666004);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 12:52, schrieb Daniel Vetter:
> On Wed, Jul 23, 2014 at 12:13 PM, Christian König
> <christian.koenig@amd.com> wrote:
>>> And the dma-buf would still have fences belonging to both drivers, and it
>>> would still call from outside the driver.
>>
>> Calling from outside the driver is fine as long as the driver can do
>> everything necessary to complete it's work and isn't forced into any ugly
>> hacks and things that are not 100% reliable.
>>
>> So I don't see much other approach as integrating recovery code for not
>> firing interrupts and some kind of lockup handling into the fence code as
>> well.
> That approach doesn't really work at that well since every driver has
> it's own reset semantics. And we're trying to move away from global
> reset to fine-grained reset. So stop-the-world reset is out of
> fashion, at least for i915. As you said, reset is normal in gpus and
> we're trying to make reset less invasive. I really don't see a point
> in imposing a reset scheme upon all drivers and I think you have about
> as much motivation to convert radeon to the scheme used by i915 as
> I'll have for converting to the one used by radeon. If it would fit at
> all.
Oh my! No, I didn't wanted to suggest any global reset infrastructure.

My idea was more that the fence framework provides a 
fence->process_signaling callback that is periodically called after 
enable_signaling is called to trigger manual signal processing in the 
driver.

This would both be suitable as a fallback in case of not working 
interrupts as well as a chance for any driver to do necessary lockup 
handling.

Christian.

> I guess for radeon we just have to add tons of insulation by punting
> all callbacks to work items so that radeon can do whatever it wants.
> Plus start a delayed_work based fallback when ->enable_signalling is
> called to make sure we work on platforms that lack interrupts.
> -Daniel

