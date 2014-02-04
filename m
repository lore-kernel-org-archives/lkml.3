Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaBDUJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:09:55 -0500
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:13675 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999AbaBDUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:09:53 -0500
Date: Tue, 4 Feb 2014 15:09:22 -0500
From: Chad Dupuis <chad.dupuis@qlogic.com>
To: "Steven J. Magnani" <steve.magnani@digidescorp.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: Re: [PATCH] qla2xxx: Re-sync module parameter descriptions with the
 code
In-Reply-To: <1391539835-8431-1-git-send-email-steve@digidescorp.com>
Message-ID: <alpine.WNT.2.00.1402041508290.5360@N5102REMCQXM4BS.qlogic.org>
References: <1391539835-8431-1-git-send-email-steve@digidescorp.com>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
X-X-Sender: cdupuis@qlm.qlogic.com
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-Originating-IP: [10.1.4.10]
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7338 signatures=668917
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1402040111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Feb 2014, Steven J. Magnani wrote:

> Fix module parameter descriptions mentioning default values that no longer
> match the code.
>
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN linux-3.14-rc1/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> --- linux-3.14-rc1/drivers/scsi/qla2xxx/qla_os.c	2014-02-02 18:42:13.000000000 -0600
> +++ b/drivers/scsi/qla2xxx/qla_os.c	2014-02-04 12:41:45.133576764 -0600
> @@ -120,15 +120,17 @@ MODULE_PARM_DESC(ql2xmaxqdepth,
> int ql2xenabledif = 2;
> module_param(ql2xenabledif, int, S_IRUGO);
> MODULE_PARM_DESC(ql2xenabledif,
> -		" Enable T10-CRC-DIF "
> -		" Default is 0 - No DIF Support. 1 - Enable it"
> -		", 2 - Enable DIF for all types, except Type 0.");
> +		" Enable T10-CRC-DIF:\n"
> +		" Default is 2.\n"
> +		"  0 -- No DIF Support\n"
> +		"  1 -- Enable DIF for all types\n"
> +		"  2 -- Enable DIF for all types, except Type 0.\n");
>
> int ql2xenablehba_err_chk = 2;
> module_param(ql2xenablehba_err_chk, int, S_IRUGO|S_IWUSR);
> MODULE_PARM_DESC(ql2xenablehba_err_chk,
> 		" Enable T10-CRC-DIF Error isolation by HBA:\n"
> -		" Default is 1.\n"
> +		" Default is 2.\n"
> 		"  0 -- Error isolation disabled\n"
> 		"  1 -- Error isolation enabled only for DIX Type 0\n"
> 		"  2 -- Error isolation enabled for all Types\n");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Looks good. Thanks.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
