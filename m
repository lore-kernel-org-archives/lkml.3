Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbbALVf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:35:56 -0500
Received: from smtprelay.synopsys.com ([198.182.47.9]:56304 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbALVfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:35:55 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Robert Baldyga <r.baldyga@samsung.com>,
        "dinh.linux@gmail.com" <dinh.linux@gmail.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: dwc2: problems with IN requests completion in linux-next
Thread-Topic: dwc2: problems with IN requests completion in linux-next
Thread-Index: AQHQHfFsHlQd6983BkaIiPZOdvDDM5y9IKCA
Date: Mon, 12 Jan 2015 21:35:52 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030484506E69@US01WEMBX2.internal.synopsys.com>
References: <549826F4.6080709@samsung.com>
In-Reply-To: <549826F4.6080709@samsung.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0CLa3NJ023639

> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> Sent: Monday, December 22, 2014 6:13 AM
> 
> I have recently noticed problem with DWC2 driver in latest linux-next. I
> use it in gadget only mode at Samsung platform (Odroid U3) but I believe
> the bug can be reproduced at another platforms.
> 
> While running FFS example (tools/usb/ffs-aio-example/simple/) the
> communication breaks after few seconds. It's because one of IN requests
> enqueued in DWC2 driver do not complete. At USB analyzer I see that USB
> device started to transmit data from this request, but it ended incomplete.
> 
> I bisected kernel tree, and I got following patches are reason of break.
> 
> 941fcce usb: dwc2: Update the gadget driver to use common dwc2_hsotg
> structure
> 117777b usb: dwc2: Move gadget probe function into platform code
> bcc0607 usb: dwc2: convert to use dev_pm_ops API
> 510ffaa usb: dwc2: Initialize the USB core for peripheral mode
> db8178c usb: dwc2: Update common interrupt handler to call gadget
> interrupt handler
> 8d736d8 usb: dwc2: gadget: Do not fail probe if there isn't a clock node
> 
> Patch 941fcce breaks DWC2 driver at my platform and it starts to work
> from 8d736d8 but it has described bug.
> 
> I will try to localize reason of this issue.

Hi Robert,

I think the most likely suspect would be db8178c, since the rest appear
to be init-time things. It seems to revert cleanly, can you try
reverting just that patch and see if it helps?

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
