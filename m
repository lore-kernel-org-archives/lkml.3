Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab3BGNhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:37:46 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2041 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758290Ab3BGNhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:37:41 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <1360244244.17835.1.camel@lb-tlvb-dmitry>
Subject: Re: [PATCHv2-net-3.8 3/3] bnx2x: set gso_type
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: netdev@vger.kernel.org, "Eilon Greenstein" <eilong@broadcom.com>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        "Bruce Allan" <bruce.w.allan@intel.com>,
        "Carolyn Wyborny" <carolyn.wyborny@intel.com>,
        "Don Skidmore" <donald.c.skidmore@intel.com>,
        "Greg Rose" <gregory.v.rose@intel.com>,
        "Peter P Waskiewicz Jr" <peter.p.waskiewicz.jr@intel.com>,
        "Alex Duyck" <alexander.h.duyck@intel.com>,
        "John Ronciak" <john.ronciak@intel.com>,
        "Tushar Dave" <tushar.n.dave@intel.com>,
        "Jitendra Kalsaria" <jitendra.kalsaria@qlogic.com>,
        "Sony Chacko" <sony.chacko@qlogic.com>, linux-driver@qlogic.com,
        "John Fastabend" <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jacob Keller" <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        bhutchings@solarflare.com, eric.dumazet@gmail.com
Date: Thu, 7 Feb 2013 15:37:24 +0200
In-Reply-To: <b9413cd3577c7b544cd522a6eb8ae6b037b20da6.1360236441.git.mst@redhat.com>
References: <cover.1360236441.git.mst@redhat.com>
 <b9413cd3577c7b544cd522a6eb8ae6b037b20da6.1360236441.git.mst@redhat.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7D0D73413OG544290-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 15:13 +0200, Michael S. Tsirkin wrote:
> In LRO mode, bnx2x set gso_size but not gso type.
> This leads to crashes in macvtap.
> Commit cbf1de72324a8105ddcc3d9ce9acbc613faea17e
> queued for 3.9 includes a more complete fix.
> This is a minimal patch to avoid the crash, for 3.8.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index f771ddf..a5edac8 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -504,13 +504,11 @@ static int bnx2x_fill_frag_skb(struct bnx2x *bp, struct bnx2x_fastpath *fp,
>  		skb_shinfo(skb)->gso_size = bnx2x_set_lro_mss(bp,
>  					tpa_info->parsing_flags, len_on_bd);
>  
> -		/* set for GRO */
> -		if (fp->mode == TPA_MODE_GRO)
> -			skb_shinfo(skb)->gso_type =
> -			    (GET_FLAG(tpa_info->parsing_flags,
> -				      PARSING_FLAGS_OVER_ETHERNET_PROTOCOL) ==
> -						PRS_FLAG_OVERETH_IPV6) ?
> -				SKB_GSO_TCPV6 : SKB_GSO_TCPV4;
> +		skb_shinfo(skb)->gso_type =
> +			(GET_FLAG(tpa_info->parsing_flags,
> +				  PARSING_FLAGS_OVER_ETHERNET_PROTOCOL) ==
> +			 PRS_FLAG_OVERETH_IPV6) ?
> +			SKB_GSO_TCPV6 : SKB_GSO_TCPV4;
>  	}
>  
> 
Thanks!

Acked-by: Dmitry Kravkov <dmitry@broadcom.com>




