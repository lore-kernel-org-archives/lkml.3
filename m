Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab3IHQ7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:59:46 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:57796
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753834Ab3IHQ7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 12:59:45 -0400
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
Thread-Index: AQHOqQBlTgRtcELUZ0K5HxHj5bQ8FZm7apqAgAALY9KAAI6QgIAAB7GAgAAE4lqAAAZ8AA==
Date: Sun, 8 Sep 2013 16:59:40 +0000
Message-ID: <1378659580.2300.15.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <20130908161859.GA18946@kroah.com> <1378657487.2300.10.camel@x230>
	 <20130908163926.GA19665@kroah.com>
In-Reply-To: <20130908163926.GA19665@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:740c:5537:5f2f:efde]
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(189002)(199002)(81816001)(81342001)(69226001)(65816001)(80022001)(46102001)(63696002)(51856001)(4396001)(76796001)(76786001)(81686001)(81542001)(50986001)(47976001)(49866001)(47736001)(33716001)(33646001)(74366001)(47446002)(74706001)(74662001)(74502001)(31966008)(74876001)(80976001)(83072001)(77982001)(59766001)(56776001)(54316002)(79102001)(77096001)(56816003)(53806001)(76482001)(54356001)(83322001)(19580405001)(19580395003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB221;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:740c:5537:5f2f:efde;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA8EF98376F32C48B29FAF8AB34D7607@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r88GxpmH015518

On Sun, 2013-09-08 at 09:39 -0700, Greg KH wrote:

> But I want, for other reasons (i.e. safety in layers), signed kernel
> modules.  I also might actually want some debugfs files in some random
> driver (like this series removes).

You want a configuration that makes no sense. There's no reason that the
kernel should make that easy.

> Heck, look at Red Hat.  They have been shipping signed kernel modules
> for _years_ and yet they do not disable kexec.  Have they been "doing it
> wrong" all of this time?   Perhaps people want signed modules just for
> support reasons, not "security" reasons.

Then they do what Red Hat does and don't set CONFIG_SIG_ENFORCE.

> Don't take away those options.

Where's the option to let me let unprivileged users set random MSRs?
Where's the option to let root disable STRICT_DEVMEM at runtime? We
don't offer these options because *they make no sense*. Locking your
door while leaving your window open may make you feel better, but it
doesn't improve the security of your house.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
