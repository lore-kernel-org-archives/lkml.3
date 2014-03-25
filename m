Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaCYFun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 01:50:43 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:6402 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbaCYFul convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 01:50:41 -0400
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Joe Perches <joe@perches.com>, netdev <netdev@vger.kernel.org>
CC: Dept-HSG Linux NIC Dev <Dept-HSGLinuxNICDev@qlogic.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 4/7] qlcnic: Remove casts of pointer to same
 type
Thread-Topic: [PATCH net-next 4/7] qlcnic: Remove casts of pointer to same
 type
Thread-Index: AQHPR53h1xpz9a6YDEqli2DNcJX4gZrxTFxA
Date: Tue, 25 Mar 2014 05:50:38 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A46F809CB@avmb2.qlogic.org>
References: <cover.1395692043.git.joe@perches.com>
 <ac82455e9d2f0487a3f96c44a41b5557fd09af95.1395692043.git.joe@perches.com>
In-Reply-To: <ac82455e9d2f0487a3f96c44a41b5557fd09af95.1395692043.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7387 signatures=670387
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1403240202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, March 25, 2014 1:46 AM
> To: netdev
> Cc: Shahed Shaikh; Dept-HSG Linux NIC Dev; linux-kernel
> Subject: [PATCH net-next 4/7] qlcnic: Remove casts of pointer to same type
> 
> Casting a pointer to a pointer of the same type is pointless, so remove these
> unnecessary casts.
> 
> Done via coccinelle script:
> 
> $ cat typecast_2.cocci
> @@
> type T;
> T *foo;
> @@
> 
> -	(T *)foo
> +	foo
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Shahed Shaikh <shahed.shaikh@qlogic.com>

Thanks,
Shahed
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> index ec399b7..2d91975 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
> @@ -1388,7 +1388,7 @@ static int qlcnic_83xx_copy_fw_file(struct
> qlcnic_adapter *adapter)
>  	addr = (u64)dest;
> 
>  	ret = qlcnic_83xx_ms_mem_write128(adapter, addr,
> -					  (u32 *)p_cache, size / 16);
> +					  p_cache, size / 16);
>  	if (ret) {
>  		dev_err(&adapter->pdev->dev, "MS memory write
> failed\n");
>  		release_firmware(fw);
> --
> 1.8.1.2.459.gbcd45b4.dirty

