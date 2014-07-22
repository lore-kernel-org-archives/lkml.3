Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbaGVJxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:53:04 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:38888
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753373AbaGVJxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:53:01 -0400
X-WSS-ID: 0N93Y44-08-DWG-02
X-M-MSG: 
Message-ID: <53CE346B.1080601@amd.com>
Date: Tue, 22 Jul 2014 12:52:43 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
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
References: <20140720174652.GE3068@gmail.com>	<53CD0961.4070505@amd.com>
	<53CD17FD.3000908@vodafone.de>	<20140721152511.GW15237@phenom.ffwll.local>
	<20140721155851.GB4519@gmail.com>	<20140721170546.GB15237@phenom.ffwll.local>
	<53CD4DD2.10906@amd.com>
	<CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
	<53CD5ED9.2040600@amd.com>	<20140721190306.GB5278@gmail.com>
	<20140722072851.GH15237@phenom.ffwll.local>	<53CE1E9C.8020105@amd.com>
 <CAKMK7uH+okhn4YGOzrXZ1LM3S2myxdu=_63LGMduwV-WZn06CA@mail.gmail.com>
In-Reply-To: <CAKMK7uH+okhn4YGOzrXZ1LM3S2myxdu=_63LGMduwV-WZn06CA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(377454003)(51704005)(479174003)(199002)(189002)(101416001)(85306003)(92566001)(77982001)(76482001)(81542001)(80316001)(31966008)(110136001)(106466001)(19580405001)(83322001)(19580395003)(93886003)(105586002)(95666004)(21056001)(46102001)(4396001)(85852003)(84676001)(97736001)(83072002)(102836001)(64706001)(79102001)(36756003)(50466002)(44976005)(81342001)(54356999)(64126003)(86362001)(74502001)(33656002)(92726001)(74662001)(20776003)(65806001)(107046002)(83506001)(68736004)(87936001)(23676002)(65816999)(80022001)(65956001)(50986999)(76176999)(47776003)(87266999)(99396002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB166;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 12:21, Daniel Vetter wrote:
> On Tue, Jul 22, 2014 at 10:19 AM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>>> Exactly, just prevent userspace from submitting more. And if you have
>>> misbehaving userspace that submits too much, reset the gpu and tell it
>>> that you're sorry but won't schedule any more work.
>>
>> I'm not sure how you intend to know if a userspace misbehaves or not. Can
>> you elaborate ?
>
> Well that's mostly policy, currently in i915 we only have a check for
> hangs, and if userspace hangs a bit too often then we stop it. I guess
> you can do that with the queue unmapping you've describe in reply to
> Jerome's mail.
> -Daniel
>
What do you mean by hang ? Like the tdr mechanism in Windows (checks if a gpu 
job takes more than 2 seconds, I think, and if so, terminates the job).

	Oded
