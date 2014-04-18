Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaDRKB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:01:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45045 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaDRKBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:01:55 -0400
Date: Fri, 18 Apr 2014 12:01:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] tracing: Do not try to recreated toplevel
 set_ftrace_* files
Message-ID: <20140418100153.GD4385@pd.tnic>
References: <20140417234256.185058335@goodmis.org>
 <20140417234355.658063348@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140417234355.658063348@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 07:42:57PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> With the restructing of the function tracer working with instances, the
> "top level" buffer is a bit special, as the function tracing is mapped
> to the same set of filters. This is done by using a "global_ops" descriptor
> and having the "set_ftrace_filter" and "set_ftrace_notrace" map to it.
> 
> When an instance is created, it creates the same files but its for the
> local instance and not the global_ops.
> 
> The issues is that the local instance creation shares some code with
> the global instance one and we end up trying to create th top level
> "set_ftrace_*" files twice, and on boot up, we get an error like this:
> 
>  Could not create debugfs 'set_ftrace_filter' entry
>  Could not create debugfs 'set_ftrace_notrace' entry
> 
> The reason they failed to be created was because they were created
> twice, and the second time gives this error as you can not create the
> same file twice.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
