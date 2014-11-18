Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaKRB7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:59:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaKRB7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:59:49 -0500
Date: Mon, 17 Nov 2014 17:59:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Tobenna P. Igwe" <ptigwe@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging:rtl8723au: Fix sparse warning cast to restricted
 __le16
Message-ID: <20141118015947.GA21650@kroah.com>
References: <20141118014529.GA937@Tobenna-Peter-Igwes-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118014529.GA937@Tobenna-Peter-Igwes-MacBook-Pro.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 01:45:41AM +0000, Tobenna P. Igwe wrote:
> This patch fixes the following sparse warning:
> 
> drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c:343:36: warning:
> cast to restricted __le16
> 
> by using the le16_to_cpus function.
> 
> Signed-off-by: Tobenna P. Igwe <ptigwe@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> index d80ea4e..78665ee 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> @@ -340,7 +340,7 @@ static u8 bthci_GetAssocInfo(struct rtw_adapter *padapter, u8 EntryNum)
>  			tempBuf, TotalLen-BaseMemoryShift);
>  
>  		pAmpAsoc = (struct amp_assoc_structure *)tempBuf;
> -		pAmpAsoc->Length = le16_to_cpu(pAmpAsoc->Length);
> +		le16_to_cpus(&pAmpAsoc->Length);

This doesn't change the logic, and you should still have the same
warning.  How about fixing up Length to be the proper endian type?

thanks,

greg k-h
