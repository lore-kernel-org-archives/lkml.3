Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaEGIcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:32:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:31835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbaEGIcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:32:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1001,1389772800"; 
   d="scan'208";a="535048436"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Hongbo Zhang <hongbo.zhang@freescale.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "vkoul@infradead.org" <vkoul@infradead.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "leo.li@freescale.com" <leo.li@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 8/8] DMA: Freescale: add suspend resume functions for
 DMA driver
Thread-Topic: [PATCH v4 8/8] DMA: Freescale: add suspend resume functions
 for DMA driver
Thread-Index: AQHPac7AIBy/gpPWP0KQMFvNDcJ3BQ==
Date: Wed, 7 May 2014 08:31:34 +0000
Message-ID: <1399451493.2677.11.camel@smile.fi.intel.com>
References: <1397809071-5353-1-git-send-email-hongbo.zhang@freescale.com>
	 <1397809071-5353-9-git-send-email-hongbo.zhang@freescale.com>
	 <20140502164604.GB32284@intel.com> <536614E7.9050301@freescale.com>
In-Reply-To: <536614E7.9050301@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED89612B9D6244409C9C3603CF52C64A@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s478WEVC017300

On Sun, 2014-05-04 at 18:22 +0800, Hongbo Zhang wrote:
> On 05/03/2014 12:46 AM, Vinod Koul wrote:
> > On Fri, Apr 18, 2014 at 04:17:51PM +0800, hongbo.zhang@freescale.com wrote:
> >> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> >>
> >> This patch adds suspend resume functions for Freescale DMA driver.
> >> .prepare callback is used to stop further descriptors from being added into the
> >> pending queue, and also issue pending queues into execution if there is any.
> >> .suspend callback makes sure all the pending jobs are cleaned up and all the
> >> channels are idle, and save the mode registers.
> >> .resume callback re-initializes the channels by restore the mode registers.
> >>
> >> +
> >> +static const struct dev_pm_ops fsldma_pm_ops = {
> >> +	.prepare	= fsldma_prepare,
> >> +	.suspend	= fsldma_suspend,
> >> +	.resume		= fsldma_resume,
> >> +};
> > I think this is not correct. We discussed this sometime back on list. The
> > DMAengine drivers should use late resume and early suspend to ensure they get
> > suspended after clients (who should use normal ones) and resume before them
> >
> OK, will update it like this:
> use .suspend to take place of current .prepare

Could you remove this at all?

Answering to your previous statements I could say that.
Device drivers (DMAc users) that don't implement .suspend callback are
on their own with troubles, you have not to care about them in the DMA
driver.

> use .suspend_late to take place of current .suspend
> use .resume_early to take place of current .resume
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


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
