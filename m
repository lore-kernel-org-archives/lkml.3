Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab3DGOXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 10:23:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54071 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795Ab3DGOXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 10:23:07 -0400
Date: Sun, 7 Apr 2013 19:47:24 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] uprobes/tracing: Change create_trace_uprobe() to
 support uretprobes
Message-ID: <20130407141724.GE8672@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130401160827.GA19206@redhat.com>
 <20130401160900.GA19590@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130401160900.GA19590@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040714-5806-0000-0000-000020A14E7D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-04-01 18:09:00]:

> Finally change create_trace_uprobe() to check if argv[0][0] == 'r'
> and pass the correct "is_ret" to alloc_trace_uprobe().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/trace/trace_uprobe.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 1b3622a..2773d2a 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -200,7 +200,7 @@ end:
> 
>  /*
>   * Argument syntax:
> - *  - Add uprobe: p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS]
> + *  - Add uprobe: p|r[:[GRP/]EVENT] PATH:SYMBOL [FETCHARGS]
>   *
>   *  - Remove uprobe: -:[GRP/]EVENT
>   */
> @@ -212,20 +212,23 @@ static int create_trace_uprobe(int argc, char **argv)
>  	char buf[MAX_EVENT_NAME_LEN];
>  	struct path path;
>  	unsigned long offset;
> -	bool is_delete;
> +	bool is_delete, is_return;
>  	int i, ret;
> 
>  	inode = NULL;
>  	ret = 0;
>  	is_delete = false;
> +	is_return = false;
>  	event = NULL;
>  	group = NULL;
> 
>  	/* argc must be >= 1 */
>  	if (argv[0][0] == '-')
>  		is_delete = true;
> +	else if (argv[0][0] == 'r')
> +		is_return = true;
>  	else if (argv[0][0] != 'p') {
> -		pr_info("Probe definition must be started with 'p' or '-'.\n");
> +		pr_info("Probe definition must be started with 'p', 'r' or '-'.\n");
>  		return -EINVAL;
>  	}
> 
> @@ -323,7 +326,7 @@ static int create_trace_uprobe(int argc, char **argv)
>  		kfree(tail);
>  	}
> 
> -	tu = alloc_trace_uprobe(group, event, argc, false);
> +	tu = alloc_trace_uprobe(group, event, argc, is_return);
>  	if (IS_ERR(tu)) {
>  		pr_info("Failed to allocate trace_uprobe.(%d)\n", (int)PTR_ERR(tu));
>  		ret = PTR_ERR(tu);
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

