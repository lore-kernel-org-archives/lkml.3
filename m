Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbbAMMqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:46:42 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48703 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbAMMqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:46:40 -0500
Message-ID: <54B513A9.8070004@hitachi.com>
Date: Tue, 13 Jan 2015 21:46:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, vvs@sw.ru
Subject: Re: Bug with jprobes and function graph tracer
References: <20150108122016.0241f713@gandalf.local.home> <54B503F5.4020509@hitachi.com> <20150113072232.451c599b@gandalf.local.home>
In-Reply-To: <20150113072232.451c599b@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/13 21:22), Steven Rostedt wrote:
> On Tue, 13 Jan 2015 20:39:33 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>>
>> Yeah we should try to fix this, but not so high priority since jprobe
>> is not used so frequently. I guess one easy solution is adding notrace
>> to all jprobe handlers for hiding it from function-graph tracer.
>> If there is a way to check a function is notrace or not, I can use that
>> in register_jprobe and reject it if the handler is not "notrace"ed. :)
> 
> Adding notrace should be the last resort. Every notrace in the kernel
> makes function tracing a little more useless. It bothers me even more
> when notrace is added because of function graph tracing but the
> function still works for function tracing.

I see.

> 
> I worked on this for the last few days and have a patch that fixes the
> problem. I'll be posting it later today. It also uncovered another
> unrelated bug that I worked on yesterday, otherwise I would have posted
> these fixes already.

Great! I look forward that! :)

> 
> I have a fix for the other bug now but it needs to be cleaned up
> (remove all the debugging prints from it). When that's complete I'll
> post the patches and get them ready for mainline and stable.

Thank you,

> 
> Thanks,
> 
> -- Steve
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


