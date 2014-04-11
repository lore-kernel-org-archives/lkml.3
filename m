Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaDKSz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:55:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:42363 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755129AbaDKSz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:55:27 -0400
Date: Fri, 11 Apr 2014 14:55:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: namhyung.kim@lge.com, linux-kernel@vger.kernel.org
Subject: Re: ftrace: reading set_graph_notrace returns "#### all functions
 enabled ####"
Message-ID: <20140411145524.6fbda7bb@gandalf.local.home>
In-Reply-To: <1397240657-bbzt0eax@n-horiguchi@ah.jp.nec.com>
References: <1397240657-bbzt0eax@n-horiguchi@ah.jp.nec.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014 14:24:17 -0400
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Hi,
> 
> I report a minor issue of set_graph_notrace.
> The default value of set_graph_notrace is void (so no function is excluded,)
> but when we read the file, we get "#### all functions enabled ####" like below:
> 
>   [root@test tracing]# echo "" > set_graph_notrace
>   [root@test tracing]# cat set_graph_notrace
>   #### all functions enabled ####
> 
> This does not happen for set_ftrace_notrace:
> 
>   [root@test tracing]# echo "" > set_ftrace_notrace
>   [root@test tracing]# cat set_ftrace_notrace
>   [root@test tracing]#
> 
> This is not critical but confusing, so it would be nice if fixed.

Ah, I would say they both are wrong. The set_graph_notrace is rather
new, and probably copied and pasted incorrectly.

But having nothing printed may not be the best thing to show. I think
both should be switched to

#### no functions disabled ####

But this can be done in my 3.16 queue.

Thanks for the report,

-- Steve
