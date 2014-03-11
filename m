Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaCKKXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:23:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:25755 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbaCKKXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="497583279"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Emilio Lopez <emilio@elopez.com.ar>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Mike Turquette" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>
Subject: Re: [PATCH v4 6/7] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Thread-Topic: [PATCH v4 6/7] DMA: sun6i: Add driver for the Allwinner A31
 DMA controller
Thread-Index: AQHPPG9hIxuu0Logt0GmcPgzrWXe9Zrbq2nNgAADboA=
Date: Tue, 11 Mar 2014 10:22:52 +0000
Message-ID: <1394533371.28803.226.camel@smile.fi.intel.com>
References: <1394462512-11620-1-git-send-email-maxime.ripard@free-electrons.com>
	 <1394462512-11620-7-git-send-email-maxime.ripard@free-electrons.com>
	 <1394531574.28803.222.camel@smile.fi.intel.com>
	 <20140311100838.GQ2815@lukather>
In-Reply-To: <20140311100838.GQ2815@lukather>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.73]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CED5AC128720543915943A8B6C44424@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2BANsqL024279

On Tue, 2014-03-11 at 11:08 +0100, Maxime Ripard wrote:

[]

> > > +	spin_lock_irq(&sdev->lock);
> > > +	for (pchan_idx = 0; pchan_idx < NR_MAX_CHANNELS; pchan_idx++) {
> > > +		pchan = &sdev->pchans[pchan_idx];
> > > +
> > > +		if (pchan->vchan == NULL && !list_empty(&sdev->pending)) {
> > 
> > !pchan->vchan && ...
> 
> Ok.
> 
> > And you may decrease indentation level here if you use negative
> > condition.
> 
> Hmmm, I'm not following you here. What do you mean?

for () {
...
if (!(your current condition))
 continue;
... (do something else with decreased indentation level)
}

> > > +			vchan = list_first_entry(&sdev->pending,
> > > +						 struct sun6i_vchan, node);
> > > +
> > > +			/* Remove from pending channels */
> > > +			list_del_init(&vchan->node);
> > > +			pchan_alloc |= BIT(pchan_idx);
> > > +
> > > +			/* Mark this channel allocated */
> > > +			pchan->vchan = vchan;
> > > +			vchan->phy = pchan;
> > > +			dev_dbg(sdev->slave.dev, "pchan %u: alloc vchan %p\n",
> > > +				pchan->idx, &vchan->vc);
> > > +		}
> > > +	}
> > > +	spin_unlock_irq(&sdev->lock);
> > > +
> > > +	for (pchan_idx = 0; pchan_idx < NR_MAX_CHANNELS; pchan_idx++) {
> > > +		if (pchan_alloc & BIT(pchan_idx)) {
> > 
> > Ditto.

Same here.

[]

> > > +#ifdef DEBUG
> > > +	dev_dbg(chan2dev(chan), "First: %pad\n", &txd->p_lli);
> > 
> > dev_dbg is aware of DEBUG. So, please, remove that #ifdef at all.
> 
> Yep, but the line just below isn't.
> 
> The ifdef here is not really to prevent the call to dev_dbg, but rather...
> 
> > > +	for (prev = txd->v_lli; prev != NULL; prev = prev->v_lli_next)
> 
> ... this.

It doesn't matter since implementation of sun6i_dma_dump_lli is (and
actually should be) aware of DEBUG already, because it's dev_dbg based.

> > 
> > You may remove '!= NULL' part.
> 
> Ok.
> 
> > > +		sun6i_dma_dump_lli(vchan, prev);
> > > +#endif




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
