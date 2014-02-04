Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936665AbaBDXMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:12:42 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49970 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558AbaBDVAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:00:32 -0500
Date: Tue, 4 Feb 2014 14:57:14 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH v5 4/6] spmi: pmic_arb: add support for interrupt handling
Message-ID: <20140204205714.GN20228@joshc.qualcomm.com>
References: <1391468739-20987-1-git-send-email-joshc@codeaurora.org>
 <1391468739-20987-5-git-send-email-joshc@codeaurora.org>
 <alpine.DEB.2.02.1402042107311.24986@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402042107311.24986@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 09:10:45PM +0100, Thomas Gleixner wrote:
> On Mon, 3 Feb 2014, Josh Cartwright wrote:
> > +static void qpnpint_irq_ack(struct irq_data *d)
> > +{
> > +	struct spmi_pmic_arb_dev *pa = irq_data_get_irq_chip_data(d);
> > +	u8 irq  = d->hwirq >> 8;
> > +	u8 apid = d->hwirq;
> > +	unsigned long flags;
> > +	u8 data;
> > +
> > +	spin_lock_irqsave(&pa->lock, flags);
> 
> This wants to be a raw_spinlock - think about RT!

Indeed.  I'll change this in the next revision.

> Looks sane otherwise.

Great, thanks for taking a look!

  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
