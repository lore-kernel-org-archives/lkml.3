Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaCNWEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:04:44 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:49058
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754397AbaCNWEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:04:42 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Thread-Topic: Trusted kernel patchset for Secure Boot lockdown
Thread-Index: AQHPP9CXgdFEpLbAD0ahQ2OJgthmsZrhIyiA
Date: Fri, 14 Mar 2014 22:04:39 +0000
Message-ID: <1394834679.1286.16.camel@x230>
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
	 <20140314215854.50ec186a@alan.etchedpixels.co.uk>
In-Reply-To: <20140314215854.50ec186a@alan.etchedpixels.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377424004)(199002)(189002)(24454002)(81686001)(83322001)(19580405001)(81816001)(80976001)(85852003)(92726001)(19580395003)(90146001)(92566001)(83072002)(74662001)(56816005)(53806001)(54356001)(77096001)(76796001)(56776001)(76786001)(54316002)(76482001)(4396001)(46102001)(49866001)(31966008)(93136001)(94316002)(69226001)(74876001)(74366001)(33716001)(74706001)(85306002)(33646001)(86362001)(93516002)(47446002)(59766001)(81342001)(77982001)(74502001)(80022001)(63696002)(51856001)(81542001)(97336001)(50986001)(47736001)(47976001)(95666003)(95416001)(94946001)(97186001)(2656002)(79102001)(20776003)(87266001)(87936001)(65816001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB124;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:FEC0F03E.AF545B2B.78F08398.48987E41.201C5;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B9940B633CC2049901F7815B7789244@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2EM5OpH019905

On Fri, 2014-03-14 at 21:58 +0000, One Thousand Gnomes wrote:
> On Fri, 14 Mar 2014 19:24:55 +0000
> Matthew Garrett <matthew.garrett@nebula.com> wrote:
> > As an example, imagine a platform with the bootloader and kernel on
> > read-only media. The platform can assert that the kernel is trusted even
> > if there's no measurement of the kernel.
> 
> Only if you have a secure signed path through the controller firmware and
> physical security of the hardware. If not I can reprogram your BIOS, your
> GPU firmware, your USB stick or your CD-ROM controller to lie.

Sure, and then the trust that the firmware placed in the kernel would be
misplaced. You can subvert Secure Boot with an SPI flasher, just as you
can subvert selinux with a firewire dongle. Those attacks are outside
the threat model. If you're in a situation where you have to care about
threats outside that threat model then you need to choose a more
appropriate solution.
-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
