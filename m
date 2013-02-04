Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3BDPiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:38:22 -0500
Received: from xes-mad.com ([216.165.139.218]:50591 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab3BDPiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:38:21 -0500
Date: Mon, 04 Feb 2013 09:38:15 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: =?iso-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
Message-ID: <c9391ccb-e37a-4f3d-b71d-44e6a046a490@zimbra>
In-Reply-To: <20130203170213.GQ8476@sortiz-mobl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC23 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 24, 2013 at 02:52:39PM -0600, Aaron Sierra wrote:
> > In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found
> > at
> > offsets 0x58 and 0x5C, respectively. This patch allows GPIO access
> > to
> > properly be enabled (and disabled) for these chipsets.
> > 
> > Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
> > Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> > ---
> >  drivers/mfd/lpc_ich.c |  109
> >  ++++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 76 insertions(+), 33 deletions(-)
> I applied this one to my for-next branch, but:
> 
> 
> > @@ -858,14 +874,35 @@ wdt_done:
> >  static int lpc_ich_probe(struct pci_dev *dev,
> >  				const struct pci_device_id *id)
> >  {
> > +	struct lpc_ich_priv *priv;
> >  	int ret;
> >  	bool cell_added = false;
> > 
> > -	ret = lpc_ich_init_wdt(dev, id);
> > +	priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
> > +	if (!priv)
> > +		return -ENOMEM;
> Could you please come back to me with a follow up patch that would
> convert this to the devm_kzalloc() API ?

Yeah, no problem.

-Aaron S.
