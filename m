Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaGNHe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:34:27 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:55179
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753260AbaGNHeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:34:13 -0400
X-WSS-ID: 0N8OYCD-08-121-02
X-M-MSG: 
From: "Gabbay, Oded" <Oded.Gabbay@amd.com>
To: "airlied@gmail.com" <airlied@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "j.glisse@gmail.com" <j.glisse@gmail.com>,
        "Bridgman, John" <John.Bridgman@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Pinchuk, Evgeny" <Evgeny.Pinchuk@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Skidanov, Alexey" <Alexey.Skidanov@amd.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "oded.gabbay@gmail.com" <oded.gabbay@gmail.com>,
        "Goz, Ben" <Ben.Goz@amd.com>
Subject: Re: [PATCH 13/83] hsa/radeon: Add 2 new IOCTL to kfd, CREATE_QUEUE
 and DESTROY_QUEUE
Thread-Topic: [PATCH 13/83] hsa/radeon: Add 2 new IOCTL to kfd, CREATE_QUEUE
 and DESTROY_QUEUE
Thread-Index: AQHPnIkn6UkKy1BEJ0yOPolV0iv0PJubrBWAgAPJyYA=
Date: Mon, 14 Jul 2014 07:33:47 +0000
Message-ID: <019CCE693E457142B37B791721487FD9180B19A2@storexdag03.amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	 <1405029027-6085-12-git-send-email-oded.gabbay@amd.com>
	 <CAPM=9tyV8PBreHHSsMKo8dRiGvVWHR+LLPcNE2dVpoYkftpv2Q@mail.gmail.com>
In-Reply-To: <CAPM=9tyV8PBreHHSsMKo8dRiGvVWHR+LLPcNE2dVpoYkftpv2Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.0.84]
Content-Type: text/plain; charset="utf-8"
Content-ID: <224E3B53863AAD4899AE8405C68F7DEC@amd.com>
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377424004)(51704005)(199002)(189002)(24454002)(164054003)(54356999)(50466002)(76176999)(2656002)(95666004)(106116001)(64706001)(80022001)(46102001)(84676001)(44976005)(83322001)(107046002)(2351001)(87936001)(79102001)(47776003)(81542001)(92566001)(106466001)(97736001)(68736004)(77982001)(92726001)(85852003)(105586002)(20776003)(50986999)(86362001)(81342001)(99396002)(83072002)(55846006)(110136001)(31966008)(85306003)(74662001)(74502001)(21056001)(53416004)(76482001)(33656002)(1411001)(101416001)(23676002)(4396001)(77096002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB033;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6E7YcNY002174

On Sat, 2014-07-12 at 07:42 +1000, Dave Airlie wrote:
> >  +/* The 64-bit ABI is the authoritative version. */
> >  +#pragma pack(push, 8)
> >  +
>  
> Don't do this, pad and align things explicitly in structs.
>  
> >  +struct kfd_ioctl_create_queue_args {
> >  +       uint64_t ring_base_address;     /* to KFD */
> >  +       uint32_t ring_size;             /* to KFD */
> >  +       uint32_t gpu_id;                /* to KFD */
> >  +       uint32_t queue_type;            /* to KFD */
> >  +       uint32_t queue_percentage;      /* to KFD */
> >  +       uint32_t queue_priority;        /* to KFD */
> >  +       uint64_t write_pointer_address; /* to KFD */
> >  +       uint64_t read_pointer_address;  /* to KFD */
> >  +
> >  +       uint64_t doorbell_address;      /* from KFD */
> >  +       uint32_t queue_id;              /* from KFD */
> >  +};
> >  +
>  
> maybe put all the uint64_t at the start, or add explicit padding.
>  
> Dave.
Thanks, will be fixed.
        Odedÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
