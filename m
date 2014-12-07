Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaLGUpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:45:20 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:41310
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329AbaLGUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:45:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="92296524"
Date: Sun, 7 Dec 2014 21:45:15 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Jeremiah Mahler <jmmahler@gmail.com>
cc: kernel-janitors@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/20] USB: isp1760: fix misspelling of current function
 in string
In-Reply-To: <20141207204138.GA5360@hudson.localdomain>
Message-ID: <alpine.DEB.2.02.1412072143460.2235@localhost6.localdomain6>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr> <1417980062-25151-9-git-send-email-Julia.Lawall@lip6.fr> <20141207204138.GA5360@hudson.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Dec 2014, Jeremiah Mahler wrote:

> Julia,
> 
> On Sun, Dec 07, 2014 at 08:20:50PM +0100, Julia Lawall wrote:
> > Replace a misspelled function name by %s and then __func__.
> > 
> > The function name starts with isp, not ips.
> > 
> > This was done using Coccinelle, including the use of Levenshtein distance,
> > as proposed by Rasmus Villemoes.
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > ---
> > The semantic patch is difficult to summarize, but is available in the cover
> > letter of this patch series.
> > 
> >  drivers/usb/host/isp1760-if.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/host/isp1760-if.c b/drivers/usb/host/isp1760-if.c
> > index 09254a4..939d376 100644
> > --- a/drivers/usb/host/isp1760-if.c
> > +++ b/drivers/usb/host/isp1760-if.c
> > @@ -318,7 +318,7 @@ static void isp1761_pci_remove(struct pci_dev *dev)
> >  
> >  static void isp1761_pci_shutdown(struct pci_dev *dev)
> >  {
> > -	printk(KERN_ERR "ips1761_pci_shutdown\n");
> > +	printk(KERN_ERR "%s\n", __func__);
> >  }
> >  
> You can also switch from printk to pr_err and that would fix thte
> checkpatch warning for this patch.

Yeah, I didn't want to do too much at once, since tha could be done all at 
once in a lot of other places too.  But I will fix up this one.

julia

> >  static const struct pci_device_id isp1760_plx [] = {
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> - Jeremiah Mahler
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
