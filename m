Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbbAJBuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:50:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbbAJBuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:50:06 -0500
Date: Fri, 9 Jan 2015 17:50:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging, addi_apci_1500: fix IRQ spew
Message-ID: <20150110015006.GA20327@kroah.com>
References: <20141210144140.3964.42851.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210144140.3964.42851.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 02:42:01PM +0000, Alan Cox wrote:
> The driver very carefully checks if the card is the IRQ source, and if it
> isn't thoughtfully spews crap at_dev_warn() level. Remove the spewage so it
> can be used on a shared interrupt line.
> 
> Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=88651
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
> index 0ea081e..b7b9857 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
> @@ -2175,10 +2175,6 @@ static void apci1500_interrupt(int irq, void *d)
>  			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
>  		/* Authorizes the main interrupt on the board */
>  		outb(0xD0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
> -	} else {
> -		dev_warn(dev->class_dev,
> -			"Interrupt from unknown source\n");
> -
>  	}
>  }
>  

No longer applies to my tree due to other changes in this driver :(

thanks,

greg k-h
