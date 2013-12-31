Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3LaLMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 06:12:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46103 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3LaLMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 06:12:46 -0500
Date: Tue, 31 Dec 2013 14:12:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net
Subject: Re: [PATCH 2/7] vt6655: Fix most of checkpatch.pl errors in wroute
Message-ID: <20131231111225.GT28413@mwanda>
References: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
 <1388415157-17615-3-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388415157-17615-3-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 03:52:32PM +0100, Michael Gunselmann wrote:
> wroute.h: Fixed all line-over-80-character errors. No errors remain.
> wroute.c: Fixed line-over-80-character errors, bracing errors
> 	  and C99-comments.
> 	  Three warnings remain, fixing them would deteriorate readability.
> 	  One warning on a memory barrier without comment in line 189
> 	  will be fixed in a later commit because it's purpose is not
> 	  yet known.
> 

Don't do the weird indenting.

> @@ -86,22 +88,25 @@ bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uData
>  
>  	pHeadTD->m_td1TD1.byTCR = (TCR_EDP | TCR_STP);
>  
> -	memcpy(pDevice->sTxEthHeader.abyDstAddr, (unsigned char *)pbySkbData, ETH_HLEN);
> +	memcpy(pDevice->sTxEthHeader.abyDstAddr,
> +	       (unsigned char *)pbySkbData, ETH_HLEN);
>  

It would be better to fix this like so:

	memcpy(pDevice->sTxEthHeader.abyDstAddr, pbySkbData, ETH_HLEN);

> -			}
> +			else
> +				pDevice->wCurrentRate =
> +					(unsigned short)pDevice->uConnectionRate;

Remove the silly cast here as well.

				pDevice->wCurrentRate = pDevice->uConnectionRate;

Both your patch and mine are still 81 characters long.

I don't get upset by lines over 80 characters...  Eventually we will fix
that.  Just leave it as-is, until we can clean it up from a human
perspective as well as from a checkpatch.pl robot perspective.

regards,
dan carpenter

