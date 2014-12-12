Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967750AbaLLMfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:35:39 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:7633 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966556AbaLLMfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:35:38 -0500
From: Sifan Naeem <Sifan.Naeem@imgtec.com>
To: James Hogan <James.Hogan@imgtec.com>,
        "mchehab@osg.samsung.com" <mchehab@osg.samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>
Subject: RE: [PATCH 3/5] rc: img-ir: biphase enabled with workaround
Thread-Topic: [PATCH 3/5] rc: img-ir: biphase enabled with workaround
Thread-Index: AQHQD9hz2MhHdqlgJU6fRi14UuxI+5yF9hoAgATRHsCAAQ1jAIAAGtTg
Date: Fri, 12 Dec 2014 12:35:35 +0000
Message-ID: <A0E307549471DA4DBAF2DE2DE6CBFB7E4956495A@hhmail02.hh.imgtec.org>
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com>
 <1417707523-7730-4-git-send-email-sifan.naeem@imgtec.com>
 <5485DD40.60500@imgtec.com>
 <A0E307549471DA4DBAF2DE2DE6CBFB7E49564260@hhmail02.hh.imgtec.org>
 <548AC9A4.5020802@imgtec.com>
In-Reply-To: <548AC9A4.5020802@imgtec.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.167.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: James Hogan
> Sent: 12 December 2014 10:56
> To: Sifan Naeem; mchehab@osg.samsung.com
> Cc: linux-kernel@vger.kernel.org; linux-media@vger.kernel.org; James
> Hartley; Ezequiel Garcia
> Subject: Re: [PATCH 3/5] rc: img-ir: biphase enabled with workaround
> 
> Hi Sifan,
> 
> On 11/12/14 18:54, Sifan Naeem wrote:
> >>> +/*
> >>> + * Timer function to re-enable the current protocol after it had
> >>> +been
> >>> + * cleared when invalid interrupts were generated due to a quirk in
> >>> +the
> >>> + * img-ir decoder.
> >>> + */
> >>> +static void img_ir_suspend_timer(unsigned long arg) {
> >>> +	struct img_ir_priv *priv = (struct img_ir_priv *)arg;
> >>> +
> >>> +	img_ir_write(priv, IMG_IR_IRQ_CLEAR,
> >>> +			IMG_IR_IRQ_ALL & ~IMG_IR_IRQ_EDGE);
> >>> +
> >>> +	/* Don't set IRQ if it has changed in a different context. */
> >>
> >> Should you even be clearing IRQs in that case? Maybe safer to just
> >> treat that case as a "return immediately without touching anything" sort
> of situation.
> >>
> > don't have to clear it for this work around to work, so will remove.
> >
> >>> +	if ((priv->hw.suspend_irqen & IMG_IR_IRQ_EDGE) ==
> >>> +				img_ir_read(priv, IMG_IR_IRQ_ENABLE))
> >>> +		img_ir_write(priv, IMG_IR_IRQ_ENABLE, priv-
> >>> hw.suspend_irqen);
> >>> +	/* enable */
> >>> +	img_ir_write(priv, IMG_IR_CONTROL, priv->hw.reg_timings.ctrl); }
> 
> To clarify, I was only referring to the case where the irq mask has changed
> unexpectedly. If it hasn't changed then it would seem to make sense to clear
> pending interrupts (i.e. the ones we've been intentionally ignoring) before
> re-enabling them.
> 
> When you say it works without, do you mean there never are pending
> interrupts (if you don't press any other buttons on the remote)?
> 
Nope, with the change I submitted in v2 (removed the clearing IRQ) there are no pending interrupts at the end.
But as before it goes through the workaround couple of times for each interrupt before settling down.

Thanks,
Sifan

> Cheers
> James

