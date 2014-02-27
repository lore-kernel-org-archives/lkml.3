Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaB0QSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:18:20 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46393 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaB0QST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:18:19 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 27 Feb 2014 08:18:09 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 24/46] kernel: Mark function as static in
 kernel/trace/ftrace.c and remove stub declaration from header file
 include/linux/ftrace.h
Message-ID: <20140227161809.GF26756@thin>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <745957305394a111ecb61440cfe82608e9c4e3aa.1393493277.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <745957305394a111ecb61440cfe82608e9c4e3aa.1393493277.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 05:31:21PM +0530, Rashika Kheria wrote:
> Mark function as static in kernel/trace/ftrace.c because it is not used
> outside this file.
> Also, remove unused stub declaration from header file
> include/linux/ftrace.h.
> 
> This eliminates the following warning in kernel/trace/ftrace.c:
> kernel/trace/ftrace.c:4268:6: warning: no previous prototype for ‘ftrace_release_mod’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

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
> -- 
> 1.7.9.5
> 
