Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaKSDqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:46:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaKSDqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:46:38 -0500
Date: Tue, 18 Nov 2014 19:45:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hung <hpeter@gmail.com>
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH] serial: fix io address assign method with Fintek
 PCI-to-UART Product
Message-ID: <20141119034518.GB15293@kroah.com>
References: <1416364553-29982-1-git-send-email-hpeter+linux_kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416364553-29982-1-git-send-email-hpeter+linux_kernel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:35:53AM +0800, Peter Hung wrote:
> The original driver fixed the io address with 0xe000+idx*8, but real io address assigned from BIOS
> is dynamically from read PCI configure space 0x24, 0x20, 0x1c.
> 
> The Fintek F81504/F81508/F81512 maybe malfunction without this patch and malfunction surely when
> more the 1 PCI card.

Please wrap these lines at 72 columns please, like git wants you to.

> 
> Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>
> ---
>  drivers/tty/serial/8250/8250_pci.c | 63 ++++++++++++++++++++++++++++----------
>  1 file changed, 47 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
> index 0468e15..6dfa227 100644
> --- a/drivers/tty/serial/8250/8250_pci.c
> +++ b/drivers/tty/serial/8250/8250_pci.c
> @@ -1551,28 +1551,51 @@ static int pci_fintek_setup(struct serial_private *priv,
>  {
>  	struct pci_dev *pdev = priv->dev;
>  	unsigned long base;
> -	unsigned long iobase;
> +	unsigned long iobase = 0;

Why initialize this to 0?  That shouldn't be needed as you set it later
in the function before you use it, right?

Care to try again?

thanks,

greg k-h
