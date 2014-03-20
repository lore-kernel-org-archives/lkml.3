Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbaCTRMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:12:15 -0400
Received: from mail-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:12745
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753222AbaCTRMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:12:10 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "tytso@mit.edu" <tytso@mit.edu>
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
Thread-Index: AQHPP9H0gdFEpLbAD0ahQ2OJgthmsZrhN8oAgAeouoCAATicgIAAJkSA
Date: Thu, 20 Mar 2014 17:12:05 +0000
Message-ID: <1395335525.16016.3.camel@x230>
References: <1394762250.6416.24.camel@x230.lan>
	 <20140314122231.17b9ca8a@alan.etchedpixels.co.uk>
	 <1394801518.6416.38.camel@x230.lan>
	 <20140314170655.0ce398a3@alan.etchedpixels.co.uk>
	 <1394820664.26846.18.camel@x230.mview.int.nebula.com>
	 <20140314214806.54a3d031@alan.etchedpixels.co.uk>
	 <1394834193.1286.11.camel@x230>
	 <20140314220840.29a12171@alan.etchedpixels.co.uk>
	 <20140314231832.GA653@thunk.org>
	 <CAGXu5j+JXy4EbHxu+8twWo=3gqyLJ6hZGPbgsdf3t8YhUA-bWw@mail.gmail.com>
	 <20140320145507.GB20618@thunk.org>
In-Reply-To: <20140320145507.GB20618@thunk.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [208.186.201.90]
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(189002)(199002)(377424004)(81342001)(47976001)(47736001)(49866001)(4396001)(74876001)(69226001)(76786001)(65816001)(76796001)(85852003)(83072002)(90146001)(20776003)(2171001)(92566001)(56816005)(63696002)(50986001)(66066001)(74502001)(31966008)(74662001)(47446002)(87936001)(80022001)(87266001)(19580395003)(95416001)(95666003)(93136001)(19580405001)(85306002)(97186001)(94946001)(76482001)(81542001)(74706001)(2656002)(80976001)(79102001)(92726001)(46102001)(86362001)(51856001)(94316002)(74366001)(93516002)(97336001)(33646001)(83322001)(56776001)(54316002)(77096001)(33716001)(81816001)(59766001)(77982001)(81686001)(53806001)(54356001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB424;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:7736F32F.ADD71B0B.B9D34FA6.8224D843.20253;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5AD5D3E378B571469A6A3C63FE37928B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2KHCOLV024172

On Thu, 2014-03-20 at 10:55 -0400, tytso@mit.edu wrote:

> I disagree; it's highly likely, if not certain that Windows booting
> under UEFI secure boot is going to be able to do some of the things
> that people are proposing that we have to prohibit in the name of
> security.  That's because presumably Windows won't be willing to make
> certain usability tradeoffs, and since they control the signing certs,
> even in the unlikely case that people can leverage these "holes" to
> enable a boot sector virus, it seems unlikely that Windows will revoke
> its own cert.

I don't think any of the functionality we're disabling (with the
arguable exception of kexec, which, again, there is a plan to handle) is
useful on modern systems. And, seriously, if this forces vendors to
write actual kernel drivers rather than run an io port banging IPMI
driver in userspace, that's a *good* thing.

Whether Microsoft would actually follow through on blacklisting their
own signatures is obviously an unknown - they've told us they would, but
commercial concerns etc who knows. They *will* blacklist our signatures.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
