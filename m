Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab3KVAD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:03:59 -0500
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:51290
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752430Ab3KVAD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:03:57 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "matt@console-pimps.org" <matt@console-pimps.org>,
        "richard@nod.at" <richard@nod.at>, "cxie@redhat.com" <cxie@redhat.com>
Subject: Re: [PATCH] x86, efi: add no_bricked_efi whitelist
Thread-Topic: [PATCH] x86, efi: add no_bricked_efi whitelist
Thread-Index: AQHO5ctsbQuFm47B1katHCc9ePY1AJovbqbwgADxyq6AAACgAA==
Date: Fri, 22 Nov 2013 00:03:53 +0000
Message-ID: <1385078632.12107.3.camel@x230>
References: <528C740A.6010407@jp.fujitsu.com>
	 <1384963376.20536.3.camel@x230> <528DD3E0.3050606@jp.fujitsu.com>
	 <1385064722.12107.1.camel@x230> <528E9EB2.3060808@jp.fujitsu.com>
In-Reply-To: <528E9EB2.3060808@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(51704005)(479174003)(24454002)(377424004)(189002)(199002)(80976001)(54356001)(74502001)(51856001)(79102001)(87936001)(31966008)(47736001)(81542001)(49866001)(19580405001)(83322001)(80022001)(47446002)(4396001)(87266001)(65816001)(53806001)(46102001)(63696002)(76482001)(76796001)(74876001)(76786001)(77982001)(33646001)(83072001)(59766001)(69226001)(19580395003)(50986001)(81686001)(47976001)(74366001)(2656002)(81342001)(74662001)(56816003)(56776001)(85306002)(81816001)(74706001)(33716001)(54316002)(77096001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB422;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <330BE9DF8531B04CBBCBD5FE884BCD40@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAM043Vo020622

On Fri, 2013-11-22 at 09:00 +0900, Yasuaki Ishimatsu wrote:
> (2013/11/22 5:12), Matthew Garrett wrote:
> > On Thu, 2013-11-21 at 18:35 +0900, Yasuaki Ishimatsu wrote:
> >
> >> Remaining space is free space that can be used by efi variable. But by 5KB
> >> threshold, we cannot use the space while running OS.
> >
> > Is the situation something like(assuming a 128KB flash part):
> >
> > 1) 64KB of variables, 59KB of deleted variables, 5KB of free space,
> 
> My situation looks like this. The free space spreads out if gc runs.

Ok. In that case Joey's suggestion that we try forcing a GC run in the
boot stub if free space < (threshold * 2) might be the best plan.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
