Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab3IHGoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 02:44:17 -0400
Received: from mail-bn1lp0153.outbound.protection.outlook.com ([207.46.163.153]:46639
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab3IHGoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 02:44:15 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Topic: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Thread-Index: AQHOqQBlTgRtcELUZ0K5HxHj5bQ8FZm7apqAgAABBwA=
Date: Sun, 8 Sep 2013 06:44:08 +0000
Message-ID: <1378622648.2300.4.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com>
In-Reply-To: <20130908064027.GA3587@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:740c:5537:5f2f:efde]
x-forefront-prvs: 09634B1196
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(51704005)(189002)(199002)(377424004)(74876001)(80976001)(53806001)(56816003)(77096001)(19580395003)(19580405001)(83322001)(76482001)(54356001)(79102001)(77982001)(59766001)(83072001)(56776001)(54316002)(80022001)(63696002)(46102001)(81342001)(81816001)(65816001)(69226001)(74366001)(47446002)(74706001)(31966008)(74662001)(74502001)(50986001)(47976001)(47736001)(49866001)(4396001)(51856001)(81686001)(81542001)(76786001)(76796001)(33646001)(33716001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:740c:5537:5f2f:efde;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <7666AC1992BDE74E8AC4EB4DD507C51A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r886iOpt013993

On Sat, 2013-09-07 at 23:40 -0700, Greg KH wrote:
> On Tue, Sep 03, 2013 at 07:50:15PM -0400, Matthew Garrett wrote:
> > kexec permits the loading and execution of arbitrary code in ring 0, which
> > is something that module signing enforcement is meant to prevent. It makes
> > sense to disable kexec in this situation.
> 
> I see no match between kexec and signed kernel modules.

sig_enforce is there to prevent anyone (including root) from installing
new kernel code in the running kernel. Allowing kexec to run untrusted
code allows root to install new kernel code in the running kernel. At
the most trivial level, grab the address of sig_enforce from kallsyms,
jump to a kernel that doesn't enforce STRICT_DEVMEM, modify sig_enforce,
jump back to the old kernel.


> In fact, I personally _want_ signed kernel modules, and still the option
> to run kexec.  kexec is to run a whole new kernel/OS, not a tiny kernel
> module.

No, kexec is to run anything. It's expressly not limited to launching
new kernels. It's easiest to demonstrate an attack using a Linux kernel,
but you could launch a toy payload that did nothing other than modify
one byte and then returned to the launch kernel.

> If you apply this, you break everyone who is currently relying on kexec
> (i.e. kdump, bootloaders, etc.), from using signed kernel modules, which
> personally, seems like a very bad idea.

Enforcing signed modules provides you with no additional security if you
have kexec enabled. It's better to make that obvious.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
