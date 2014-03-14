Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaCNP6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:58:22 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:48140
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754809AbaCNP6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:58:18 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "keescook@chromium.org" <keescook@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
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
Thread-Index: AQHPP52rgdFEpLbAD0ahQ2OJgthmsZrgvR8A
Date: Fri, 14 Mar 2014 15:58:02 +0000
Message-ID: <1394812682.26846.5.camel@x230.mview.int.nebula.com>
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
	 <CAGXu5jLZcWh5WD0L8s3Q-GXdXCMnA57qtjfdFfQbv0fxYcuCTQ@mail.gmail.com>
	 <1394811997.26846.2.camel@x230.mview.int.nebula.com>
	 <CAGXu5j+3vVKhFPOsArYddA+QqhvVUunj8eYOF799rDv=3MGtyg@mail.gmail.com>
In-Reply-To: <CAGXu5j+3vVKhFPOsArYddA+QqhvVUunj8eYOF799rDv=3MGtyg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.56.23.115]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(24454002)(189002)(199002)(83072002)(33646001)(85852003)(74876001)(81686001)(19580405001)(79102001)(65816001)(66066001)(97336001)(80022001)(80976001)(76786001)(81816001)(63696002)(74502001)(69226001)(83322001)(19580395003)(46102001)(51856001)(31966008)(85306002)(77982001)(81342001)(59766001)(90146001)(4396001)(92726001)(95416001)(93516002)(54316002)(74366001)(86362001)(93136001)(56776001)(47976001)(92566001)(47446002)(76482001)(87936001)(74706001)(54356001)(56816005)(76796001)(77096001)(95666003)(94316002)(97186001)(47736001)(74662001)(49866001)(2656002)(50986001)(94946001)(87266001)(53806001)(81542001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB456;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:172.56.23.115;FPR:F9D8718E.83259F21.A9D1116C.88C26F79.2018F;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <810F24FF5F986543B694F546A00A701C@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2EFwVgb017570

On Fri, 2014-03-14 at 08:54 -0700, Kees Cook wrote:

> All the more reason to ignore command line at this point. For Chrome
> OS, it's part of our boot state, so we don't care about it. For
> generic Secure Boot, we can add checks for dangerous stuff as we go
> forward. That's why I like this interface -- we can add to it as we
> identify bad stuff, and it stay separate from other semantics.

Sure, it's just another reason not to want to use a capability-based
interface - not all the policy we want to impose is related to
processes, so capabilities really don't make sense. The current patchset
adds a restriction to the acpi_rsdp argument, and I've no objection to
adding one to limit the use of mem=.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
