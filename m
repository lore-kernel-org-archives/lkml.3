Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3CKOR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:17:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3CKORz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:17:55 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nUvTUPWh_e8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=0Ce2CjKWjRgA:10 a=i0EeH86SAAAA:8 a=6bLTpiKl3vbvVdBaWy4A:9 a=PUjeQqilurYA:10 a=hPjdaMEvmhQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363011474.12608.12.camel@gandalf.local.home>
Subject: Re: [PATCH 11/13] tracing: export syscall_nr_to_meta function
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>
Date: Mon, 11 Mar 2013 10:17:54 -0400
In-Reply-To: <513D8449.4090003@huawei.com>
References: <513D8449.4090003@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 15:14 +0800, zhangwei(Jovi) wrote:
> Currently syscall meta table is important for kernel
> syscall tracing, even mandatory, external modules may need this
> meta info when perform syscall tracing(like ktap), so export it.
> 
> Instead of export variable syscalls_metadata, export function
> syscall_nr_to_meta is more safe.
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---
>  include/trace/syscall.h       |    2 ++
>  kernel/trace/trace_syscalls.c |    3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index 84bc419..3d88f63 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -31,4 +31,6 @@ struct syscall_metadata {
>  	struct ftrace_event_call *exit_event;
>  };
> 
> +struct syscall_metadata *syscall_nr_to_meta(int nr);
> +
>  #endif /* _TRACE_SYSCALL_H */
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index d24a84c..63433f9 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -102,13 +102,14 @@ find_syscall_meta(unsigned long syscall)
>  	return NULL;
>  }
> 
> -static struct syscall_metadata *syscall_nr_to_meta(int nr)
> +struct syscall_metadata *syscall_nr_to_meta(int nr)

If you're going to make this global, then the name needs to be changed.
Perhaps call it trace_syscall_nr_to_metadata()

Anyway, this code may be totally rewritten in the near future, so
modules beware.

-- Steve

>  {
>  	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
>  		return NULL;
> 
>  	return syscalls_metadata[nr];
>  }
> +EXPORT_SYMBOL_GPL(syscall_nr_to_meta);
> 
>  static enum print_line_t
>  print_syscall_enter(struct trace_iterator *iter, int flags,


