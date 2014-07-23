Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbaGWIUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 04:20:18 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:18716
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756992AbaGWIUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 04:20:14 -0400
X-WSS-ID: 0N95OHK-08-Z61-02
X-M-MSG: 
Message-ID: <53CF7035.2060808@amd.com>
Date: Wed, 23 Jul 2014 10:20:05 +0200
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
	<53CF6622.6060803@amd.com>	<53CF699D.9070902@canonical.com>
	<53CF6B18.5070107@vodafone.de>
 <CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>
In-Reply-To: <CAKMK7uGd65HR11thcv8KjDw-RnTa7W-QGOzFGFd+oO_hp8wyHA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.198]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(377454003)(24454002)(79102001)(86362001)(19580405001)(44976005)(64706001)(74662001)(101416001)(20776003)(95666004)(92726001)(87936001)(105586002)(84676001)(50466002)(65816999)(107046002)(21056001)(64126003)(80022001)(68736004)(85202003)(85306003)(76176999)(46102001)(83322001)(85182001)(106466001)(4396001)(19580395003)(81542001)(33656002)(23676002)(87266999)(97736001)(81342001)(99396002)(80316001)(83506001)(83072002)(85852003)(36756003)(93886003)(102836001)(59896001)(76482001)(50986999)(54356999)(47776003)(65806001)(65956001)(77982001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB038;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 10:07, schrieb Daniel Vetter:
> On Wed, Jul 23, 2014 at 9:58 AM, Christian König
> <deathsimple@vodafone.de> wrote:
>> Just imagine an application using prime is locking up Radeon and because of
>> that gets killed by the user. Nothing else in the system would use the
>> Radeon hardware any more and so radeon gets only called by another driver
>> waiting patiently for radeon to finish rendering which never happens because
>> the whole thing is locked up and we don't get a chance to recover.
> But isn't that possible already without fences? X hangs radeon, user
> crashes X for unrelated reasons before radeon will notice the hang.
> Then no one uses radeon any longer and the hang stays undetected.

Yeah, especially with multimedia application. But I don't really care 
about this problem because the next time an application tries to use the 
block in question we actually do the reset and everything is fine.

In your example we would do the reset when the next X server starts, 
before that point nobody would care because nobody uses the hardware.

An additional problem here is that resets are something perfect normal 
for radeon. For example UVD can "crash" when you feed it with invalid 
bitstream data, (ok actually it send an interrupt and stops any 
processing for the driver to investigate). To continue processing you 
need to go through a rather complicated reset procedure.

Christian.

> -Daniel

