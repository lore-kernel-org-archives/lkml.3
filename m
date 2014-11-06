Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaKFFbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:31:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:21018 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaKFFbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:31:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,324,1413270000"; 
   d="scan'208";a="627453869"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Barto <mister.freeman@laposte.net>,
        "Tejun Heo (tj@kernel.org)" <tj@kernel.org>,
        "Lu, Aaron" <aaron.lu@intel.com>, Rafael Wysocki <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] PCI: Do not enable async suspend for JMicron chips
Thread-Topic: [PATCH] PCI: Do not enable async suspend for JMicron chips
Thread-Index: AQHP+Xdf9LB9XnS4YkW20ZDpwHx2W5xTEPHw
Date: Thu, 6 Nov 2014 05:29:55 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01EB7B96@SHSMSX101.ccr.corp.intel.com>
References: <1415151063-2530-1-git-send-email-chuansheng.liu@intel.com>
 <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com>
 <545A7087.3050802@laposte.net>
 <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com>
 <27240C0AC20F114CBF8149A2696CBE4A01EB7713@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo4py1GdxczyzgLxjbgmfGEQ6o+He=7wxuVS0BM-Oyd6_w@mail.gmail.com>
In-Reply-To: <CAErSpo4py1GdxczyzgLxjbgmfGEQ6o+He=7wxuVS0BM-Oyd6_w@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA65VpwA032724

Hello Bjorn,

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Thursday, November 06, 2014 12:09 PM
> To: Liu, Chuansheng
> Cc: Barto; Tejun Heo (tj@kernel.org); Lu, Aaron; Rafael Wysocki;
> linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
> 
> On Wed, Nov 5, 2014 at 6:48 PM, Liu, Chuansheng
> <chuansheng.liu@intel.com> wrote:
> > Hello Bjorn,
> >
> >> -----Original Message-----
> >> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> >> Sent: Thursday, November 06, 2014 3:04 AM
> >> To: Barto
> >> Cc: Liu, Chuansheng; Lu, Aaron; Tejun Heo; Rafael Wysocki;
> >> linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> >> Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
> >>
> >> On Wed, Nov 5, 2014 at 11:46 AM, Barto <mister.freeman@laposte.net>
> >> wrote:
> >> > this patch solves these 2 bug reports :
> >> >
> >> > https://bugzilla.kernel.org/show_bug.cgi?id=84861
> >> >
> >> > https://bugzilla.kernel.org/show_bug.cgi?id=81551
> >>
> >> Those bugs were already mentioned.  But e6b7e41cdd8c claims to solve
> >> https://bugzilla.kernel.org/show_bug.cgi?id=81551, and 84861 is a
> >> duplicate of 81551, so it should also be fixed by e6b7e41cdd8c.
> >>
> >> So the question is, why was e6b7e41cdd8c insufficient?  Presumably it
> >> was tested and somebody thought it did fix the problem.
> >
> > The first patch e6b7e41cdd8c which is just exclude some of JMicron
> chips(363/361) out of async_suspend,
> > then Barto found the same issue on JMicron 368, so we need one more
> general patch to let JMicron chips
> > out of async_suspend, so we make this patch.
> >
> > Bjorn, tj,
> > Could you kindly take this patch? As Barto said, it effected the user
> experience indeed, thanks.
> 
> Thanks for clarifying the changelog as far as the different chips and
> the different bugzillas.
> 
> But you haven't addressed my concerns about (1) putting a PCI vendor
> ID check in the generic PCI core code, and (2) applying this to *all*
> JMicron devices.  You might want to explore a quirk-type solution or
> maybe just add the JMicron 368 to the checks added by e6b7e41cdd8c.
Understand your point, in fact, before this patch submitted, I had written another patch https://lkml.org/lkml/2014/9/24/68
which addressed to add the quirk-type solution in ATA code, and Aaron given better suggestion that implemented at pci_pm_init().
How do you think of it? Thanks.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
