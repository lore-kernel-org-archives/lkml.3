Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaB0Qjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:39:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:46237 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753069AbaB0Qjb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:39:31 -0500
Date: Thu, 27 Feb 2014 11:39:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: Re: [PATCH 24/46] kernel: Mark function as static in
 kernel/trace/ftrace.c and remove stub declaration from header file
 include/linux/ftrace.h
Message-ID: <20140227113929.7b012255@gandalf.local.home>
In-Reply-To: <745957305394a111ecb61440cfe82608e9c4e3aa.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
	<745957305394a111ecb61440cfe82608e9c4e3aa.1393493277.git.rashika.kheria@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 17:31:21 +0530
Rashika Kheria <rashika.kheria@gmail.com> wrote:

> Mark function as static in kernel/trace/ftrace.c because it is not used
> outside this file.
> Also, remove unused stub declaration from header file
> include/linux/ftrace.h.
> 
> This eliminates the following warning in kernel/trace/ftrace.c:
> kernel/trace/ftrace.c:4268:6: warning: no previous prototype for ‘ftrace_release_mod’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  include/linux/ftrace.h |    1 -
>  kernel/trace/ftrace.c  |    2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index f4233b1..68ea184 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -532,7 +532,6 @@ static inline int skip_trace(unsigned long ip) { return 0; }
>  static inline int ftrace_force_update(void) { return 0; }
>  static inline void ftrace_disable_daemon(void) { }
>  static inline void ftrace_enable_daemon(void) { }
> -static inline void ftrace_release_mod(struct module *mod) {}
>  static inline __init int register_ftrace_command(struct ftrace_func_command *cmd)
>  {
>  	return -EINVAL;
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index d110d8a..9bacf45 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4265,7 +4265,7 @@ static int ftrace_process_locs(struct module *mod,
>  
>  #define next_to_ftrace_page(p) container_of(p, struct ftrace_page, next)
>  
> -void ftrace_release_mod(struct module *mod)
> +static void ftrace_release_mod(struct module *mod)
>  {
>  	struct dyn_ftrace *rec;
>  	struct ftrace_page **last_pg;

