Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3IHRPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:15:49 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:21014
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753093Ab3IHRPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:15:47 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Topic: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Index: AQHOqQBlTgRtcELUZ0K5HxHj5bQ8FZm7apqAgAALY9KAAI6QgIAAFlYAgAABMoA=
Date: Sun, 8 Sep 2013 17:15:42 +0000
Message-ID: <1378660541.2300.19.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
	 <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:740c:5537:5f2f:efde]
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(189002)(199002)(377424004)(74876001)(80976001)(53806001)(56816003)(77096001)(19580395003)(19580405001)(83322001)(76482001)(54356001)(79102001)(77982001)(59766001)(83072001)(56776001)(54316002)(80022001)(63696002)(46102001)(81342001)(81816001)(65816001)(69226001)(74366001)(47446002)(74706001)(31966008)(74662001)(74502001)(50986001)(47976001)(47736001)(49866001)(4396001)(51856001)(81686001)(81542001)(76786001)(76796001)(33646001)(33716001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB222;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:740c:5537:5f2f:efde;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <254C8BA269DE7E40A11C6FC7D4CBEE43@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r88HFsUS015580

On Sun, 2013-09-08 at 10:11 -0700, James Bottomley wrote:

> That's not true if you look at the use cases.  Distros use signed
> modules to taint the kernel:  insert an unsigned one and the kernel
> taints; insert a properly signed one and it doesn't.  They use it for
> support to tell if you've been adhering to your contract.  That use case
> has nothing to do with security.

That use case has nothing to do with this patch, either. It's completely
unaffected. This only triggers if the kernel is configured to refuse the
loading of unsigned modules.

> The analogy is rubbish.  I can give away CAP_SYS_MODULE and enforce what
> modules those I've given the permission to can insert by signing them.
> I keep CAP_SYS_BOOT, so they can't use kexec to subvert this.

Yeah, that's a good argument for why capabilities are mostly pointless.
If I have CAP_SYS_BOOT I can give myself any other capabilities. Why
bother?

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
