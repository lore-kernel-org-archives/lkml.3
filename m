Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbaITSQw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 14:16:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57061 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbaITSQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 14:16:51 -0400
Date: Sat, 20 Sep 2014 23:46:35 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Grzegorz Swirski <grzegorz@swirski.name>
Cc: gregkh@linuxfoundation.org, josh@joshtriplett.org,
        stankus.modestas@gmail.com, vitaly.osipov@gmail.com,
        Johannes.Stadlinger@fau.de, himangi774@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wlan-ng: remove unused 'result' var
Message-ID: <20140920181635.GA2379@sudip-PC>
References: <1411211351-4207-1-git-send-email-grzegorz@swirski.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411211351-4207-1-git-send-email-grzegorz@swirski.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 12:09:11PM +0100, Grzegorz Swirski wrote:
> Signed-off-by: Grzegorz Swirski <grzegorz@swirski.name>
you have not mentioned any commit log

> ---
>  drivers/staging/wlan-ng/prism2mib.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
> index f471708..0163e06 100644
> --- a/drivers/staging/wlan-ng/prism2mib.c
> +++ b/drivers/staging/wlan-ng/prism2mib.c
> @@ -717,8 +717,6 @@ static int prism2mib_priv(struct mibrec *mib,
>  {
>  	p80211pstrd_t *pstr = (p80211pstrd_t *) data;
>  
> -	int result;
> -
>  	switch (mib->did) {
>  	case DIDmib_lnx_lnxConfigTable_lnxRSNAIE:{
>  			hfa384x_WPAData_t wpa;
> @@ -734,11 +732,10 @@ static int prism2mib_priv(struct mibrec *mib,
>  				wpa.datalen = cpu_to_le16(pstr->len);
>  				memcpy(wpa.data, pstr->data, pstr->len);
>  
> -				result =
> -				    hfa384x_drvr_setconfig(hw,
> -						   HFA384x_RID_CNFWPADATA,
> -						   (u8 *) &wpa,
> -						   sizeof(wpa));
> +				hfa384x_drvr_setconfig(hw,
> +						       HFA384x_RID_CNFWPADATA,
> +						       (u8 *) &wpa,
if you check your patch with --strict option then you will see one warning here.

thanks
sudip
> +						       sizeof(wpa));
>  			}
>  			break;
>  		}
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
