Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaAFLRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:17:47 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:51071 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753298AbaAFLRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:17:45 -0500
X-IronPort-AV: E=Sophos;i="4.95,612,1384297200"; 
   d="scan'208";a="51891774"
Date: Mon, 6 Jan 2014 12:17:26 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lee Jones <lee.jones@linaro.org>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Samuel Ortiz <sameo@linux.intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: sta2x11-mfd: use named constants for pci_power_t
 values
In-Reply-To: <20140106110145.GM23772@lee--X1>
Message-ID: <alpine.DEB.2.10.1401061215560.2079@hadrien>
References: <1388706031-22180-1-git-send-email-Julia.Lawall@lip6.fr> <1388706031-22180-2-git-send-email-Julia.Lawall@lip6.fr> <20140106110145.GM23772@lee--X1>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-2104864807-1389007046=:2079"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2104864807-1389007046=:2079
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 6 Jan 2014, Lee Jones wrote:

> On Fri, 03 Jan 2014, Julia Lawall wrote:
>
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > The semantic patch that makes this change is as follows:
> > (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @@
> > expression pdev;
> > @@
> >
> > pci_set_power_state(pdev,
> > - 0
> > + PCI_D0
> >  )
> > // </smpl>
>
> I'm happy with the code and that you used Coccinelle to discover the
> issue, but I feel a little more explanation would be helpful to
> readers.
>
> Why is (pci_power_t __force) 0 better than 0?

I wasn't particularly attached to the cast, and I don't know if it is an
issue.  But in trying to understand the code, I found PCI_D0 more
understandable than 0.

julia

> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> >  drivers/mfd/sta2x11-mfd.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
> > index 0d42e40..5b72db0 100644
> > --- a/drivers/mfd/sta2x11-mfd.c
> > +++ b/drivers/mfd/sta2x11-mfd.c
> > @@ -529,7 +529,7 @@ static int sta2x11_mfd_resume(struct pci_dev *pdev)
> >  {
> >  	int err;
> >
> > -	pci_set_power_state(pdev, 0);
> > +	pci_set_power_state(pdev, PCI_D0);
> >  	err = pci_enable_device(pdev);
> >  	if (err)
> >  		return err;
> >
>
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--8323329-2104864807-1389007046=:2079--
