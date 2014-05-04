Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaEDBOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:14:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaEDBON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:14:13 -0400
Date: Sat, 3 May 2014 20:26:17 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin Kepplinger <martink@posteo.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8821ae: mark pointer in pci_iounmap as
 __iomem
Message-ID: <20140504002617.GA16403@kroah.com>
References: <1399129848-1833-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399129848-1833-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 05:10:48PM +0200, Martin Kepplinger wrote:
> pci_iounmap is used that way in drivers/net/wireless/rtlwifi and this
> fixes sparse warnings.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
>  drivers/staging/rtl8821ae/pci.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
> index a562aa6..d934ecb 100644
> --- a/drivers/staging/rtl8821ae/pci.c
> +++ b/drivers/staging/rtl8821ae/pci.c
> @@ -2416,7 +2416,7 @@ fail3:
>  	ieee80211_free_hw(hw);
>  
>  	if (rtlpriv->io.pci_mem_start != 0)
> -		pci_iounmap(pdev, (void *)rtlpriv->io.pci_mem_start);
> +		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);

Shouldn't pci_mem_start be a __iomem pointer instead?

thanks,

greg k-h
