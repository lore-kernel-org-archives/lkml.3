Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3HWFBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 01:01:46 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:37425 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3HWFBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 01:01:45 -0400
From: Caizhiyong <caizhiyong@huawei.com>
To: Wei Yongjun <weiyj.lk@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kzak@redhat.com" <kzak@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "dedekind@infradead.org" <dedekind@infradead.org>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>
Subject: RE: [PATCH -next] block: fix error return code in parse_parts()
Thread-Topic: [PATCH -next] block: fix error return code in parse_parts()
Thread-Index: AQHOn6stv1pAMo5jqU2AZ5C/F8qMuJmiOzQQ
Date: Fri, 23 Aug 2013 04:58:39 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C0671B3@szxeml512-mbs.china.huawei.com>
References: <CAPgLHd8HnGX_Sq2U4vh1H1E1tL1XFjwLS7=90xRobYuFkti7kw@mail.gmail.com>
In-Reply-To: <CAPgLHd8HnGX_Sq2U4vh1H1E1tL1XFjwLS7=90xRobYuFkti7kw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> Sent: Friday, August 23, 2013 10:48 AM
> To: axboe@kernel.dk; akpm@linux-foundation.org; Caizhiyong; kzak@redhat.com;
> mag@sysgo.de; dwmw2@infradead.org; computersforpeace@gmail.com;
> dedekind@infradead.org
> Cc: yongjun_wei@trendmicro.com.cn; linux-kernel@vger.kernel.org
> Subject: [PATCH -next] block: fix error return code in parse_parts()
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -EINVAL in the parts parse error handling case instead
> of 0(may overwrite to 0 by parse_subpart()), as done elsewhere in this
> function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  block/cmdline-parser.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/block/cmdline-parser.c b/block/cmdline-parser.c
> index 18fb435..cc2637f 100644
> --- a/block/cmdline-parser.c
> +++ b/block/cmdline-parser.c
> @@ -135,6 +135,7 @@ static int parse_parts(struct cmdline_parts **parts, const char
> *bdevdef)
> 
>  	if (!newparts->subpart) {
>  		pr_warn("cmdline partition has no valid partition.");
> +		ret = -EINVAL;


Seems OK to me.

>  		goto fail;
>  	}
> 

