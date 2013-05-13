Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3EMQrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:47:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:54388 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab3EMQrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:47:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,663,1363158000"; 
   d="scan'208";a="336881632"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Dong Zhu <bluezhudong@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "Vick, Matthew" <matthew.vick@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] igb: add a method to get the nic hw time stamping policy
Thread-Topic: [PATCH] igb: add a method to get the nic hw time stamping
 policy
Thread-Index: AQHOTlAy97bKChIyG0OhdaLruqvYKZkAqF6AgAFplICAADH4AIAAk3oAgAAm2gCAAF3jAP//+Xgw
Date: Mon, 13 May 2013 16:47:05 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58564DF475@ORSMSX104.amr.corp.intel.com>
References: <20130511140219.GG8399@zhudong.nay.redhat.com>
 <518E7723.5010003@cogentembedded.com>
 <20130512142555.GI8399@zhudong.nay.redhat.com>
 <20130512172446.GA2484@netboy>
 <20130513021236.GJ8399@zhudong.nay.redhat.com>
 <20130513043140.GA2567@netboy> <20130513100742.GM8399@zhudong.nay.redhat.com>
In-Reply-To: <20130513100742.GM8399@zhudong.nay.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4DGlMNC002206

> -----Original Message-----
> From: Dong Zhu [mailto:bluezhudong@gmail.com]
> Sent: Monday, May 13, 2013 3:08 AM
> To: Richard Cochran
> Cc: Sergei Shtylyov; Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce
> W; Wyborny, Carolyn; Skidmore, Donald C; Rose, Gregory V; Waskiewicz
> Jr, Peter P; Duyck, Alexander H; Ronciak, John; Dave, Tushar N; Vick,
> Matthew; Keller, Jacob E; Paul E. McKenney; David Howells; Dave Jones;
> Thomas Gleixner; linux-kernel@vger.kernel.org; e1000-
> devel@lists.sourceforge.net; netdev@vger.kernel.org
> Subject: Re: [PATCH] igb: add a method to get the nic hw time stamping
> policy
> 
> > You could use the flags field, as it has no definition yet.
> >
> > But you still need to explain why this new functionality is needed in
> > the first place:
> >
> > - You can query an interface's time stamping capabilities with the
> >   GET_TS_INFO ethtool command.
> >
> 
> Hi,
> 
> I modified this patch and added the method to igb_get_ts_info function.
> For 82576 nic, through this method we can easily check which type of
> packets
> are time stamped now, such as (HWTSTAMP_FILTER_PTP_V1_L4_SYNC
> and
> HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ), then change or disable it
> up to your requests.
> I think it is convenient.The origial GET_TS_INFO method can only show
> the deviceâ€™s
> time stamping capabilities which nics supported.
> 
> I use the tx_reserved[0] and rx_reserved[0] to restore the
> hwtstamp_tx_types and
> hwtstamp_rx_filters enumeration values.
> 
> Due to the limitation of 80 characters one line, I have to move the
> switch out of else judegment.
> 
> I test it on I350 and 82576NS nics and it works as expect.
> 
> Could help reviewing it again ? Any comments would be appreciated.
> 
> 
> From 8a12932fd2a3bb5ca904bc72b20140247a5d81be Mon Sep 17
> 00:00:00 2001
> From: Dong Zhu <bluezhudong@gmail.com>
> Date: Mon, 13 May 2013 17:27:59 +0800
> 
> Currently kernel only support setting the hw time stamping policy
> through ioctl,now add a method to check which packets(Outgoing and
> Incoming) are time stamped by nic.
> 
> Add this to igb_get_ts_info, we can query this by using the GET_TS_INFO
> ethtool command. Testing on I350 and 82576NS it seems work well.
> 
> Signed-off-by: Dong Zhu <bluezhudong@gmail.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 78
> +++++++++++++++++++++++++++-
>  include/uapi/linux/ethtool.h                 |  3 ++
>  2 files changed, 79 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> index 7876240..49486b8 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -2327,6 +2327,8 @@ static int igb_get_ts_info(struct net_device
> *dev,
>  			   struct ethtool_ts_info *info)
>  {
>  	struct igb_adapter *adapter = netdev_priv(dev);
> +	struct e1000_hw *hw = &adapter->hw;
> +	u32 regval;
> 
>  	switch (adapter->hw.mac.type) {
>  	case e1000_82575:
> @@ -2360,10 +2362,29 @@ static int igb_get_ts_info(struct net_device
> *dev,
> 
>  		info->rx_filters = 1 << HWTSTAMP_FILTER_NONE;
> 
> +		regval = rd32(E1000_TSYNCTXCTL);
> +		if (regval & E1000_TSYNCTXCTL_ENABLED)
> +			info->tx_reserved[0] = 1 << HWTSTAMP_TX_ON;
> +		else
> +			info->tx_reserved[0] = 1 << HWTSTAMP_TX_OFF;
> +
> +		regval = rd32(E1000_TSYNCRXCTL);
> +
>  		/* 82576 does not support timestamping all packets. */
> -		if (adapter->hw.mac.type >= e1000_82580)
> +		if (adapter->hw.mac.type >= e1000_82580) {
>  			info->rx_filters |= 1 << HWTSTAMP_FILTER_ALL;
> -		else
> +
> +			if (!(regval & E1000_TSYNCRXCTL_ENABLED))
> +				info->rx_reserved[0] =
> +					1 << HWTSTAMP_FILTER_NONE;
> +			else if (E1000_TSYNCRXCTL_TYPE_ALL ==
> +					(regval &
> E1000_TSYNCRXCTL_TYPE_MASK))
> +				info->rx_reserved[0] = 1 <<
> HWTSTAMP_FILTER_ALL;
> +			else
> +				return -ERANGE;
> +
> +			return 0;
> +		} else {
>  			info->rx_filters |=
>  				(1 <<
> HWTSTAMP_FILTER_PTP_V1_L4_SYNC) |
>  				(1 <<
> HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ) |
> @@ -2373,6 +2394,59 @@ static int igb_get_ts_info(struct net_device
> *dev,
>  				(1 <<
> HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ) |
>  				(1 <<
> HWTSTAMP_FILTER_PTP_V2_EVENT);
> 
> +			if (!(regval & E1000_TSYNCRXCTL_ENABLED)) {
> +				info->rx_reserved[0] =
> +					1 << HWTSTAMP_FILTER_NONE;
> +				return 0;
> +			}
> +		}
> +
> +		switch (regval & E1000_TSYNCRXCTL_TYPE_MASK) {
> +		case E1000_TSYNCRXCTL_TYPE_L4_V1:
> +			regval = rd32(E1000_TSYNCRXCFG);
> +			if (E1000_TSYNCRXCFG_PTP_V1_SYNC_MESSAGE
> ==
> +					(regval &
> +
> E1000_TSYNCRXCFG_PTP_V1_CTRLT_MASK))
> +				info->rx_reserved[0] =
> +					(1 <<
> HWTSTAMP_FILTER_PTP_V1_L4_SYNC);
> +			else if
> (E1000_TSYNCRXCFG_PTP_V1_DELAY_REQ_MESSAGE
> +					== (regval &
> +
> 	E1000_TSYNCRXCFG_PTP_V1_CTRLT_MASK))
> +				info->rx_reserved[0] =
> +					(1 <<
> +
> HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ);
> +			else
> +				return -ERANGE;
> +			break;
> +		case E1000_TSYNCRXCTL_TYPE_L2_L4_V2:
> +			regval = rd32(E1000_TSYNCRXCFG);
> +			if (E1000_TSYNCRXCFG_PTP_V2_SYNC_MESSAGE
> ==
> +					(regval &
> +
> E1000_TSYNCRXCFG_PTP_V2_MSGID_MASK))
> +				info->rx_reserved[0] =
> +					(1 <<
> HWTSTAMP_FILTER_PTP_V2_L2_SYNC) |
> +					(1 <<
> HWTSTAMP_FILTER_PTP_V2_L4_SYNC);
> +			else if
> (E1000_TSYNCRXCFG_PTP_V2_DELAY_REQ_MESSAGE ==
> +					(regval &
> +
> E1000_TSYNCRXCFG_PTP_V2_MSGID_MASK))
> +				info->rx_reserved[0] =
> +					(1 <<
> +
> HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ) |
> +					(1 <<
> +
> HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ);
> +			else
> +				return -ERANGE;
> +			break;
> +		case E1000_TSYNCRXCTL_TYPE_EVENT_V2:
> +			info->rx_reserved[0] =
> +				(1 <<
> HWTSTAMP_FILTER_PTP_V2_EVENT) |
> +				(1 << HWTSTAMP_FILTER_PTP_V2_SYNC)
> |
> +				(1 <<
> HWTSTAMP_FILTER_PTP_V2_DELAY_REQ);
> +			break;
> +		default:
> +			return -ERANGE;
> +		}
> +
>  		return 0;
>  	default:
>  		return -EOPNOTSUPP;
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 0c9b448..06cdbc0 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -772,7 +772,10 @@ struct ethtool_sfeatures {
>   * @so_timestamping: bit mask of the sum of the supported
> SO_TIMESTAMPING flags
>   * @phc_index: device index of the associated PHC, or -1 if there is
> none
>   * @tx_types: bit mask of the supported hwtstamp_tx_types
> enumeration values
> + * @tx_reserved[0]: bit mask of the in use hwtstamp_tx_types
> enumeration values
>   * @rx_filters: bit mask of the supported hwtstamp_rx_filters
> enumeration values
> + * @rx_reserved[0]: bit mask of the in use hwtstamp_rx_filters
> enumeration
> + * values
>   *
>   * The bits in the 'tx_types' and 'rx_filters' fields correspond to
>   * the 'hwtstamp_tx_types' and 'hwtstamp_rx_filters' enumeration
> values,
> --
> 1.7.11.7
> 
> 
> --
> Best Regards,
> Dong Zhu

Yes. Matthew has it right. We already set the value via the hwtstamp_ioctl, and we set the actual value that we are timestamping. The ioctl will return at least what you requested, or an error. You can check the results of the ioctl by checking the hwtstamp_config structure after calling the ioctl and make sure you got what you want.

You can't modify the userspace ABI because that would break old applications, and cause even more headache for PTP  application developers. Furthermore, you haven't sufficiently explained a use case that requires the ability to check without setting.

You can already query if the driver is capable of timestamping something, and can set and then query to ensure that you got at least what you requested... You need to explain why you need a new use case if you want to expose another method for accessing the information.

- Jake
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
