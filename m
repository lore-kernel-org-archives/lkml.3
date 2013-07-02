Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab3GBURi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:17:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58622 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab3GBURg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:17:36 -0400
Message-ID: <1372796218.21065.87.camel@cumari.coelho.fi>
Subject: Re: [PATCH v2 5/9] wlcore: always use one-shot IRQ
From: Luciano Coelho <coelho@ti.com>
To: <balbi@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Tue, 2 Jul 2013 23:16:58 +0300
In-Reply-To: <20130702153229.GG7013@arwen.pp.htv.fi>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
	 <1372776948-24840-6-git-send-email-coelho@ti.com>
	 <20130702153229.GG7013@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 18:32 +0300, Felipe Balbi wrote:
> On Tue, Jul 02, 2013 at 05:55:44PM +0300, Luciano Coelho wrote:
> > Since we are now using threaded IRQs without the primary handler, we
> > need to set IRQF_ONESHOT, otherwise our request will fail.
> > 
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> 
> good to see this happening, I remember we talked about this a while back
> :-)

Yeah, we talked about it and I did the patch immediately.  This is
needed because this is obviously not set automatically in the interrupts
created via device tree.


> Acked-by: Felipe Balbi <balbi@ti.com>
> 
> Still, if you call irq_set_irq_type() on board-file (since DT will do
> something similar for you anyway) then you can completely drop
> irq_flags.

Yep.

--
Luca.

