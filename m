Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaFIXVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:21:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:46263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbaFIXVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:21:18 -0400
Message-ID: <1402356070.9238.69.camel@smoke>
Subject: Re: [PATCH] net: ethernet: toshiba: ps3_gelic_net.c:  Cleaning up a
 check on a memory allocation
From: Geoff Levand <geoff@infradead.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 09 Jun 2014 16:21:10 -0700
In-Reply-To: <1402136528-16857-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402136528-16857-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2014-06-07 at 12:22 +0200, Rickard Strandqvist wrote:
> A check on a memory allocation is checked incorrectly.
> 
> This was partly found using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index d899d00..bb79928 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -1561,7 +1561,7 @@ static struct gelic_card *gelic_alloc_card_net(struct net_device **netdev)
>  	 * alloc netdev
>  	 */
>  	*netdev = alloc_etherdev(sizeof(struct gelic_port));
> -	if (!netdev) {
> +	if (!*netdev) {
>  		kfree(card->unalign);
>  		return NULL;
>  	}

Looks good, thanks for posting.

Dave, please queue for merge upstream.

Acked-by: Geoff Levand <geoff@infradead.org>

