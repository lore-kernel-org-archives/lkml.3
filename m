Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaCNSLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:11:23 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:48489
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754461AbaCNSLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:11:21 -0400
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
Thread-Index: AQHPP6fNgdFEpLbAD0ahQ2OJgthmsZrg4jYA
Date: Fri, 14 Mar 2014 18:11:06 +0000
Message-ID: <1394820664.26846.18.camel@x230.mview.int.nebula.com>
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
In-Reply-To: <20140314170655.0ce398a3@alan.etchedpixels.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(377424004)(51704005)(199002)(189002)(76786001)(83072002)(56816005)(97186001)(85852003)(76796001)(47736001)(95666003)(77096001)(97336001)(74502001)(74662001)(47446002)(31966008)(87266001)(47976001)(74366001)(50986001)(33646001)(2656002)(90146001)(94946001)(63696002)(74706001)(4396001)(80022001)(87936001)(53806001)(81342001)(54356001)(51856001)(81686001)(46102001)(80976001)(81816001)(76482001)(19580405001)(81542001)(83322001)(92726001)(86362001)(95416001)(69226001)(93516002)(19580395003)(54316002)(65816001)(56776001)(94316002)(79102001)(92566001)(49866001)(74876001)(77982001)(93136001)(85306002)(59766001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB455;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:EECCF026.AC3611D9.F0E1A0BB.4EE63861.20526;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A919B6F982A5CB44A308225F22BBB281@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2EIBWlH018516

On Fri, 2014-03-14 at 17:06 +0000, One Thousand Gnomes wrote:
> > But you keep talking about MSRs despite there being a patch that limits
> > access to MSRs. If you have specific examples of privilege escalations
> > that are possible even with these patches then please, mention them.
> 
> I mentioned MSRs once, and then you kept going on about it. 

You've twice mentioned MSRs as a case where CAP_SYS_RAWIO allows you to
elevate privileges, despite that being a case that's explicitly covered
by this patchset. Now, do you have an actual example of CAP_SYS_RAWIO
allowing you to elevate privileges even with this patchset applied (and
without requiring the presence of obsolete hardware, which is a separate
conversation)?

> Your patches are all over the tree, for what should be one piece of
> policy. They rely on not missing a single case, which is also bad
> security engineering. We know that, as an industry we've spent fifty
> years repeatedly sticking our fingers in our ears, refusing to listen and
> then learning it again and again the hard way.

I have a set of patches that appear acceptable to the security
maintainer. I've rewritten them multiple times in response to various
levels of bikeshedding. They solve a real problem and are being shipped
by multiple distributions.

What the rest of your mail is asking me to do is to rewrite capabilities
support entirely. Now, yes, I agree that capabilities are an awful
interface that's approximately impossible to use correctly and which
adds little security even if you do. But I reject the idea that
rewriting fundamental security infrastructure should be a prerequisite
for adding this functionality.

> > It needs to be possible for this policy to be imposed without userspace
> > being involved, so using selinux would mean baking it into the kernel
> > (along with an additional implementation for apparmor, and presumably
> > one for tomoyo as well).
> 
> That's clearly false. You can load signed modules so you can load signed
> policies. Assuming you don't have an initial measured file system you
> need a kernel policy initially that protects you. If you have a measured
> file system you don't even need that, nor do you need to revoke RAWIO in
> kernel, you can do it before you switch into "measured and running
> un-measured code" mode - ie about the point you pivot root out of the
> initrd that loaded the measured policy.

We can't rely on userspace choosing to load that policy. We don't have a
measured filesystem. The initrd is not signed (and nor can it be). The
kernel itself *must* impose policy.

> > ...thus breaking userspace outside this use case. I mean, sure, I'm
> > absolutely fine with deleting /dev/mem entirely. I don't see Linus
> > agreeing.
> 
> That's not what I meant. We have a lot of interfaces where we use
> CAP_SYS_RAWIO rather than having a structured interface as opposed to a
> 'yeah whatever, poke the registers' interface.
> 
> For a lot of environments btw you don't actually need /dev/mem. It's not
> really got a lot of uses any more and plenty of people really restrict or
> remove it from systems. I don't think very many people would be sad
> if /dev/mem became a legacy interface most people left turned off.

Sure! Except then A Large Vendor's custom IPMI userspace stops working,
even on systems without Secure Boot, and then said Large Vendor wants to
have conference calls at times that are convenient for Japan and then
this is an issue that's going to cause $1 billion in lost sales and come
on, you've been there. You know that this isn't going to work. 

> If we are going to do a measured kernel then it needs to be done right,
> it needs to be properly abstracted so we don't add another one for
> Android, another one for Chrome, another one for ARM trustzone, another
> one for Intel SGX, and so on.

The fact that you keep saying measured really does make me suspect that
you misunderstand the problem. There's no measurement involved, there's
simply an assertion that the firmware (which you're forced to trust)
chose, via some policy you may be unaware of, to trust the booted
kernel.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
