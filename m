Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbaDWU4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:56:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31825 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422633AbaDWU4B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:56:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Jan Moskyto Matejka <mq@suse.cz>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Apr 2014 13:55:52 -0700
Subject: RE: [PATCH][linux-next] wireless: fixed bad dev_info integer type
 warning
Thread-Topic: [PATCH][linux-next] wireless: fixed bad dev_info integer type
 warning
Thread-Index: Ac9e9AyGivhrEGk3SC+xVEDv4sQ/7AAQjeBA
Message-ID: <477F20668A386D41ADCC57781B1F70430F70A2A9C3@SC-VEXCH1.marvell.com>
References: <1398258039-20512-1-git-send-email-mq@suse.cz>
In-Reply-To: <1398258039-20512-1-git-send-email-mq@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-23_04:2014-04-23,2014-04-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404230312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Thanks for the patch.

> The pointer difference (ptrdiff_t) should be formatted by %tx, not %lx.
> 
> Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>

Acked-by: Bing Zhao <bzhao@marvell.com>

Regards,
Bing

> ---
>  drivers/net/wireless/mwifiex/pcie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
> index 9c1f427..e04141a 100644
> --- a/drivers/net/wireless/mwifiex/pcie.c
> +++ b/drivers/net/wireless/mwifiex/pcie.c
> @@ -2321,7 +2321,7 @@ static void mwifiex_pcie_fw_dump_work(struct work_struct *work)
>  			if (stat != RDWR_STATUS_DONE)
>  				continue;
> 
> -			dev_info(adapter->dev, "%s done: size=0x%lx\n",
> +			dev_info(adapter->dev, "%s done: size=0x%tx\n",
>  				 entry->mem_name, dbg_ptr - entry->mem_ptr);
>  			memset(filename, 0, sizeof(filename));
>  			memcpy(filename, name_prefix, strlen(name_prefix));
> --
> 1.8.4.5

