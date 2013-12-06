Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab3LFHig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:38:36 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54880 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897Ab3LFHid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:38:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579eh6cdkz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Fri, 6 Dec 2013 15:08:46 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 v5] Fix Internal error: : 808 [#1] ARM related to
 STS flag
Message-ID: <20131206070845.GG14002@shlinux1.ap.freescale.net>
References: <1386122179-4158-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1386122179-4158-2-git-send-email-chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1386122179-4158-2-git-send-email-chris.ruehl@gtsys.com.hk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 09:56:18AM +0800, Chris Ruehl wrote:
> Fix Internal error: : 808 [#1] ARM related to STS flag
> 
> * init the sts flag to 0 (missed)
> * fix write the real bit not sts value
> * Set PORTCS_STS and DEVLC_STS only if sts = 1
>  (prefered solution by Mr. Peter Chen, Maintainer of ChipIdea subsystem)
> 
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> ---
>  drivers/usb/chipidea/core.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 9a5ef20..2834801 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -243,7 +243,7 @@ static int hw_device_init(struct ci_hdrc *ci, void __iomem *base)
>  
>  static void hw_phymode_configure(struct ci_hdrc *ci)
>  {
> -	u32 portsc, lpm, sts;
> +	u32 portsc, lpm, sts = 0;
>  
>  	switch (ci->platdata->phy_mode) {
>  	case USBPHY_INTERFACE_MODE_UTMI:
> @@ -273,10 +273,12 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
>  
>  	if (ci->hw_bank.lpm) {
>  		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
> -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> +		if (sts)
> +			hw_write(ci, OP_DEVLC, DEVLC_STS, DEVLC_STS);
>  	} else {
>  		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> +		if (sts)
> +			hw_write(ci, OP_PORTSC, PORTSC_STS, PORTSC_STS);
>  	}
>  }
>  
> -- 
> 1.7.10.4
> 
> 

Applied, Thanks.

-- 

Best Regards,
Peter Chen

