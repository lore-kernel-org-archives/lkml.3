Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaIOQQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:16:47 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:63764 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaIOQQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:16:45 -0400
Message-ID: <541710EA.7090809@gmail.com>
Date: Mon, 15 Sep 2014 09:16:42 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
CC: David Daney <david.daney@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luka Perkov <luka@openwrt.org>, Willem de Bruijn <willemb@google.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/1 v2] netdev: octeon_mgmt: ISO C90 forbids mixed declarations
 and code
References: <1410670935-904-1-git-send-email-xypron.glpk@gmx.de>
In-Reply-To: <1410670935-904-1-git-send-email-xypron.glpk@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2014 10:02 PM, Heinrich Schuchardt wrote:
> Revised patch takes into account comments by Joe and David.
>
> Compiling with OCTEON_MGMT_ETHERNET gives a warning
> drivers/net/ethernet/octeon/octeon_mgmt.c:295:4:
> warning: ISO C90 forbids mixed declarations and code
> [-Wdeclaration-after-statement]
>
> The patch cleans up the code.
>
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> CC: Joe Perches <joe@perches.com>
> CC: David S. Miller <davem@davemloft.net>
> ---
>   drivers/net/ethernet/octeon/octeon_mgmt.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/octeon/octeon_mgmt.c b/drivers/net/ethernet/octeon/octeon_mgmt.c
> index 979c698..6cc68b1 100644
> --- a/drivers/net/ethernet/octeon/octeon_mgmt.c
> +++ b/drivers/net/ethernet/octeon/octeon_mgmt.c
> @@ -290,9 +290,10 @@ static void octeon_mgmt_clean_tx_buffers(struct octeon_mgmt *p)
>   		/* Read the hardware TX timestamp if one was recorded */
>   		if (unlikely(re.s.tstamp)) {
>   			struct skb_shared_hwtstamps ts;
> +			u64 ns;
>   			memset(&ts, 0, sizeof(ts));

I don't think this is the change suggested by Joe Perches and davem.

So NAK.  In the interestes of Bike Shedding, I will send a patch that 
clears the warning with a fewer number of changed lines, that follows 
the suggestion.

David Daney


>   			/* Read the timestamp */
> -			u64 ns = cvmx_read_csr(CVMX_MIXX_TSTAMP(p->port));
> +			ns = cvmx_read_csr(CVMX_MIXX_TSTAMP(p->port));
>   			/* Remove the timestamp from the FIFO */
>   			cvmx_write_csr(CVMX_MIXX_TSCTL(p->port), 0);
>   			/* Tell the kernel about the timestamp */
>

