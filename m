Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3GVO7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:59:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27062 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab3GVO7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:59:47 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=oMQIyPb59TQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=SW_-TF54Wd0A:10 a=kuJ69lDKSy01jrIDgS4A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374505184.3356.92.camel@gandalf.local.home>
Subject: Re: [PATCH 0/7] tracing: Kill the buggy trace_cpu
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Jul 2013 10:59:44 -0400
In-Reply-To: <20130722134313.GA18328@redhat.com>
References: <20130722134313.GA18328@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 15:43 +0200, Oleg Nesterov wrote:
> Hello.
> 
> Only slightly tested so far. I'll try to test more and report
> the results.
> 
> Meanwhile it would be nice if you can take a look and review.
> 
> 
> This series kills tracing_open_generic_tc/trace_cpu/etc.
> 
> trace_array_get(inode->i_private) is mostly fine, we do not
> dereference this pointer untill trace_array_get() succeeds.
> But trace_array_get(tc->tr) is wrong by the same reason why
> tracing_open_generic_file/etc are wrong, see 1/7.
> 
> And not only trace_cpu is buggy, we can simplify the code if
> we kill this member.
> 

Oleg,

So far I like the patch set. I just want to get Al's OK before we do a
hack with an inode structure item.

Thanks!

-- Steve


