Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073AbaEMO5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:57:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:16454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933788AbaEMO5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1044,1389772800"; 
   d="scan'208";a="531170245"
From: "Ronciak, John" <john.ronciak@intel.com>
To: "xuyongjiande@gmail.com" <xuyongjiande@gmail.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [E1000-devel] [PATCH] e1000: remove the check: skb->len<=0
Thread-Topic: [E1000-devel] [PATCH] e1000: remove the check: skb->len<=0
Thread-Index: AQHPbmnSIiXAm9YHQU6opK5CaoH62ps+miYg
Date: Tue, 13 May 2014 14:57:27 +0000
Message-ID: <D38E8E86660E514AB505863C19C9287C73FBD0FE@ORSMSX102.amr.corp.intel.com>
References: <1399957629-13536-1-git-send-email-xuyongjiande@gmail.com>
In-Reply-To: <1399957629-13536-1-git-send-email-xuyongjiande@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: xuyongjiande@gmail.com [mailto:xuyongjiande@gmail.com]
> Sent: Monday, May 12, 2014 10:07 PM
> To: eric.dumazet@gmail.com
> Cc: e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Yongjian Xu
> Subject: [E1000-devel] [PATCH] e1000: remove the check: skb->len<=0
> 
> From: Yongjian Xu <xuyongjiande@gmail.com>
> 
> There is no case skb->len would be 0 or 'negative'.
> Remove the check.
> 
> Signed-off-by: Yongjian Xu <xuyongjiande@gmail.com>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_main.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c
> b/drivers/net/ethernet/intel/e1000/e1000_main.c
> index 27058df..660971f 100644
> --- a/drivers/net/ethernet/intel/e1000/e1000_main.c
> +++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
> @@ -3105,11 +3105,6 @@ static netdev_tx_t e1000_xmit_frame(struct
> sk_buff *skb,
>  	 */
>  	tx_ring = adapter->tx_ring;
> 
> -	if (unlikely(skb->len <= 0)) {
> -		dev_kfree_skb_any(skb);
> -		return NETDEV_TX_OK;
> -	}
> -
>  	/* On PCI/PCI-X HW, if packet size is less than ETH_ZLEN,
>  	 * packets may get corrupted during padding by HW.
>  	 * To WA this issue, pad all small packets manually.
> --
> 1.9.1
What is the exact problem that this is fixing?  Did you have a test case that showed a problem with it?

Cheers,
John


