Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaIHTOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:14:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaIHTOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:14:46 -0400
Date: Mon, 8 Sep 2014 12:14:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: driverdev-devel@linuxdriverproject.org,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: amplc_pci230: fix DACOUT write
Message-ID: <20140908191445.GA32320@kroah.com>
References: <1408447956-10139-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408447956-10139-1-git-send-email-abbotti@mev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 12:32:36PM +0100, Ian Abbott wrote:
> Commit 4f9c63fe5333b27ab23ed399830c7977f6970744 ("staging: comedi:
> amplc_pci230: refactor iobase addresses") removed some parentheses
> (presumably to keep the line withing 80 chars) in
> `pci230_ao_write_nofifo()` when writing to the DACOUT1 or DACOUT2
> registers, but it removed the wrong parentheses.  Fix it.
> 
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> This bug is in linux-next master and staging-next.
> ---
>  drivers/staging/comedi/drivers/amplc_pci230.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
> index 0fd212f..dd69e47 100644
> --- a/drivers/staging/comedi/drivers/amplc_pci230.c
> +++ b/drivers/staging/comedi/drivers/amplc_pci230.c
> @@ -628,7 +628,7 @@ static inline void pci230_ao_write_nofifo(struct comedi_device *dev,
>  
>  	/* Write mangled datum to appropriate DACOUT register. */
>  	outw(pci230_ao_mangle_datum(dev, datum),
> -	     devpriv->daqio + ((chan) == 0) ? PCI230_DACOUT1 : PCI230_DACOUT2);
> +	     devpriv->daqio + (chan == 0 ? PCI230_DACOUT1 : PCI230_DACOUT2));
>  }
>  
>  static inline void pci230_ao_write_fifo(struct comedi_device *dev,
> -- 
> 2.0.4

This doesn't apply to my tree anymore, is it still needed?

thanks,

greg k-h
