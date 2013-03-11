Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3CKOJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:09:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29957 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3CKOJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:09:29 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YIQl_LLSjZwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Ox5BbmyYL-8A:10 a=i0EeH86SAAAA:8 a=PkHgMhmOxsv1ywEtETMA:9 a=PUjeQqilurYA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363010968.12608.6.camel@gandalf.local.home>
Subject: Re: [PATCH 07/13] tracing/kdb: remove redundant checking
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Mon, 11 Mar 2013 10:09:28 -0400
In-Reply-To: <513D8437.8060400@huawei.com>
References: <513D8437.8060400@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is Jason's code.

Jason, please give an Ack or Nack.

Thanks,

-- Steve


On Mon, 2013-03-11 at 15:13 +0800, zhangwei(Jovi) wrote:
> trace_empty is checking in while-loop, so the previous checking
> is totally redundant, and more worse, the first trace entry is losted.
> 
> so remove it.
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  kernel/trace/trace_kdb.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
> index 3c5c5df..6489b2e 100644
> --- a/kernel/trace/trace_kdb.c
> +++ b/kernel/trace/trace_kdb.c
> @@ -57,8 +57,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
>  		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
>  		tracing_iter_reset(&iter, cpu_file);
>  	}
> -	if (!trace_empty(&iter))
> -		trace_find_next_entry_inc(&iter);
> +
>  	while (!trace_empty(&iter)) {
>  		if (!cnt)
>  			kdb_printf("---------------------------------\n");


