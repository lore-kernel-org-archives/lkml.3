Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab3AYNqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:46:04 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:46904 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754596Ab3AYNqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:46:02 -0500
Message-ID: <1359121486.3287.11.camel@thor.lan>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Peter Hurley <peter@hurleysoftware.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Aaron Sierra <asierra@xes-inc.com>, Paul Bolle <pebolle@tiscali.nl>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?ISO-8859-1?Q?Ag=F3cs_P=E1l?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 25 Jan 2013 08:44:46 -0500
In-Reply-To: <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	 <3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	 <CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 10:47 +0100, Linus Walleij wrote:
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

That's how pci device probing works.

The driver defines a struct pci_device_id[] table with
DEFINE_PCI_DEVICE_TABLE(), initializing the .driver_data fields with an
index into a static array of device types (in this case, struct
lpc_ich_info lpc_chipset_info[]), and the pci subsystem passes the
actual matching pci_device_id* to the driver's probe() function.

There's more information in Documentation/pci.txt

Regards,
Peter Hurley


