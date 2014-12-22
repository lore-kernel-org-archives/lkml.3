Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaLVONP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:13:15 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27375 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbaLVONM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:13:12 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-db-549826f6a86f
Message-id: <549826F4.6080709@samsung.com>
Date: Mon, 22 Dec 2014 15:13:08 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: dinh.linux@gmail.com
Cc: "paulz@synopsys.com >> Paul Zimmerman" <paulz@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>, gregkh@linuxfoundation.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: usb: dwc2: problems with IN requests completion in linux-next
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xa7rf1GaEGKz/J2px8H69xcqT2hbN
	i9ezWVzeNYfNYtGyVmaLtUfusltsnzKdyYHdY+esu+we++euYffo27KK0WPL/s+MHsdvbGfy
	+LxJLoAtissmJTUnsyy1SN8ugStj680f7AVLOSsm95g0MB5m72Lk5JAQMJFYP/cFC4QtJnHh
	3nq2LkYuDiGBpYwSLbffMIEkhAQ+MkpsesoPYvMKaElcft7GBmKzCKhKLDtxDqyZTUBHYsv3
	CYwgtqhAhMSVNXMYIeoFJX5MvgdWIyIgITG5YwnYAmaB5UwS19Z8AbtCWMBNYt3cVcxdjBxA
	CXWJKVNyQcLMAvISm9e8ZZ7AyDcLyahZCFWzkFQtYGRexSiaWppcUJyUnmukV5yYW1yal66X
	nJ+7iREStl93MC49ZnWIUYCDUYmHt2PVtBAh1sSy4srcQ4wSHMxKIryHP08PEeJNSaysSi3K
	jy8qzUktPsTIxMEp1cAobX5H11DVKbpFR9hvua7/q5uM/w3CT737V7qVs/WcvDz7VOa6r1ej
	5jQY13WdZ/zMsHNB1xf5xQ0Gdz/q31j/yFD7tjfnp2VvGj2b7Y20LwWtZnfU38/RnbY7/Naf
	QGeO0z/eu8a/rqs9vq9bXafsevmyhV8W568R4/PZ42TGaXXsKPdHhW4lluKMREMt5qLiRABd
	24e7OQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have recently noticed problem with DWC2 driver in latest linux-next. I
use it in gadget only mode at Samsung platform (Odroid U3) but I believe
the bug can be reproduced at another platforms.

While running FFS example (tools/usb/ffs-aio-example/simple/) the
communication breaks after few seconds. It's because one of IN requests
enqueued in DWC2 driver do not complete. At USB analyzer I see that USB
device started to transmit data from this request, but it ended incomplete.

I bisected kernel tree, and I got following patches are reason of break.

941fcce usb: dwc2: Update the gadget driver to use common dwc2_hsotg
structure
117777b usb: dwc2: Move gadget probe function into platform code
bcc0607 usb: dwc2: convert to use dev_pm_ops API
510ffaa usb: dwc2: Initialize the USB core for peripheral mode
db8178c usb: dwc2: Update common interrupt handler to call gadget
interrupt handler
8d736d8 usb: dwc2: gadget: Do not fail probe if there isn't a clock node

Patch 941fcce breaks DWC2 driver at my platform and it starts to work
from 8d736d8 but it has described bug.

I will try to localize reason of this issue.

Best regards,
Robert Baldyga
