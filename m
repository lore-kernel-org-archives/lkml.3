Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaCFXT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:19:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:20504 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751697AbaCFXT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:19:56 -0500
Date: Thu, 6 Mar 2014 18:19:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 4/4] x86: Fix order of warning messages when ftrace
 modifies code
Message-ID: <20140306181953.25681923@gandalf.local.home>
In-Reply-To: <1392650573-3390-5-git-send-email-pmladek@suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
	<1392650573-3390-5-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm digging through older email, and notice you dropped this patch
from your last series. It is a rather trivial patch, and I don't really
care if it gets applied or not. But was there a reason to drop it? Or
do you not care either?

-- Steve


On Mon, 17 Feb 2014 16:22:53 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> The colon at the end of the printk message suggests that it should get printed
> before the details printed by ftrace_bug().
> 
> When touching the line, let's use the preferred pr_warn() macro as suggested
> by checkpatch.pl.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  arch/x86/kernel/ftrace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 525a9f954c8b..ad7c38f5206b 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -622,8 +622,8 @@ void ftrace_replace_code(int enable)
>  	return;
>  
>   remove_breakpoints:
> +	pr_warn("Failed on %s (%d):\n", report, count);
>  	ftrace_bug(ret, rec ? rec->ip : 0);
> -	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
>  	for_ftrace_rec_iter(iter) {
>  		int err;
>  

