Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab3FTMUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:20:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab3FTMUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:20:04 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XmOR8-VsGYQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=IKZ2GEe8SDkA:10 a=i0EeH86SAAAA:8 a=brGJpw1237fpLMKx_0wA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371730802.18733.73.camel@gandalf.local.home>
Subject: Re: [PATCH] trace: using strlcpy instead of strncpy
From: Steven Rostedt <rostedt@goodmis.org>
To: Zhao Hongjiang <zhaohongjiang@huawei.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Date: Thu, 20 Jun 2013 08:20:02 -0400
In-Reply-To: <51C2E265.9010209@huawei.com>
References: <51C2E265.9010209@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix is to a networking tracepoint. It should go through the
networking folks.

-- Steve


On Thu, 2013-06-20 at 19:07 +0800, Zhao Hongjiang wrote:
> for NUL terminated string, need alway set '\0' in the end.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
> ---
>  include/trace/events/sock.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
> index 779abb9..333d8b5 100644
> --- a/include/trace/events/sock.h
> +++ b/include/trace/events/sock.h
> @@ -44,7 +44,7 @@ TRACE_EVENT(sock_exceed_buf_limit,
>  	),
>  
>  	TP_fast_assign(
> -		strncpy(__entry->name, prot->name, 32);
> +		strlcpy(__entry->name, prot->name, 32);
>  		__entry->sysctl_mem = prot->sysctl_mem;
>  		__entry->allocated = allocated;
>  		__entry->sysctl_rmem = prot->sysctl_rmem[0];


