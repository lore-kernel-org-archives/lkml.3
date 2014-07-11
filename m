Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaGKWyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 18:54:41 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:42784
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751144AbaGKWyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 18:54:39 -0400
X-WSS-ID: 0N8KKYW-08-UPH-02
X-M-MSG: 
From: "Bridgman, John" <John.Bridgman@amd.com>
To: Ilyes Gouta <ilyes.gouta@gmail.com>
CC: Alex Deucher <alexdeucher@gmail.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Maling list - DRI developers" <dri-devel@lists.freedesktop.org>
Subject: RE: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes
 in KV
Thread-Topic: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and
 pipes in KV
Thread-Index: AQHPnIkE5u7uzYXY9UmcyTqCh3tvUpubTcyAgAADzgCAAAEXAP//xj7QgABU4oCAAA6vQA==
Date: Fri, 11 Jul 2014 22:54:31 +0000
Message-ID: <D89D60253BB73A4E8C62F9FD18A939CA01031F22@storexdag02.amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <20140711160516.GC1870@gmail.com> <53C00E6E.4040908@amd.com>
 <CADnq5_NkXJuaeMWv8HogykiH8ida17U90gO0Ec7DMRxMcLbrkA@mail.gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01031826@storexdag02.amd.com>
 <CAL4m05UPDBrSOaHdyVSws9c3i=NPmSfVYQ=4emehyctN1+9r0g@mail.gmail.com>
In-Reply-To: <CAL4m05UPDBrSOaHdyVSws9c3i=NPmSfVYQ=4emehyctN1+9r0g@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.34.48]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(428002)(24454002)(377454003)(189002)(51704005)(199002)(110136001)(50466002)(4396001)(19580405001)(19580395003)(2656002)(97736001)(107046002)(46102001)(33656002)(106466001)(105586002)(93886003)(80022001)(85852003)(55846006)(53416004)(85306003)(83322001)(79102001)(83072002)(77982001)(87936001)(77096002)(81542001)(21056001)(92566001)(44976005)(50986999)(92726001)(54356999)(99396002)(101416001)(81342001)(76176999)(86362001)(74662001)(20776003)(47776003)(68736004)(23676002)(64706001)(106116001)(31966008)(76482001)(95666004)(74502001)(84676001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB144;H:atltwp02.amd.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02698DF457
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=John.Bridgman@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6BMspkI024513

>From: Ilyes Gouta [mailto:ilyes.gouta@gmail.com] 
>Sent: Friday, July 11, 2014 2:00 PM
>To: Bridgman, John
>Cc: Alex Deucher; Koenig, Christian; Oded Gabbay; Deucher, Alexander; Lewycky, Andrew; LKML; Maling list - DRI developers
>Subject: Re: [PATCH 02/83] drm/radeon: reduce number of free VMIDs and pipes in KV
>
>Hi,
>
>Just a side question (for information),
>
>On Fri, Jul 11, 2014 at 6:07 PM, Bridgman, John <John.Bridgman@amd.com> wrote:
>
>Right. The SET_RESOURCES packet (kfd_pm4_headers.h, added in patch 49) allocates a range of HW queues, VMIDs and GDS to the HW scheduler, then >the scheduler uses the allocated VMIDs to support a potentially larger number of user processes by dynamically mapping PASIDs to VMIDs and memory >queue descriptors (MQDs) to HW queues.
>
>Are there any documentation/specifications online describing these mechanisms?

Nothing yet, but we should write some docco for this similar to what was written for the gfx blocks. I'll add that to the list, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
