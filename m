Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaLSDfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 22:35:03 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39636 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaLSDfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 22:35:01 -0500
Message-ID: <54939CDC.5020403@hitachi.com>
Date: Fri, 19 Dec 2014 12:34:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Miroslav Benes <mbenes@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: use FTRACE_OPS_FL_IPMODIFY
References: <1418752700-14649-1-git-send-email-sjenning@redhat.com> <5492C0A9.3080303@hitachi.com> <20141218154935.GA6887@treble.redhat.com>
In-Reply-To: <20141218154935.GA6887@treble.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/19 0:49), Josh Poimboeuf wrote:
> On Thu, Dec 18, 2014 at 08:55:21PM +0900, Masami Hiramatsu wrote:
>> (2014/12/17 2:58), Seth Jennings wrote:
>>> changes in v7:
>>> - TODO: set IPMODIFY (not a blocker to moving forward)
>>
>> Why don't you set this?
>> IPMODIFY series are not completely applied yet, but you can already
>> use the flag. All you need is just set it :)
> 
> Yeah, I don't see any reason why we can't start using this flag now.
> How about we add this patch to the queue?
> 
> -->8--
> 
> Subject: livepatch: use FTRACE_OPS_FL_IPMODIFY
> 
> Use the FTRACE_OPS_FL_IPMODIFY flag to prevent conflicts with other
> ftrace users who also modify regs->ip.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

Looks good to me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> ---
>  kernel/livepatch/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 0004a71..bdd99975 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -640,7 +640,8 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  
>  	ops->private = func;
>  	ops->func = klp_ftrace_handler;
> -	ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
> +	ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC |
> +		     FTRACE_FL_IPMODIFY;
>  	func->fops = ops;
>  	func->state = KLP_DISABLED;
>  
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


