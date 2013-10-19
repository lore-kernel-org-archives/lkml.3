Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JSAJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:09:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:42710 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752904Ab3JSAJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:09:53 -0400
Date: Fri, 18 Oct 2013 20:09:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: kernel-br@googlegroups.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 1/2] tracing: creates 'tracing_is_disabled()'
Message-ID: <20131018200951.3636bcf7@gandalf.local.home>
In-Reply-To: <1382129982-9668-1-git-send-email-geyslan@gmail.com>
References: <1382129982-9668-1-git-send-email-geyslan@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Oct 2013 17:59:41 -0300
"Geyslan G. Bem" <geyslan@gmail.com> wrote:

> This patch creates the function 'tracing_is_disabled ", which
> can be used outside trace.c.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  kernel/trace/trace.c | 5 +++++
>  kernel/trace/trace.h | 1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7974ba2..a120a73 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2964,6 +2964,11 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> +inline bool tracing_is_disabled(void)

Nuke the "inline". Gcc and other compilers are smart enough to know to
inline it on a -O2, that we don't need it. Especially, when it's used
in another file.

-- Steve

> +{
> +	return (tracing_disabled) ? true: false;
> +}
> +
>  /*
>   * Open and update trace_array ref count.
>   * Must have the current trace_array passed to it.
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
