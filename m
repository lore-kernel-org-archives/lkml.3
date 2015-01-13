Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbbAMLjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:39:41 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35732 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbAMLjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:39:40 -0500
Message-ID: <54B503F5.4020509@hitachi.com>
Date: Tue, 13 Jan 2015 20:39:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, vvs@sw.ru
Subject: Re: Bug with jprobes and function graph tracer
References: <20150108122016.0241f713@gandalf.local.home>
In-Reply-To: <20150108122016.0241f713@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/09 2:20), Steven Rostedt wrote:
> Hi Masami,
> 
> First, I would like to wish you a Happy New Year :-)

Happy New Year! :)

> OK, now back to business.
> 
> 
> It has come to my attention that jprobes and function graph tracing do
> not play nicely together. I think you once told me they have issues as
> well.
> 
> A simple way to test this is to load the jprobe_example.ko module and
> then run function graph tracing.

I see. Jprobes will mess up the function call path.

> Should we try to fix this? Or should it just be that users need to know
> not to enable the two together. Or we can prevent one from starting if
> the other is being used.

Yeah we should try to fix this, but not so high priority since jprobe
is not used so frequently. I guess one easy solution is adding notrace
to all jprobe handlers for hiding it from function-graph tracer.
If there is a way to check a function is notrace or not, I can use that
in register_jprobe and reject it if the handler is not "notrace"ed. :)

Thank you,

> 
> Looking forward to hearing your thoughts on the subject.
> 
> -- Steve
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


