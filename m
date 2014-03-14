Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbaCNWPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:15:50 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:24519
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753952AbaCNWPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:15:48 -0400
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
Thread-Index: AQHPP9H0gdFEpLbAD0ahQ2OJgthmsZrhJj+A
Date: Fri, 14 Mar 2014 22:15:45 +0000
Message-ID: <1394835345.1286.22.camel@x230>
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
	 <20140314214806.54a3d031@alan.etchedpixels.co.uk>
	 <1394834193.1286.11.camel@x230>
	 <20140314220840.29a12171@alan.etchedpixels.co.uk>
In-Reply-To: <20140314220840.29a12171@alan.etchedpixels.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(24454002)(51704005)(199002)(189002)(94316002)(47976001)(47736001)(33646001)(49866001)(81542001)(77096001)(33716001)(74706001)(74366001)(93516002)(74876001)(86362001)(94946001)(54316002)(20776003)(81342001)(59766001)(63696002)(54356001)(53806001)(46102001)(51856001)(79102001)(76482001)(56776001)(69226001)(85852003)(95416001)(76796001)(90146001)(65816001)(47446002)(56816005)(97186001)(87266001)(74502001)(74662001)(31966008)(2656002)(85306002)(87936001)(76786001)(80022001)(50986001)(81686001)(83072002)(92726001)(83322001)(95666003)(19580405001)(19580395003)(81816001)(92566001)(80976001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB122;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:FE87F3C6.A73A57C1.C3F0DD6B.86F7F961.202EF;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F2DB0170EF3AA4C810108E9EE2D1B2C@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2EMFttv019963

On Fri, 2014-03-14 at 22:08 +0000, One Thousand Gnomes wrote:
> On Fri, 14 Mar 2014 21:56:33 +0000
> Matthew Garrett <matthew.garrett@nebula.com> wrote:
> > Signed userspace is not a requirement, and therefore any solution that
> > relies on a signed initrd is inadequate. There are use cases that
> > require verification of the initrd and other levels. This isn't one of
> > them.
> 
> The job of the kernel is to solve the general problem. There are lots of
> people who happen to care about verification beyond the kernel so it
> shouldn't be ignored. And they can do do things like load trusted SELinux
> rulesets even if you can't support it in your environment.

The general problem includes having to support this even without an
selinux policy.

> > > Even in EFI you can make your kernel or loader check the initrd signature
> > > and the rootfs signature if you want.
> > 
> > Except the initramfs gets built at kernel install time.
> 
> Implementation detail for your use case.

And one that's not going to change, so the general problem includes not
relying on a signed initramfs.

> > > Correct me if I am wrong but your starting point is "I have a chain of
> > > measurement as far as the kernel I load". Without that I can just go into
> > > grub and 0wn you.
> > 
> > In my use case. But not all implementations will be measuring things -
> > they can assert that the kernel is trustworthy through some other
> > mechanism. This genuinely is about trust, not measurement.
> 
> The assertion you attempt to achieve is I believe
> 
> "No ring 0 code is executed directly or indirectly that is not measured"

No. As I keep pointing out, not all code is measured. The firmware is
not required to measure itself. A particular implementation may skip
measuring the kernel because it can attest to its trustworthyness in
some other way. ChromeOS will load unmeasured kernel modules provided it
can attest to the trustworthyness of the filesystem containing them.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
