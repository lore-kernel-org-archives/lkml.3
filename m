Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaKNFIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:08:49 -0500
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:23803 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbaKNFIr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:08:47 -0500
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Joe Stringer <joestringer@nicira.com>, netdev <netdev@vger.kernel.org>
CC: "sathya.perla@emulex.com" <sathya.perla@emulex.com>,
        "amirv@mellanox.com" <amirv@mellanox.com>,
        Dept-GE Linux NIC Dev <Dept-GELinuxNICDev@qlogic.com>,
        "Tom Herbert (Partner - google)" <therbert@google.com>,
        "gerlitz.or@gmail.com" <gerlitz.or@gmail.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv2 net 4/4] qlcnic: Implement ndo_gso_check()
Thread-Topic: [PATCHv2 net 4/4] qlcnic: Implement ndo_gso_check()
Thread-Index: AQHP/6NZI5Hs25/Yzkuzz6AS8Up+5JxfketA
Date: Fri, 14 Nov 2014 05:08:40 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A470A126E@avmb2.qlogic.org>
References: <1415925495-59312-1-git-send-email-joestringer@nicira.com>
 <1415925495-59312-5-git-send-email-joestringer@nicira.com>
In-Reply-To: <1415925495-59312-5-git-send-email-joestringer@nicira.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7621 signatures=670578
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1411140044
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Stringer [mailto:joestringer@nicira.com]
> Sent: Friday, November 14, 2014 6:08 AM
> To: netdev
> Cc: sathya.perla@emulex.com; Shahed Shaikh; amirv@mellanox.com; Dept-
> GE Linux NIC Dev; Tom Herbert (Partner - google); gerlitz.or@gmail.com;
> alexander.duyck@gmail.com; linux-kernel
> Subject: [PATCHv2 net 4/4] qlcnic: Implement ndo_gso_check()
> 
> Use vxlan_gso_check() to advertise offload support for this NIC.
> 
> Signed-off-by: Joe Stringer <joestringer@nicira.com>
> ---
> v2: Refactor out vxlan helper.
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    6 ++++++
>  1 file changed, 6 insertions(+)

Acked-by: Shahed Shaikh <shahed.shaikh@qlogic.com>

Thanks Joe.

-Shahed
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> index f5e29f7..a913b3a 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> @@ -503,6 +503,11 @@ static void qlcnic_del_vxlan_port(struct net_device
> *netdev,
> 
>  	adapter->flags |= QLCNIC_DEL_VXLAN_PORT;  }
> +
> +static bool qlcnic_gso_check(struct sk_buff *skb, struct net_device
> +*dev) {
> +	return vxlan_gso_check(skb);
> +}
>  #endif
> 
>  static const struct net_device_ops qlcnic_netdev_ops = { @@ -526,6 +531,7
> @@ static const struct net_device_ops qlcnic_netdev_ops = {  #ifdef
> CONFIG_QLCNIC_VXLAN
>  	.ndo_add_vxlan_port	= qlcnic_add_vxlan_port,
>  	.ndo_del_vxlan_port	= qlcnic_del_vxlan_port,
> +	.ndo_gso_check		= qlcnic_gso_check,
>  #endif
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller = qlcnic_poll_controller,
> --
> 1.7.10.4

