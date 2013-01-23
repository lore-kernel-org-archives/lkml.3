Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab3AWUSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:18:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:42995 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab3AWUSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:18:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,523,1355126400"; 
   d="scan'208";a="251349139"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "John W. Linville" <linville@tuxdriver.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: manual merge of the wireless-next tree with Linus'
 tree
Thread-Topic: linux-next: manual merge of the wireless-next tree with Linus'
 tree
Thread-Index: AQHN+QekOUgY/wLJYUuOZBWYO8QtzphXWz1w
Date: Wed, 23 Jan 2013 20:18:33 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301922C4B@HASMSX103.ger.corp.intel.com>
References: <20130123121635.f9d10701019ad76297799d68@canb.auug.org.au>
In-Reply-To: <20130123121635.f9d10701019ad76297799d68@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's linux-next merge of the wireless-next tree got a conflict in
> drivers/net/wireless/iwlwifi/dvm/tx.c between commit f590dcec9445
> ("iwlwifi: fix the reclaimed packet tracking upon flush queue") from Linus' tree
> and commit 1c3fea82d6eb ("iwlwifi: improve the reports in TX
> path") from the wireless-next tree.
> 

> diff --cc drivers/net/wireless/iwlwifi/dvm/tx.c
> index 31534f7,b0aad71..0000000
> --- a/drivers/net/wireless/iwlwifi/dvm/tx.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
> @@@ -1218,14 -1205,8 +1210,15 @@@ int iwlagn_rx_reply_tx(struct iwl_priv
>   			freed++;
>   		}
> 
>  +		if (tid != IWL_TID_NON_QOS) {
>  +			priv->tid_data[sta_id][tid].next_reclaimed =
>  +				next_reclaimed;
>  +			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed
> packet:%d\n",
>  +					   next_reclaimed);
>  +		}
>  +
> - 		WARN_ON(!is_agg && freed != 1);
> + 		if (!is_agg && freed != 1)
> + 			IWL_ERR(priv, "Q: %d, freed %d\n", txq_id, freed);
> 

This looks fine - thanks!
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

