Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbbAWAJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 19:09:21 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62448 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbbAWAJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 19:09:16 -0500
Date: Fri, 23 Jan 2015 02:09:11 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: Heba Aamer <heba93aamer@gmail.com>
Cc: devel@driverdev.osuosl.org, tvboxspy@gmail.com, gregkh@linuxfoundation.org,
        forest@alittletooquiet.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: fix Prefer ether_addr_copy() over
 memcpy() if the Ethernet addresses are __aligned(2)
Message-ID: <20150123000911.GC2332@localhost.localdomain>
References: <20150121110848.GA9282@mohammed-Inspiron-3537>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121110848.GA9282@mohammed-Inspiron-3537>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 01:08:48PM +0200, Heba Aamer wrote:
> This patch fixes the following checkpatch.pl warning:
> fix Prefer ether_addr_copy() over memcpy() 
> if the Ethernet addresses are __aligned(2)
> 
> Pahole showed that the 2 structs are aligned to u16
> 
> struct vnt_mic_hdr {
>         u8                         id;                   /*     0     1 */
>         u8                         tx_priority;          /*     1     1 */
>         u8                         mic_addr2[6];         /*     2     6 */
>         u8                         ccmp_pn[6];           /*     8     6 */
>         __be16                     payload_len;          /*    14     2 */
>         __be16                     hlen;                 /*    16     2 */
>         __le16                     frame_control;        /*    18     2 */
>         u8                         addr1[6];             /*    20     6 */
>         u8                         addr2[6];             /*    26     6 */
>         u8                         addr3[6];             /*    32     6 */
>         __le16                     seq_ctrl;             /*    38     2 */
>         u8                         addr4[6];             /*    40     6 */
>         u16                        packing;              /*    46     2 */
> 
>         /* size: 48, cachelines: 1, members: 13 */
>         /* last cacheline: 48 bytes */
> };
> 
> struct ieee80211_hdr {
>         __le16                     frame_control;        /*     0     2 */
>         __le16                     duration_id;          /*     2     2 */
>         u8                         addr1[6];             /*     4     6 */
>         u8                         addr2[6];             /*    10     6 */
>         u8                         addr3[6];             /*    16     6 */
>         __le16                     seq_ctrl;             /*    22     2 */
>         u8                         addr4[6];             /*    24     6 */
> 
>         /* size: 30, cachelines: 1, members: 7 */
>         /* last cacheline: 30 bytes */
> };
> 
> Signed-off-by: Heba Aamer <heba93aamer@gmail.com>
Reviewed-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>

> ---
>  drivers/staging/vt6656/rxtx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
> index bb6a4d4..b74f672 100644
> --- a/drivers/staging/vt6656/rxtx.c
> +++ b/drivers/staging/vt6656/rxtx.c
> @@ -738,7 +738,7 @@ static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
>  
>  		mic_hdr->id = 0x59;
>  		mic_hdr->payload_len = cpu_to_be16(payload_len);
> -		memcpy(mic_hdr->mic_addr2, hdr->addr2, ETH_ALEN);
> +		ether_addr_copy(mic_hdr->mic_addr2, hdr->addr2);
>  
>  		ieee80211_get_key_tx_seq(tx_key, &seq);
>  
> -- 
> 1.7.9.5
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
