Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3LWX0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 18:26:25 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:10874 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932596Ab3LWX0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 18:26:23 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ding Tianhong <dingtianhong@huawei.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Dec 2013 15:26:01 -0800
Subject: RE: [PATCH 15/21] mwifiex: slight optimization of addr compare
Thread-Topic: [PATCH 15/21] mwifiex: slight optimization of addr compare
Thread-Index: Ac7/nX07SjnGZ4KcTA2aLnQl/3N66wAmCEYw
Message-ID: <477F20668A386D41ADCC57781B1F70430F5334745F@SC-VEXCH1.marvell.com>
References: <52B7C5E6.7030807@huawei.com>
In-Reply-To: <52B7C5E6.7030807@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-23_05:2013-12-23,2013-12-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312230185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBNNQaqQ028487

Hi Ding,

> diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c
> b/drivers/net/wireless/mwifiex/11n_rxreorder.c
> index ada809f..a180298 100644
> --- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
> +++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
> @@ -164,7 +164,7 @@ mwifiex_11n_get_rx_reorder_tbl(struct mwifiex_private *priv, int tid, u8 *ta)
> 
>  	spin_lock_irqsave(&priv->rx_reorder_tbl_lock, flags);
>  	list_for_each_entry(tbl, &priv->rx_reorder_tbl_ptr, list) {
> -		if (!memcmp(tbl->ta, ta, ETH_ALEN) && tbl->tid == tid) {
> +		if (ether_addr_equal_unaligned(tbl->ta, ta) && tbl->tid == tid) {

checkpatch.pl found several warnings in this patch.
WARNING: line over 80 characters

Could you please fix these warnings by splitting the function arguments into multiple lines?

Thanks,
Bing

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
