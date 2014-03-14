Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaCNUoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:44:05 -0400
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:52193
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753570AbaCNUoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:44:01 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "david@lang.hm" <david@lang.hm>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Thread-Topic: Trusted kernel patchset for Secure Boot lockdown
Thread-Index: AQHPP6fNgdFEpLbAD0ahQ2OJgthmsZrhC0nbgAABowA=
Date: Fri, 14 Mar 2014 20:43:57 +0000
Message-ID: <1394829836.1286.5.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	 <1394686919.25122.2.camel@x230>
	 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	 <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	 <1394726363.25122.16.camel@x230>
	 <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
	 <1394746248.27846.3.camel@x230>
	 <20140313232140.03bdaac3@alan.etchedpixels.co.uk>
	 <1394762250.6416.24.camel@x230.lan>
	 <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	 <1394801518.6416.38.camel@x230.lan>
	 <20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	 <1394820664.26846.18.camel@x230.mview.int.nebula.com>
	 <1394825094.1286.1.camel@x230>
	 <alpine.DEB.2.02.1403141335590.12964@nftneq.ynat.uz>
In-Reply-To: <alpine.DEB.2.02.1403141335590.12964@nftneq.ynat.uz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377424004)(199002)(189002)(24454002)(77096001)(97186001)(69226001)(81686001)(31966008)(47446002)(74502001)(74662001)(80976001)(97336001)(74706001)(86362001)(74876001)(4396001)(76786001)(81816001)(76796001)(54316002)(54356001)(85306002)(76482001)(53806001)(56776001)(51856001)(65816001)(92726001)(81542001)(33646001)(19580405001)(19580395003)(93136001)(85852003)(33716001)(83322001)(59766001)(83072002)(81342001)(92566001)(80022001)(77982001)(46102001)(49866001)(63696002)(90146001)(74366001)(95416001)(20776003)(93516002)(47976001)(56816005)(50986001)(47736001)(95666003)(94946001)(87936001)(2656002)(87266001)(94316002)(79102001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB453;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:FE16CA25.BF945DD9.F2C3B778.46D96973.20190;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A086F10470A9E34BBBB5DA34E7E7168F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2EKiDOx019446

On Fri, 2014-03-14 at 13:37 -0700, David Lang wrote:
> On Fri, 14 Mar 2014, Matthew Garrett wrote:
> > As an example, imagine a platform with the bootloader and kernel on
> > read-only media. The platform can assert that the kernel is trusted even
> > if there's no measurement of the kernel.
> 
> Trusted by who?

The platform. If you don't trust the platform's ability to make that
decision then that's something that informs your own behaviour, not the
platform's.

> Alan is saying measured because then if it matches what the owner of that device 
> intends it's trusted, but just because you trust it doesn't mean that I trust 
> it, and it doesn't mean that the russian government should trust it, etc.

"Measured" has a specific meaning. If you trust a file based on its
source rather than some property of the file itself, you're not
measuring it.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
