Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3JAPAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:00:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:36010 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab3JAPAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:00:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="386261802"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 07/11] igb: Avoid uninitialized advertised variable in
 eee_set_cur
Thread-Topic: [PATCH 07/11] igb: Avoid uninitialized advertised variable in
 eee_set_cur
Thread-Index: AQHOvhw6BvTHMeqh0Eys+NiJtQf3Ppnf8X5Q
Date: Tue, 1 Oct 2013 15:00:27 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B6264F99A6A4@ORSMSX102.amr.corp.intel.com>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-8-git-send-email-andi@firstfloor.org>
In-Reply-To: <1380572952-30729-8-git-send-email-andi@firstfloor.org>
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
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Andi Kleen
> Sent: Monday, September 30, 2013 1:29 PM
> To: linux-kernel@vger.kernel.org
> Cc: Andi Kleen; Kirsher, Jeffrey T; netdev@vger.kernel.org
> Subject: [PATCH 07/11] igb: Avoid uninitialized advertised variable in
> eee_set_cur
> 
> From: Andi Kleen <ak@linux.intel.com>
> 
> eee_get_cur assumes that the output data is already zeroed. It can read-modify-
> write the advertised field:
> 
>               if (ipcnfg & E1000_IPCNFG_EEE_100M_AN)
> 2594			edata->advertised |= ADVERTISED_100baseT_Full;
> 
> This is ok for the normal ethtool eee_get call, which always zeroes the input
> data before.
> 
> But eee_set_cur also calls eee_get_cur and it did not zero the input field. Later
> on it then compares agsinst the field, which can contain partial stack garbage.
> 
> Zero the input field in eee_set_cur() too.
> 
> Cc: jeffrey.t.kirsher@intel.com
> Cc: netdev@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 48cbc83..41e37ff 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -2652,6 +2652,8 @@ static int igb_set_eee(struct net_device *netdev,
>  	    (hw->phy.media_type != e1000_media_type_copper))
>  		return -EOPNOTSUPP;
> 
> +	memset(&eee_curr, 0, sizeof(struct ethtool_eee));
> +
>  	ret_val = igb_get_eee(netdev, &eee_curr);
>  	if (ret_val)
>  		return ret_val;
> --
> 1.8.3.1
> 

ACK

Thanks,

Carolyn 
