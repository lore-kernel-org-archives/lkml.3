Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaAHCum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:50:42 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6416 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691AbaAHCuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:50:39 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ding Tianhong <dingtianhong@huawei.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jan 2014 18:50:28 -0800
Subject: RE: [PATCH v3.5 17/19] mwifiex: slight optimization of addr compare
Thread-Topic: [PATCH v3.5 17/19] mwifiex: slight optimization of addr compare
Thread-Index: Ac8CL4oT+UMsgPh8T+KxDLCO4Ce+HQJ7D/EQ
Message-ID: <477F20668A386D41ADCC57781B1F70430F534B5541@SC-VEXCH1.marvell.com>
References: <52BC15E7.7050205@huawei.com>
In-Reply-To: <52BC15E7.7050205@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-08_01:2014-01-07,2014-01-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401070200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s082pNe2022994

Hi Ding,

> Use possibly more efficient ether_addr_equal
> instead of memcmp.

> @@ -782,8 +782,7 @@ static int mwifiex_ret_ibss_coalescing_status(struct mwifiex_private *priv,
>  	}
> 
>  	/* If BSSID is diff, modify current BSS parameters */
> -	if (memcmp(priv->curr_bss_params.bss_descriptor.mac_address,
> -		   ibss_coal_resp->bssid, ETH_ALEN)) {
> +	if (!ether_addr_equal(priv->curr_bss_params.bss_descriptor.mac_address, ibss_coal_resp->bssid))

Could you break the line?
If you run "checkpatch.pl" you will spot this warning.

>  	if (!IS_11N_ENABLED(priv) ||
> -	    memcmp(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest, ETH_ALEN)) {
> +	    !ether_addr_equal_unaligned(priv->curr_addr, rx_pkt_hdr->eth803_hdr.h_dest)) {

Also over 80 characters here.

Thanks,
Bing

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
