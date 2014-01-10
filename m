Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaAJHTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:19:54 -0500
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:3218 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbaAJHTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:19:50 -0500
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Martin Kaiser <martin@kaiser.cx>,
        Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH -next] qlcnic: fix compiler warning
Thread-Topic: [PATCH -next] qlcnic: fix compiler warning
Thread-Index: AQHPDWjikF1O4m47uESqJjMVu9vJI5p9i3AQ
Date: Fri, 10 Jan 2014 07:19:19 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A46F52B8E@avmb2.qlogic.org>
References: <20140109155908.GA4351@reykholt.kaiser.cx>
In-Reply-To: <20140109155908.GA4351@reykholt.kaiser.cx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7313 signatures=668874
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1401090281
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0A7Jx64007483


Adding netdev.

> -----Original Message-----
> From: Martin Kaiser,,, [mailto:martin@reykholt.kaiser.cx] On Behalf Of
> Martin Kaiser
> Sent: Thursday, January 09, 2014 9:29 PM
> To: Himanshu Madhani; Rajesh Borundia
> Cc: linux-kernel; trivial@kernel.org
> Subject: [PATCH -next] qlcnic: fix compiler warning
> 
> Add an explicit cast to fix the following warning (seen on Debian Wheezy, gcc
> 4.7.2)
> 
> CC [M]  drivers/net/wireless/rtlwifi/rtl8192ce/trx.o
>     drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c: In function
> â€˜qlcnic_send_filterâ€™:
>     drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:349:3: warning:
>     passing argument 2 of â€˜ether_addr_equalâ€™ from incompatible pointer type
> [enabled by default]
>     In file included from include/linux/if_vlan.h:16:0,
>     from drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:9:
>     include/linux/etherdevice.h:244:20: note: expected â€˜const u8 *â€™ but
> argument is of type â€˜u64 *â€™
>

If I am not wrong, this patch should go to David's net-next tree.
 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>

Acked-by: Shahed Shaikh <shahed.shaikh@qlogic.com>

Thanks,
Shahed
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> index 6373f60..3557154 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> @@ -346,7 +346,7 @@ static void qlcnic_send_filter(struct qlcnic_adapter
> *adapter,
>  	head = &(adapter->fhash.fhead[hindex]);
> 
>  	hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
> -		if (ether_addr_equal(tmp_fil->faddr, &src_addr) &&
> +		if (ether_addr_equal(tmp_fil->faddr, (const u8 *)&src_addr)
> &&
>  		    tmp_fil->vlan_id == vlan_id) {
>  			if (jiffies > (QLCNIC_READD_AGE * HZ + tmp_fil-
> >ftime))
>  				qlcnic_change_filter(adapter, &src_addr,
> --
> 1.7.10.4


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
