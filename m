Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaCNB5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 21:57:50 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:44295
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754322AbaCNB5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 21:57:45 -0400
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
Thread-Index: AQHPPxL8gdFEpLbAD0ahQ2OJgthmsZrf010A
Date: Fri, 14 Mar 2014 01:57:30 +0000
Message-ID: <1394762250.6416.24.camel@x230.lan>
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
In-Reply-To: <20140313232140.03bdaac3@alan.etchedpixels.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377424004)(199002)(189002)(24454002)(81816001)(83322001)(80976001)(81686001)(19580405001)(19580395003)(85852003)(90146001)(92726001)(92566001)(83072002)(74662001)(56816005)(53806001)(54356001)(77096001)(56776001)(76796001)(76786001)(54316002)(76482001)(4396001)(46102001)(49866001)(31966008)(93136001)(94316002)(69226001)(74876001)(74366001)(74706001)(85306002)(33646001)(86362001)(93516002)(47446002)(74502001)(59766001)(81342001)(77982001)(80022001)(81542001)(97336001)(87266001)(95666003)(87936001)(97186001)(94946001)(95416001)(50986001)(47976001)(51856001)(47736001)(20776003)(63696002)(79102001)(65816001)(2656002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB124;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:D8DFF21E.ACF2D001.D1D03D7B.42E8F86D.204F0;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD6E501CC23CDB4CBF31057998C36F60@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2E1wAnx013487

On Thu, 2014-03-13 at 23:21 +0000, One Thousand Gnomes wrote:
> On Thu, 13 Mar 2014 21:30:48 +0000
> Matthew Garrett <matthew.garrett@nebula.com> wrote:
> 
> > On Thu, 2014-03-13 at 21:24 +0000, One Thousand Gnomes wrote:
> > 
> > > If I have CAP_SYS_RAWIO I can make arbitary ring 0 calls from userspace,
> > > trivially and in a fashion well known and documented.
> > 
> > How?
> 
> You want a list... there are load of places all over the kernel that have
> assumptions that RAWIO = safe from the boringly mundane like MSR access
> to the more obscure driver "this is RAWIO trust the user" cases of which
> there are plenty.

Have you actually looked at these patches? I've looked at every case of
RAWIO in the kernel. For cases that are hardware specific and tied to
fairly old hardware, I've ignored them. For cases which provide an
obvious mechanism for exploitation, I've added an additional check. For
cases where I can't see a reasonable mechanism for executing arbitrary
code in the kernel, I've done nothing.

If you have specific examples of processes with CAP_SYS_RAWIO being able
to execute arbitrary code in the kernel even with this patchset applied,
please, give them.

>You can even avoid the userspace issues with a small amount of
>checking. If you don't want to touch capability sets then make the
>default behaviour for capable(x) in fact be
>
>        capable(x & ~secure_forbidden)
>
>for a measured kernel and add a 
>
>        capable_always()
>
>for the cases you want to not break.

We could do that, but now the behaviour of the patchset is far less
obvious. capable(CAP_SYS_RAWIO) now means something different to every
other use of capable(), and we still need get_trusted_kernel() calls for
cases where the checks have nothing to do with processes and so
capabilities can't be used. It still involves auditing every use of
CAP_SYS_RAWIO. In fact, in some cases we need to *add* CAP_SYS_RAWIO
checks - which, again, breaks userspace.

> As for mem= and exactmap, it has nothing to do with /dev/mem and
> everything to do with giving the kernel a memory map where some of the
> space it thinks is RAM is in fact devices, rom, space etc. If the kernel
> is given a false memory map it will misbehave. Exploitably - well given
> the kind of things people have achieved in the past - quite possibly.

Sure. That's a worthwhile thing to fix, and it's something that dropping
CAP_SYS_RAWIO would do nothing to help you with.

> If you are not prepared to do the job right, then I don't think it
> belongs upstream. Let's do it right, and if we have to tweak a few bits
> of userspace to make them work in measured mode (but without breaking
> anything in normal modes) then it's worth doing the job properly.

We can do this without unnecessarily breaking any userspace. We just
can't do it by fiddling with capabilities.

> I don't think we need to break any userspace for "normal" mode to do
> this. Userspace in measured mode is going to change anyway. It already
> has just for things like module signing.

This has been discussed at length. Nobody who's actually spent time
working on the problem wants to use capabilities. CAP_SYS_RAWIO is not
semantically identical to the trusted kernel bit. Trying to make them
semantically identical will break existing userspace.

> (As an aside you may also then want to think about whether you allow
> measured userspace elements that secure_forbidden is considered to be 0
> for so you can sign userspace apps that are allowed to do RAWIO)

I'd be amazed if any of the applications that need RAWIO have had any
kind of meaningful security audit, with the possible exception of X (and
then we'd need to add support for signed X modules and sign all the
DDXes and seriously just no). I've no objection to someone doing that
work (and Vivek did a pile of it when looking at implementing kexec via
signed userspace), but I don't see any real use cases - pretty much
everyone using bits of RAWIO that are gated in the trusted kernel case
should be using a real kernel interface instead.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
