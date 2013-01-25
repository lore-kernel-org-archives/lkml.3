Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3AYQoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:44:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20452 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3AYQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:44:16 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jPgbAdZAaisA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=88l9eXxIsI4A:10 a=JfrnYn6hAAAA:8 a=NpgitreKrVUQQR55-gwA:9 a=PUjeQqilurYA:10 a=ynEkCYo3MdkvxmR-:21 a=aXG8WgqOxGw7BuLG:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359132254.21576.230.camel@gandalf.local.home>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available
 for ARM_UNWIND
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Martin <dave.martin@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>,
        Russell King <linux@arm.linux.org.uk>
Date: Fri, 25 Jan 2013 11:44:14 -0500
In-Reply-To: <20130125162608.GD2069@linaro.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	 <1359123276-15833-20-git-send-email-arnd@arndb.de>
	 <20130125162608.GD2069@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I got an error with linux-arm-kernel@list.infradead.org and had to
remove from CC ]

On Fri, 2013-01-25 at 16:26 +0000, Dave Martin wrote:

> However, if the purpose if making return_address() notrace is just to
> prevent infinite recursion, where finite recursion is safe, then it
> feels fixable as described above.
> 
> Steven, do you know whether such an approach might be safe?
> 

I rewrote the function trace recursion code (see linux-next). The
function tracer wont recurse on itself. If the return_address() is only
used by callbacks and not directly by the mcount(ftrace_caller), then
after the first trace, ftrace wont let recursion of the callback. IOW,
callbacks of ftrace don't need to worry about re-entrancy at the same
context level (but do for different contexts, ie. normal, irq, softirq
and NMI).

(commit edc15cafcbfa3d73f819cae99885a2e35e4cbce5 in linux-next and
friends)

-- Steve


