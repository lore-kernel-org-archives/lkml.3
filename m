Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaJNCDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 22:03:41 -0400
Received: from mail-by2on0147.outbound.protection.outlook.com ([207.46.100.147]:36815
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966AbaJNCDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 22:03:40 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dp@opensource.wolfsonmicro.com" <dp@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 6/6] regmap: cache: Fix possible ZERO_SIZE_PTR pointer
 dereferencing error.
Thread-Topic: [PATCH 6/6] regmap: cache: Fix possible ZERO_SIZE_PTR pointer
 dereferencing error.
Thread-Index: AQHP45/r0AFxmZhor0CZKdgM8Z0nWZwt4PgAgAD7FTA=
Date: Tue, 14 Oct 2014 02:03:37 +0000
Message-ID: <d7b88c5d4d664a589f6b209be88634b0@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
 <1412845377-17134-7-git-send-email-Li.Xiubo@freescale.com>
 <20141013105450.GQ27755@sirena.org.uk>
In-Reply-To: <20141013105450.GQ27755@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
x-forefront-prvs: 03648EFF89
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(164054003)(189002)(24454002)(51704005)(64706001)(66066001)(20776003)(92566001)(74316001)(97736003)(40100003)(76576001)(105586002)(107046002)(106356001)(95666004)(86362001)(99286002)(99396003)(54356999)(106116001)(80022003)(76176999)(50986999)(46102003)(21056001)(77096002)(120916001)(101416001)(4396001)(108616004)(76482002)(85852003)(33646002)(85306004)(122556002)(110136001)(87936001)(31966008)(2656002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH 6/6] regmap: cache: Fix possible ZERO_SIZE_PTR pointer
> dereferencing error.
> 
> On Thu, Oct 09, 2014 at 05:02:57PM +0800, Xiubo Li wrote:
> > When all the registers are volatile(unlikely, but logically and mostly
> > will happen for some 'device' who has very few registers), then the
> > count will be euqal to 0, then kmalloc() will return ZERO_SIZE_PTR,
> > which equals to ((void *)16).
> 
> Applied, thanks.  I'm assuming there's nothing affected by this in
> Linus' tree which needs this as a fix immediately?

Yes, this will happen on one case like my LS1 platform in late future.

Thanks,

BRs
Xiubo

