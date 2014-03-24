Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaCXWXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 18:23:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:33962 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbaCXWXd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 18:23:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Mar 2014 15:23:26 -0700
Subject: RE: [PATCH net-next 6/7] mwifiex: Remove casts of pointer to same
 type
Thread-Topic: [PATCH net-next 6/7] mwifiex: Remove casts of pointer to same
 type
Thread-Index: Ac9HneYxvoIZoCEvTfu3eQx3ahxyaAAEZv4A
Message-ID: <477F20668A386D41ADCC57781B1F70430F53F34172@SC-VEXCH1.marvell.com>
References: <cover.1395692043.git.joe@perches.com>
 <6acb416fd1434c218ce14f2dd0878e561cc5ff9e.1395692043.git.joe@perches.com>
In-Reply-To: <6acb416fd1434c218ce14f2dd0878e561cc5ff9e.1395692043.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-24_04:2014-03-24,2014-03-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1403240136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thanks for the patch.

> Casting a pointer to a pointer of the same type is pointless,
> so remove these unnecessary casts.
> 
> Done via coccinelle script:
> 
> $ cat typecast_2.cocci
> @@
> type T;
> T *foo;
> @@
> 
> -	(T *)foo
> +	foo
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/pcie.c | 6 +++---
>  drivers/net/wireless/mwifiex/scan.c | 2 +-
>  drivers/net/wireless/mwifiex/tdls.c | 6 +++---
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index 9f1683b..c0c598d 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -1009,7 +1009,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
>  		card->tx_buf_list[wrdoneidx] = NULL;
> 
>  		if (reg->pfu_enabled) {
> -			desc2 = (void *)card->txbd_ring[wrdoneidx];
> +			desc2 = card->txbd_ring[wrdoneidx];
>  			memset(desc2, 0, sizeof(*desc2));
>  		} else {
>  			desc = card->txbd_ring[wrdoneidx];
> @@ -1094,7 +1094,7 @@ mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
>  		card->tx_buf_list[wrindx] = skb;
> 
>  		if (reg->pfu_enabled) {
> -			desc2 = (void *)card->txbd_ring[wrindx];
> +			desc2 = card->txbd_ring[wrindx];
>  			desc2->paddr = buf_pa;
>  			desc2->len = (u16)skb->len;
>  			desc2->frag_len = (u16)skb->len;
> @@ -1254,7 +1254,7 @@ static int mwifiex_pcie_process_recv_data(struct mwifiex_adapter *adapter)
>  		card->rx_buf_list[rd_index] = skb_tmp;
> 
>  		if (reg->pfu_enabled) {
> -			desc2 = (void *)card->rxbd_ring[rd_index];
> +			desc2 = card->rxbd_ring[rd_index];
>  			desc2->paddr = buf_pa;
>  			desc2->len = skb_tmp->len;
>  			desc2->frag_len = skb_tmp->len;
> diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
> index f139244..825aeec 100644
> --- a/drivers/net/wireless/mwifiex/scan.c
> +++ b/drivers/net/wireless/mwifiex/scan.c
> @@ -1653,7 +1653,7 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
>  	curr_bcn_bytes -= ETH_ALEN;
> 
>  	if (!ext_scan) {
> -		rssi = (s32) *(u8 *)current_ptr;
> +		rssi = (s32) *current_ptr;
>  		rssi = (-rssi) * 100;		/* Convert dBm to mBm */
>  		current_ptr += sizeof(u8);
>  		curr_bcn_bytes -= sizeof(u8);
> diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
> index 8cec6e4..97662a1 100644
> --- a/drivers/net/wireless/mwifiex/tdls.c
> +++ b/drivers/net/wireless/mwifiex/tdls.c
> @@ -730,13 +730,13 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
> 
>  	if (len < (sizeof(struct ethhdr) + 3))
>  		return;
> -	if (*(u8 *)(buf + sizeof(struct ethhdr)) != WLAN_TDLS_SNAP_RFTYPE)
> +	if (*(buf + sizeof(struct ethhdr)) != WLAN_TDLS_SNAP_RFTYPE)
>  		return;
> -	if (*(u8 *)(buf + sizeof(struct ethhdr) + 1) != WLAN_CATEGORY_TDLS)
> +	if (*(buf + sizeof(struct ethhdr) + 1) != WLAN_CATEGORY_TDLS)
>  		return;
> 
>  	peer = buf + ETH_ALEN;
> -	action = *(u8 *)(buf + sizeof(struct ethhdr) + 2);
> +	action = *(buf + sizeof(struct ethhdr) + 2);
> 
>  	/* just handle TDLS setup request/response/confirm */
>  	if (action > WLAN_TDLS_SETUP_CONFIRM)
> --
> 1.8.1.2.459.gbcd45b4.dirty

