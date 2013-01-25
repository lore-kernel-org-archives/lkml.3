Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3AYQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:56:24 -0500
Received: from relayoutw01.hubtelecom.net ([94.199.126.69]:55181 "EHLO
	relayoutw01.hubtelecom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756137Ab3AYQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:56:21 -0500
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2013 11:56:20 EST
Date: Fri, 25 Jan 2013 17:48:00 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Aaron Sierra <asierra@xes-inc.com>, Paul Bolle <pebolle@tiscali.nl>,
        Peter Hurley <peter@hurleysoftware.com>,
        =?iso-8859-1?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
Message-ID: <20130125164800.GB1174@sortiz-mobl>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
 <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
 <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Assp-Version: 2.0.1(3.0.23) on relayoutw01.hubtelecom.net
X-Assp-Message/IP-Score: 39 (Bayesian Probability: 0.9770)
X-Assp-Envelope-From: sameo@linux.intel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

On Fri, Jan 25, 2013 at 10:47:45AM +0100, Linus Walleij wrote:
> On Thu, Jan 24, 2013 at 9:52 PM, Aaron Sierra <asierra@xes-inc.com> wrote:
> 
> > In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
> > offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
> > properly be enabled (and disabled) for these chipsets.
> >
> > Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
> > Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> 
> OK... Paul, can you test this on your setup?
> 
> > @@ -858,14 +874,35 @@ wdt_done:
> >  static int lpc_ich_probe(struct pci_dev *dev,
> >                                 const struct pci_device_id *id)
> >  {
> > +       struct lpc_ich_priv *priv;
> >         int ret;
> >         bool cell_added = false;
> >
> > -       ret = lpc_ich_init_wdt(dev, id);
> > +       priv = kmalloc(GFP_KERNEL, sizeof(struct lpc_ich_priv));
> > +       if (!priv)
> > +               return -ENOMEM;
> > +
> > +       priv->chipset = id->driver_data;
> 
> So where is this id->driver_data which is just assigned to
> priv->chipset coming from again? ACPI something?
It comes from the static PCI table the driver defines itself. It allows you to
pass meta data associated to a specific PCI ID.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
