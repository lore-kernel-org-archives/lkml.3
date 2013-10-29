Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3J2VpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:45:18 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45689 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3J2VpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:45:16 -0400
Message-ID: <52702C68.5060603@gmail.com>
Date: Tue, 29 Oct 2013 14:45:12 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Laurent Navet <laurent.navet@gmail.com>, Luka Perkov <luka@openwrt.org>
CC: davem@davemloft.net, jiri@resnulli.us, david.daney@cavium.com,
        wfp5p@virginia.edu, gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] octeon_mgmt: remove double validation of mac address
References: <1383082053-12405-1-git-send-email-laurent.navet@gmail.com>
In-Reply-To: <1383082053-12405-1-git-send-email-laurent.navet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 02:27 PM, Laurent Navet wrote:
> Mac address validity is already checked in of_get_mac_address().
> No need to do it twice.
>
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Luka already sent this exact patch, and I acked his.

No need to do it twice.

David Daney


> ---
>   drivers/net/ethernet/octeon/octeon_mgmt.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/octeon/octeon_mgmt.c b/drivers/net/ethernet/octeon/octeon_mgmt.c
> index 622aa75..1b326cbc 100644
> --- a/drivers/net/ethernet/octeon/octeon_mgmt.c
> +++ b/drivers/net/ethernet/octeon/octeon_mgmt.c
> @@ -1545,7 +1545,7 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
>
>   	mac = of_get_mac_address(pdev->dev.of_node);
>
> -	if (mac && is_valid_ether_addr(mac))
> +	if (mac)
>   		memcpy(netdev->dev_addr, mac, ETH_ALEN);
>   	else
>   		eth_hw_addr_random(netdev);
>

