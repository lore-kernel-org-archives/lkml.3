Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaKXCMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:12:14 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39253 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKXCMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:12:13 -0500
Message-ID: <547293F6.8090008@hitachi.com>
Date: Mon, 24 Nov 2014 11:12:06 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH ftrace/core v6 2/5] ftrace, kprobes: Support IPMODIFY
 flag to find IP modify conflict
References: <20141121102502.11844.82696.stgit@localhost.localdomain> <20141121102516.11844.27829.stgit@localhost.localdomain> <20141121130529.316989d8@gandalf.local.home> <20141121144316.22459f7e@gandalf.local.home>
In-Reply-To: <20141121144316.22459f7e@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/22 4:43), Steven Rostedt wrote:
> On Fri, 21 Nov 2014 13:05:29 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Fri, 21 Nov 2014 05:25:16 -0500
>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>>> + * IPMODIFY - The ops can modify the IP register. This can only be set with
>>> + *            SAVE_REGS. If another ops is already registered for any of the
>>> + *            functions that this ops will be registered for, then this ops
>>> + *            will fail to register or set_filter_ip.
>>
>> It's blocked by any ops sharing the same function, or just another ops
>> with this flag set? The comment doesn't specify. The code looks like
>> the latter.
> 
> I applied it and gave it the following updates to comments:

Thanks!

This looks good to me :)

> 
> -- Steve
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 93cf0478f64e..ed501953f0b2 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -107,9 +107,9 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
>   *            in such cases the arch must not modify it. Only the arch ftrace
>   *            core code should set this flag.
>   * IPMODIFY - The ops can modify the IP register. This can only be set with
> - *            SAVE_REGS. If another ops is already registered for any of the
> - *            functions that this ops will be registered for, then this ops
> - *            will fail to register or set_filter_ip.
> + *            SAVE_REGS. If another ops with this flag set is already registered
> + *            for any of the functions that this ops will be registered for, then
> + *            this ops will fail to register or set_filter_ip.
>   */
>  enum {
>  	FTRACE_OPS_FL_ENABLED			= 1 << 0,
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 531e72a716c3..929a733d302e 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1810,8 +1810,8 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>  		return 0;
>  
>  	/*
> -	 * Since the IPMODIFY is very address sensitive action, we do not allow
> -	 * ftrace_ops to set all functions to new hash.
> +	 * Since the IPMODIFY is a very address sensitive action, we do not
> +	 * allow ftrace_ops to set all functions to new hash.
>  	 */
>  	if (!new_hash || !old_hash)
>  		return -EINVAL;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


