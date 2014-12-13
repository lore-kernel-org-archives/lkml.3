Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaLMXvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 18:51:48 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:54797 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaLMXvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 18:51:44 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>, "balbi@ti.com" <balbi@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: query on DWC3
Thread-Topic: query on DWC3
Thread-Index: AQHQFyw6ow7yNxqmQkOS3A5U+loSlpyOKz9w
Date: Sat, 13 Dec 2014 23:51:41 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E03048450126C@US01WEMBX2.internal.synopsys.com>
References: <CALHRZuotPpSoX9bnQin=93k0Hr7tEp_HZDaaBvfKaPfmoi_EBQ@mail.gmail.com>
In-Reply-To: <CALHRZuotPpSoX9bnQin=93k0Hr7tEp_HZDaaBvfKaPfmoi_EBQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.19]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBDNpski023717

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of sundeep subbaraya
> Sent: Friday, December 12, 2014 9:13 PM
> 
> Hi Felipe,
> 
> In DWC3 driver, for three stage Control OUT transfer there is a check:
> 
>    else if (!IS_ALIGNED(req->request.length, dep->endpoint.maxpacket)
> 
>              && (dep->number == 0)) {.
>     }
> 
> I understand that we check for alignment of sizes and if not we
> prepare trb with maxpacket and enable interrupt on short packet. In
> databook I could not find anything related to this, it talks only
> about addresses should be aligned. In Control transfer programming
> model there is no difference between Control OUT or IN transfer, if
> three stage transfer - prepare trb with length wLength. Initially I
> followed this and not able to receive data on EP0 OUT.:( .After adding
> the above check it is working. Please help me to understand why we do
> this?

Hi Sundeep,

Please see section 8.2.3.3 "Buffer Size Rules and Zero-Length Packets"
in the databook:

	For OUT endpoints, the following rules apply:

	- The total size of a Buffer Descriptor must be a multiple of
	  MaxPacketSize

The wording may be a little confusing, it actually means that the size
of the data buffer for OUT endpoints must be a multiple of MaxPacketSize.
Section 8.2.5 states it more clearly:

	- An OUT transferâ€™s transfer size (Total TRB buffer allocation)
	  must be a multiple of MaxPacketSize even if software is expecting
        a fixed non-multiple of MaxPacketSize transfer from the Host.

This rule applies to all OUT endpoint types, including Control endpoints.

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
