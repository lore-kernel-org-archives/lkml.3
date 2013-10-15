Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039Ab3JOXdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:33:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:41032 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933634Ab3JOXdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:33:53 -0400
Date: Tue, 15 Oct 2013 19:33:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, shaojie.sun@linaro.org
Subject: Re: [PATCH] ARM: trace: Add tracepoint for the Inter Processor
 Interrupt
Message-ID: <20131015193346.292b252d@gandalf.local.home>
In-Reply-To: <525CE007.6070101@linaro.org>
References: <1381758807-31139-1-git-send-email-daniel.lezcano@linaro.org>
	<20131014232004.5cbedbb8@gandalf.local.home>
	<525CE007.6070101@linaro.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 08:26:15 +0200
Daniel Lezcano <daniel.lezcano@linaro.org> wrote:


> Mmh, I have a doubt here about the trace. I can remove the cpumask 
> because it is not used but in the other hand, it would be interesting to 
> have in the trace the cpumask of the recipient cpus for the IPI. 
> Unfortunately, I don't know how to convert this cpumask to a string 
> without using the cpumask_scnprintf which imply a more complex print trace.
> 
> Do you have some advices for that ?

What's wrong with recording the cpumask into the trace buffer and then
using cpumask_scnprintf() as output? We can update trace-cmd and
libtraceevent to handle that output too.

-- Steve

