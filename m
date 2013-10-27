Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3J0IYa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 04:24:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25479 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3J0IYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 04:24:23 -0400
Date: Sun, 27 Oct 2013 11:20:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/11] Staging: bcm: Replace ULONG with unsigned long in
 Adapter.h
Message-ID: <20131027082052.GL5871@mwanda>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
 <1382768120-23380-5-git-send-email-klmckinney1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382768120-23380-5-git-send-email-klmckinney1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 02:15:14AM -0400, Kevin McKinney wrote:
> This patch replace "ULONG" with "unsigned
> long" in Adapter.h
> 
> Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
> ---
>  drivers/staging/bcm/Adapter.h |   42 ++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
> index eaf9532..4c9662b 100644
> --- a/drivers/staging/bcm/Adapter.h
> +++ b/drivers/staging/bcm/Adapter.h
> @@ -37,12 +37,12 @@ struct bcm_link_request {
>  
>  union bcm_ip_address {
>  	struct {
> -		ULONG ulIpv4Addr[MAX_IP_RANGE_LENGTH]; /* Source Ip Address Range */
> -		ULONG ulIpv4Mask[MAX_IP_RANGE_LENGTH]; /* Source Ip Mask Address Range */
> +		unsigned long ulIpv4Addr[MAX_IP_RANGE_LENGTH]; /* Source Ip Address Range */

These aren't correct in the original code btw.  ipv4 addresses should
fit in a u32.  Also it's not clear how this address is used.

It's something to think about and maybe remove or fix in later patches.

regards,
dan carpenter

