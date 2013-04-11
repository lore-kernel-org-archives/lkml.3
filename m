Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161330Ab3DKNao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:30:44 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:21909 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935388Ab3DKNal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:30:41 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI936eI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2fh2a8h668h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 2/3] Revert "x86, efivars: firmware bug workarounds
 should be in platform code"
Thread-Topic: [PATCH V4 2/3] Revert "x86, efivars: firmware bug workarounds
 should be in platform code"
Thread-Index: AQHONhNZQkKbbp210UGsmxOewwMrjZjRA42AgAAByoA=
Date: Thu, 11 Apr 2013 13:30:35 +0000
Message-ID: <1365687035.13667.5.camel@x230.lan>
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com>
	 <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com>
	 <1365615967-27346-2-git-send-email-matthew.garrett@nebula.com>
	 <5166B97B.6080806@console-pimps.org>
In-Reply-To: <5166B97B.6080806@console-pimps.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E472668B9646F54DB4F377FDD4FE77D0@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3BDUtXQ003478

On Thu, 2013-04-11 at 14:24 +0100, Matt Fleming wrote:
> On 10/04/13 18:46, Matthew Garrett wrote:
> > This reverts commit a6e4d5a03e9e3587e88aba687d8f225f4f04c792. Doing this
> > workaround properly requires us to work within the variable code.
> > 
> > Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> > ---
> >  arch/x86/platform/efi/efi.c | 25 -------------------------
> >  drivers/firmware/efivars.c  | 18 +++++++++++++++---
> >  include/linux/efi.h         |  9 +--------
> >  3 files changed, 16 insertions(+), 36 deletions(-)
> 
> Does it really? Why can't you just hook into the get_next_variable() and
> set_variable() functions in arch/x86/platform/efi/efi.c?

struct efi_variable isn't exported from efivars.c, and chunks of the
workaround need to be called at efivars init anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
