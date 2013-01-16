Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab3APSS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:18:58 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54165 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab3APSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:18:56 -0500
Date: Wed, 16 Jan 2013 18:25:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <balbi@ti.com>
Cc: Alan Cox <alan@linux.intel.com>, <arve@android.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <mikechan@google.com>
Subject: Re: [PATCH 03/10] goldfish: tty driver
Message-ID: <20130116182520.64b1fe6a@pyramind.ukuu.org.uk>
In-Reply-To: <20130116170122.GB6377@arwen.pp.htv.fi>
References: <20130116165552.15183.92942.stgit@bob.linux.org.uk>
	<20130116165902.15183.60134.stgit@bob.linux.org.uk>
	<20130116170122.GB6377@arwen.pp.htv.fi>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 19:01:22 +0200
Felipe Balbi <balbi@ti.com> wrote:

> Hi,
> 
> On Wed, Jan 16, 2013 at 04:59:03PM +0000, Alan Cox wrote:
> > +static int goldfish_tty_probe(struct platform_device *pdev)
> > +{
> > +	struct goldfish_tty *qtty;
> > +	int ret = -EINVAL;
> > +	int i;
> > +	struct resource *r;
> > +	struct device *ttydev;
> > +	void __iomem *base;
> > +	u32 irq;
> > +
> > +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if(r == NULL)
> > +		return -EINVAL;
> > +
> > +	base = ioremap(r->start, 0x1000);
> 
> missing request_mem_region(), in fact you could just use
> devm_request_and_ioremap().

Actually the reservation is already done by the bus driver. If it sees
the goldfish interface it reserves the entire chunk and the emulator then
tells it which is in each chunk of that range.

It's reserving it as the wrong type however so I do need to fix that.

Alan
