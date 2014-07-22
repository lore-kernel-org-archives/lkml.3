Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaGVOj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:39:59 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:53395
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751751AbaGVOj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:39:57 -0400
X-WSS-ID: 0N94BEB-08-WZN-02
X-M-MSG: 
Message-ID: <53CE77B4.6020801@amd.com>
Date: Tue, 22 Jul 2014 16:39:48 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        Dave Airlie <airlied@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [PATCH 09/17] drm/radeon: use common fence implementation for
 fences
References: <20140709093124.11354.3774.stgit@patser>
 <20140709122953.11354.46381.stgit@patser>
 <CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
 <53CE2421.5040906@amd.com> <20140722114607.GL15237@phenom.ffwll.local>
 <20140722115737.GN15237@phenom.ffwll.local> <53CE56ED.4040109@vodafone.de>
 <53CE6FB0.90500@canonical.com> <53CE7410.3090603@amd.com>
 <53CE74B5.3000201@canonical.com>
In-Reply-To: <53CE74B5.3000201@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.224.155.194]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377424004)(52314003)(199002)(51704005)(189002)(47776003)(64706001)(106466001)(92566001)(101416001)(4396001)(102836001)(65816999)(36756003)(85306003)(95666004)(20776003)(105586002)(99396002)(81342001)(85852003)(83072002)(87936001)(50986999)(84676001)(46102001)(81542001)(87266999)(54356999)(65956001)(65806001)(76176999)(80022001)(83506001)(77982001)(92726001)(97736001)(107046002)(83322001)(74662001)(21056001)(107886001)(59896001)(33656002)(76482001)(23756003)(93886003)(44976005)(80316001)(31966008)(68736004)(50466002)(79102001)(74502001)(64126003)(86362001)(921003)(1121002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB040;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2014 16:27, schrieb Maarten Lankhorst:
> op 22-07-14 16:24, Christian König schreef:
>>> No, you really shouldn't be doing much in the check anyway, it's meant to be a lightweight check. If you're not ready yet because of a lockup simply return not signaled yet.
>> It's not only the lockup case from radeon I have in mind here. For userspace queues it might be necessary to call copy_from_user to figure out if a fence is signaled or not.
>>
>> Returning false all the time is probably not a good idea either.
> Having userspace implement a fence sounds like an awful idea, why would you want to do that?

Marketing moves in mysterious ways. Don't ask me, but that the direction 
it currently moves with userspace queues and IOMMU etc...

> A fence could be exported to userspace, but that would only mean it can wait for it to be signaled with an interface like poll..

Yeah agree totally, but the point for the fence interface is that I 
can't predict what's necessary to check if a fence is signaled or not on 
future hardware.

For the currently available radeon hardware I can say that reading a 
value from a kernel page is pretty much all you need. But for older 
hardware that was reading from a register which might become very tricky 
if the hardware is power off or currently inside a reset cycle.

Because off this I would avoid any such interface if it's not absolutely 
required by some use case, and currently I don't see this requirement 
because the functionality you want to archive could be implemented 
without this.

Christian.

>
> ~Maarten
>

