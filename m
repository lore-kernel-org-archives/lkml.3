Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaCNPqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:46:45 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:44046
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755954AbaCNPqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:46:42 -0400
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
Thread-Index: AQHPP5llgdFEpLbAD0ahQ2OJgthmsZrgufeA
Date: Fri, 14 Mar 2014 15:46:37 +0000
Message-ID: <1394811997.26846.2.camel@x230.mview.int.nebula.com>
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
In-Reply-To: <CAGXu5jLZcWh5WD0L8s3Q-GXdXCMnA57qtjfdFfQbv0fxYcuCTQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.56.23.115]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(24454002)(377424004)(81342001)(77982001)(59766001)(80022001)(63696002)(66066001)(74502001)(85306002)(74876001)(94316002)(69226001)(74706001)(74366001)(47446002)(86362001)(33646001)(93516002)(79102001)(20776003)(2656002)(65816001)(87266001)(87936001)(95666003)(81542001)(97336001)(51856001)(47976001)(50986001)(47736001)(94946001)(97186001)(95416001)(90146001)(19580405001)(81816001)(80976001)(81686001)(83322001)(19580395003)(85852003)(92726001)(4396001)(76482001)(46102001)(54316002)(76786001)(56776001)(31966008)(93136001)(49866001)(74662001)(83072002)(92566001)(54356001)(76796001)(77096001)(56816005)(53806001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB124;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:EC664627.91F6FD19.B1D193B3.44EEFAAE.2015E;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <42DA14E159C96B438BD6BCE7F536ACD6@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2EFktuP017486

On Fri, 2014-03-14 at 08:23 -0700, Kees Cook wrote:

> The command line problem here is a total red herring. If you've got a
> measured kernel, you have a measured command line. (If not, you don't
> have a measured kernel.) Dealing with the command line has nothing to
> do with enforcing the ring0/uid0 boundary which is what this patch
> series does.

That's why I used trusted rather than measured. The Secure Boot trust
model assumes that the user is able to modify the command line (it's
basically impossible to deploy generically otherwise), so we need to
filter out command line options that allow a user to elevate themselves
into the kernel at boot time.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
