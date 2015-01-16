Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbbAPMNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:13:08 -0500
Received: from mail-bl2on0065.outbound.protection.outlook.com ([65.55.169.65]:64832
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755109AbbAPMNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:13:05 -0500
X-Greylist: delayed 919 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 07:13:05 EST
X-AuditID: ac160a69-f79956d000002b3c-10-54b8fcb224c4
Message-ID: <54B8FCAE.2020408@sandisk.com>
Date: Fri, 16 Jan 2015 12:57:34 +0100
From: Bart Van Assche <bart.vanassche@sandisk.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>, Roland Dreier <roland@kernel.org>
CC: Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Jingoo Han" <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rasmus Villemoes" <linux@rasmusvillemoes.dk>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        "Christoph Hellwig" <hch@infradead.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ib_srpt: wait_for_completion_timeout does not return
 negativ status
References: <1421407217-9105-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1421407217-9105-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWyRoxnke6mPztCDNZdE7aYs34Nm8XORbuZ
	LDZunshocXrCIiaL/U+fs1hcXniJ1eLyrjlsFs8O9bJYPJ41j81iw/9Gdou21WcYLXY2NDBZ
	NK/fwOLA67Fz1l12j7e3nrN7bF6h5bF4z0smj02rOtk8Tsz4zeJxf/sRJo8LXdkefVtWMXp8
	3iQXwBXFZZOSmpNZllqkb5fAlTFp+R/mgrWcFcvadBoYr7F3MXJySAiYSHR92sEMYYtJXLi3
	nq2LkYtDSOAEo8Sr7ousEM4ORokfjXeYYDo+n7oJZgsJbGaUWHCGFcTmFdCSeDRrEdgkFgFV
	iRX3r7OB2GwCRhLf3s9k6WLk4BAVCJM438wIUS4ocXLmExYQW0TAW2LjvZ9gu5gFtjJLnJm5
	C2y+sECURHP3VKhd9hLbVkDEOQUcJFZ9nQg2iFnAQOLIojmsELa8xPa3c5hBBkkILGGTeHp6
	GxtEs7rEySXzmSYwisxCsnwWkv5ZSPoXMDKvYhTLzcwpzk1PLTA00itOzEvJLM7WS87P3cQI
	jlmuzB2MKyaZH2IU4GBU4uGdsWVHiBBrYllxZe4hRgkOZiURXvvPQCHelMTKqtSi/Pii0pzU
	4kOM0hwsSuK8gtOz/IUE0hNLUrNTUwtSi2CyTBycUg2Mzl8ev2a2rVn0SEqZMeqJiwUjc6r6
	8Y0ThA4r/FC2/bJsE1eG54c1P43F50jec4mpPndp1cknF1bc79/8e1fMhEuvr3BslHTSsVny
	ecfMExP/cvx5JrWj8WDAO6m3E3Zv3sfOKWhaFK04e0fwgliHhuY1ffo/WxY4cvHmBv++8Pn8
	o72Syyt2TlRiKc5INNRiLipOBAAf5UnG1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsXCtZEjRXfTnx0hBpemsFrMWb+GzWLnot1M
	Fhs3T2S0OD1hEZPF/qfPWSwuL7zEanF51xw2i2eHelksHs+ax2ax4X8ju0Xb6jOMFjsbGpgs
	mtdvYHHg9dg56y67x9tbz9k9Nq/Q8li85yWTx6ZVnWweJ2b8ZvG4v/0Ik8eFrmyPvi2rGD0+
	b5IL4IrisklJzcksSy3St0vgypi0/A9zwVrOimVtOg2M19i7GDk5JARMJD6fuskEYYtJXLi3
	nq2LkYtDSGAjo8TkdQ/YQBK8AloSj2YtYgaxWQRUJVbcvw4WZxMwkvj2fiZLFyMHh6hAmMT5
	ZkaIckGJkzOfsIDYIgJ+Ej83fQWbySywh1liwbsbYEXCAlESzd1TwRYLCdhLbFuxC8zmFHCQ
	WPV1IlgNs4CexI7rv1ghbHmJ7W/nME9g5J+FZMcsJGWzkJQtYGRexSiWm5lTnJueWWBoqFec
	mJeSWZytl5yfu4kRHDeckTsYn040P8TIxMEp1cCoNoHrndb+zpnVezz6ayYZ8cV7K+z6dIP/
	npWDV/D+LJ2Afxve/tN6X/Q+b/PUf2Hz+sKPftb7ovbZZ8UWt6ma89vKHz7qNO2dE6EUUaYc
	JmCx+NllF50qGU4fsSUXw1Zeql+7ewbT9tciDY25stFJquvzd1vW9We96Gz9nKq9P0esrYQ3
	5YQSS3FGoqEWc1FxIgDa/zOvSwIAAA==
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 63.163.107.173)
 smtp.mailfrom=Bart.VanAssche@sandisk.com; 
X-Forefront-Antispam-Report: CIP:63.163.107.173;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(479174004)(51704005)(189002)(24454002)(199003)(65806001)(36756003)(50986999)(64706001)(64126003)(50466002)(77156002)(2950100001)(62966003)(47776003)(83506001)(76176999)(97736003)(87266999)(68736005)(77096005)(54356999)(92566002)(19580395003)(80316001)(81156004)(106466001)(87936001)(65816999)(19580405001)(23746002)(69596002)(46102003)(33656002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR02MB215;H:milsmgep12.sandisk.com;FPR:;SPF:Pass;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR02MB215;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB215;
X-Forefront-PRVS: 04583CED1A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB215;
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2015 11:57:38.7652
 (UTC)
X-MS-Exchange-CrossTenant-Id: fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fcd9ea9c-ae8c-460c-ab3c-3db42d7ac64d;Ip=[63.163.107.173]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB215
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/15 12:20, Nicholas Mc Guire wrote:
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
> 
> Patch is against 3.19.0-rc3 -next-20150109
> 
> Patch was compiletested only with x86_64_defconfig +
> CONFIG_TARGET_CORE=m, CONFIG_INFINIBAND=m, CONFIG_INFINIBAND_SRPT=m
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index eb694dd..4e58c76 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -3533,7 +3533,7 @@ static void srpt_close_session(struct se_session *se_sess)
>  	spin_unlock_irq(&sdev->spinlock);
>  
>  	res = wait_for_completion_timeout(&release_done, 60 * HZ);
> -	WARN_ON(res <= 0);
> +	WARN_ON(res == 0);
>  }
>  
>  /**

The description of this patch explains why you would like to change this
code but not why this change is useful. Does building the current code
e.g. trigger a compiler warning ? If so, which warning ? If not, why
would you like to change this code and why do you think this change is
an improvement ?

Bart.

