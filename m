Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaE0XXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:23:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaE0XXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:23:41 -0400
Date: Tue, 27 May 2014 16:27:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Cc: Mathias Nyman <mathias.nyman@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
Message-ID: <20140527232715.GA26228@kroah.com>
References: <1401166602-26379-1-git-send-email-nyushchenko@dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401166602-26379-1-git-send-email-nyushchenko@dev.rtsoft.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 08:56:42AM +0400, Nikita Yushchenko wrote:
> This access causes hang on Freescale P2020DS board (that has OHCI
> provided by ULI 1533 chip).
> 
> Since preserving OHCI_FMINTERVAL was originally done only for NVIDIA
> hardware and only later (in c6187597) was turned unconditional, and
> c6187597 commit message again mentions only NVIDIA, I think it should be
> safe to disable preserving OHCI_FMINTERVAL if device vendor is ULI.

Have you tested this?

> Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
> ---
>  drivers/usb/host/pci-quirks.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index 00661d3..5acbd5b 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -571,7 +571,7 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
>  {
>  	void __iomem *base;
>  	u32 control;
> -	u32 fminterval;
> +	u32 uninitialized_var(fminterval);

Why is this change needed?  Sounds like a compiler bug to me :)

thanks,

greg k-h
