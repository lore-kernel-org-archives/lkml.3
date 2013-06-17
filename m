Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3FQQ4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:56:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33260 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3FQQ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:56:40 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=FBRt8xqedWUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XzXmEfpJ-cEA:10 a=i0EeH86SAAAA:8 a=GDueeOTqcwh8Oily-i4A:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371488199.18733.20.camel@gandalf.local.home>
Subject: Re: [PATCH] uprobes: fix return value in error handling path
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, srikar@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 17 Jun 2013 12:56:39 -0400
In-Reply-To: <51B964FF.5000106@huawei.com>
References: <51B964FF.5000106@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar,

Can you give an Ack (or nack) for this?

Thanks,

-- Steve


On Thu, 2013-06-13 at 14:21 +0800, zhangwei(Jovi) wrote:
> When I inject incorrect argument into uprobe_events,
> 
> [root@jovi tracing]# echo 'p:myprobe /bin/bash' > uprobe_events
> [root@jovi tracing]#
> 
> it doesn't return any error value in there, this patch fix it.
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  kernel/trace/trace_uprobe.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 32494fb0..d5d0cd3 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -283,8 +283,10 @@ static int create_trace_uprobe(int argc, char **argv)
>  		return -EINVAL;
>  	}
>  	arg = strchr(argv[1], ':');
> -	if (!arg)
> +	if (!arg) {
> +		ret = -EINVAL;
>  		goto fail_address_parse;
> +	}
> 
>  	*arg++ = '\0';
>  	filename = argv[1];


