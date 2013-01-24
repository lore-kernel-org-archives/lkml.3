Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab3AXKCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:02:47 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:43323 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab3AXKCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:02:43 -0500
Message-ID: <510106BB.2080709@mev.co.uk>
Date: Thu, 24 Jan 2013 10:02:35 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: Move comedi_pci_auto_unconfig to drivers.c
References: <1358894403-26181-1-git-send-email-peterhuewe@gmx.de> <1358895810-27115-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1358895810-27115-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-22 23:03, Peter Huewe wrote:
> Since comedi_pci_auto_unconfig cannot be inlined anymore after
>   staging/comedi: Use comedi_pci_auto_unconfig directly for
>   pci_driver.remove
> is applied, it makes sense to move it drivers.c
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>   drivers/staging/comedi/comedidev.h |    5 +----
>   drivers/staging/comedi/drivers.c   |    6 ++++++
>   2 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 6211d44..e2b7d60 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -484,10 +484,7 @@ static inline int comedi_pci_auto_config(struct pci_dev *pcidev,
>   	return comedi_auto_config(&pcidev->dev, driver, 0);
>   }
>
> -static inline void comedi_pci_auto_unconfig(struct pci_dev *pcidev)
> -{
> -	comedi_auto_unconfig(&pcidev->dev);
> -}
> +void comedi_pci_auto_unconfig(struct pci_dev *pcidev);
>
>   static inline int comedi_usb_auto_config(struct usb_interface *intf,
>   					 struct comedi_driver *driver)
> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> index 1c7d4da..87eeee5 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -558,6 +558,12 @@ void comedi_pci_driver_unregister(struct comedi_driver *comedi_driver,
>   }
>   EXPORT_SYMBOL_GPL(comedi_pci_driver_unregister);
>
> +void comedi_pci_auto_unconfig(struct pci_dev *pcidev)
> +{
> +	comedi_auto_unconfig(&pcidev->dev);
> +}
> +EXPORT_SYMBOL_GPL(comedi_pci_auto_unconfig);
> +
>   #if IS_ENABLED(CONFIG_PCMCIA)
>   int comedi_pcmcia_driver_register(struct comedi_driver *comedi_driver,
>   		struct pcmcia_driver *pcmcia_driver)
>

Embarassingly (for me) I submitted a patch to do the exact opposite 
previously, but I've no problem doing it this way if it saves some code.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
