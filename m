Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaAWNip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:38:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:61612 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaAWNin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:38:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,706,1384329600"; 
   d="scan'208";a="443458196"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Srikanth Thokala <sthokal@xilinx.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
Subject: Re: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
Thread-Topic: [PATCH v2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
Thread-Index: AQHPGEBrkYhUftUf0k+A2fvAkjPdqg==
Date: Thu, 23 Jan 2014 13:38:37 +0000
Message-ID: <1390484317.7619.81.camel@smile>
References: <1390409565-4200-1-git-send-email-sthokal@xilinx.com>
	 <1390409565-4200-2-git-send-email-sthokal@xilinx.com>
	 <52E0FC22.8060903@metafoo.de>
In-Reply-To: <52E0FC22.8060903@metafoo.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF2F9C8839194F4C8194B17569A6F1F3@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0NDcp7H023911

On Thu, 2014-01-23 at 12:25 +0100, Lars-Peter Clausen wrote:
> On 01/22/2014 05:52 PM, Srikanth Thokala wrote:

[...]

> > +	/* Request the interrupt */
> > +	chan->irq = irq_of_parse_and_map(node, 0);
> > +	err = devm_request_irq(xdev->dev, chan->irq, xilinx_vdma_irq_handler,
> > +			       IRQF_SHARED, "xilinx-vdma-controller", chan);
> 
> This is a clasic example of where to not use devm_request_irq. 'chan' is
> accessed in the interrupt handler, but if you use devm_request_irq 'chan'
> will be freed before the interrupt handler has been released, which means
> there is now a race condition where the interrupt handler can access already
> freed memory.

Could you elaborate this case? As far as I understood managed resources
are a kind of stack pile. In this case you have no such condition. Where
am I wrong?


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
