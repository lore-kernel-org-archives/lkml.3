Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab3IHRZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:25:38 -0400
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:13303
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab3IHRZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:25:37 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Topic: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Index: AQHOqQBlTgRtcELUZ0K5HxHj5bQ8FZm7apqAgAALY9KAAI6QgIAAB7GAgAAE4lqAAAwdzIAAAZcA
Date: Sun, 8 Sep 2013 17:25:31 +0000
Message-ID: <1378661130.2300.24.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <20130908161859.GA18946@kroah.com> <1378657487.2300.10.camel@x230>
	 <20130908163926.GA19665@kroah.com> <1378659580.2300.15.camel@x230>
	 <20130908172249.GB20959@kroah.com>
In-Reply-To: <20130908172249.GB20959@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:740c:5537:5f2f:efde]
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(377424004)(51704005)(189002)(199002)(50986001)(81686001)(4396001)(49866001)(47976001)(47736001)(74366001)(81342001)(76796001)(79102001)(81542001)(76786001)(59766001)(83072001)(77982001)(51856001)(19580395003)(33646001)(65816001)(33716001)(80976001)(83322001)(19580405001)(74502001)(47446002)(80022001)(56816003)(77096001)(31966008)(74662001)(74876001)(76482001)(63696002)(69226001)(54356001)(56776001)(46102001)(54316002)(74706001)(81816001)(53806001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:740c:5537:5f2f:efde;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE461A51FEDADC488415ECA54C5A74D6@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r88HPhr5015645

On Sun, 2013-09-08 at 10:22 -0700, Greg KH wrote:
> On Sun, Sep 08, 2013 at 04:59:40PM +0000, Matthew Garrett wrote:
> > On Sun, 2013-09-08 at 09:39 -0700, Greg KH wrote:
> > 
> > > But I want, for other reasons (i.e. safety in layers), signed kernel
> > > modules.  I also might actually want some debugfs files in some random
> > > driver (like this series removes).
> > 
> > You want a configuration that makes no sense. There's no reason that the
> > kernel should make that easy.
> 
> It makes sense to me in that it is something I can do today, why stop
> that?

You used to be able to modify MSRs without CAP_SYS_ADMIN. Why stop that?

> > > Heck, look at Red Hat.  They have been shipping signed kernel modules
> > > for _years_ and yet they do not disable kexec.  Have they been "doing it
> > > wrong" all of this time?   Perhaps people want signed modules just for
> > > support reasons, not "security" reasons.
> > 
> > Then they do what Red Hat does and don't set CONFIG_SIG_ENFORCE.
> 
> But what if I only want signed modules to be loaded?  Isn't that a valid
> thing to want, yet still be able to also do other things with my system?

If you only want signed modules to be loaded then you can't permit the
kexec of untrusted objects, because that would allow unsigned modules to
be loaded.

> > Where's the option to let me let unprivileged users set random MSRs?
> 
> Can that happen today?

No. We took it away.

> > Where's the option to let root disable STRICT_DEVMEM at runtime?
> 
> Again, can that happen today?

No, because it makes no sense - the entire point of STRICT_DEVMEM is to
restrict what root can do.

> > We don't offer these options because *they make no sense*. Locking
> > your door while leaving your window open may make you feel better, but
> > it doesn't improve the security of your house.
> 
> Yes it does, it keeps the people who only try the front door from coming
> in, a very common threat model.  It isn't "perfect" security, but I'm
> not saying that it is, and no one else is either.

Why would someone only try the front door when there's an obviously open
window next to it?

> Security is a series of "levels", all of which depend on different
> threat models and scenarios.  Provide the ability to achieve different
> levels of security, but don't force your idea of system-wide security on
> others who may not agree with it.

Providing a security feature that can be trivially circumvented isn't
security, it's security theatre.
-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
