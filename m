Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab3HIPHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:07:31 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:24186
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933972Ab3HIPHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:07:30 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: Disable at runtime if the kernel enforces module
 signing
Thread-Topic: [PATCH] kexec: Disable at runtime if the kernel enforces
 module signing
Thread-Index: AQHOlNUf4AGnYDKZIEqWyysq/RT6S5mMthMAgABEgAA=
Date: Fri, 9 Aug 2013 15:07:13 +0000
Message-ID: <1376060830.2021.12.camel@x230>
References: <1376033797-24970-1-git-send-email-matthew.garrett@nebula.com>
	 <20130809110200.GA9631@redhat.com>
In-Reply-To: <20130809110200.GA9631@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0933E9FD8D
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(189002)(51704005)(199002)(76786001)(19580405001)(63696002)(76796001)(54316002)(33646001)(81342001)(56816003)(16406001)(56776001)(47976001)(47446002)(53806001)(77096001)(19580395003)(83072001)(79102001)(49866001)(74876001)(81686001)(83322001)(33716001)(80976001)(74502001)(65816001)(59766001)(54356001)(81542001)(31966008)(50986001)(46102001)(69226001)(76482001)(47736001)(74366001)(51856001)(74706001)(77982001)(80022001)(4396001)(74662001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB223;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <8568498441B3B64CA6F2BCDCB2F07B15@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r79F7ZNR010661

On Fri, 2013-08-09 at 07:02 -0400, Vivek Goyal wrote:
> On Fri, Aug 09, 2013 at 03:36:37AM -0400, Matthew Garrett wrote:
> > kexec permits the loading and execution of arbitrary code in ring 0, which
> > is something that module signing enforcement is meant to prevent. It makes
> > sense to disable kexec in this situation.
> > 
> 
> But in the process we wipe out running kernel's context and boot into a new
> kernel. So how different it is than root booting a new kernel through BIOS
> which does not enforce module signing.

What wipes the current kernel's context? KEXEC_JUMP is explicitly
designed to allow you to hop back and forth, but even without it you
should be able to reconstruct the original context. And there's no need
to boot a new kernel, either. All the attacker needs is the physical
address of the sig_enforce boolean, and then they launch a simple kexec
payload that simply flips that back and returns to the original kernel -
it's not like kexec limits you to booting Linux.

> Also it would be nice if we introduce new features, then we make other
> features work with those new features instead of disabling existing
> features and leave it to other people to make them work.

Sure, it'd be nice if security features got introduced with
consideration to other kernel features that allow them to be
circumvented, but this approach seems better than making them
incompatible at the Kconfig level.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
