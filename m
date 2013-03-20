Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab3CTOxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:53:55 -0400
Received: from mail-la0-f66.google.com ([209.85.215.66]:52927 "EHLO
	mail-la0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab3CTOxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:53:54 -0400
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 07:53:52 -0700
Message-ID: <CAEtk5gfd1CpPdaF4ufjzZzR2pZYKb9cvKUwsH15XUGcNCP+WFA@mail.gmail.com>
Subject: Question pertaining to request_threaded_irq
From: Vijay Dixit <thelonejoker@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hello,

I am new to the Kernel-Mailing list. I am not subscribed at the moment
and would really appreciate it, if I can be CC'd for all the
reply/responses for my question.


I have searched all over the web but haven't found a convincing answer
to a couple of related questions I have, with regard to the
"request_threaded_irq" feature.

QUESTION-1
****************
Firstly, I was reading this article, regarding threaded IRQ's:

http://lwn.net/Articles/302043/

and there is this one line that isn't clear to me:

"Converting an interrupt to threaded makes only sense when the handler
code takes advantage of it by integrating tasklet/softirq
functionality and simplifying the locking."

I understand had we gone ahead with a "traditional", top half/bottom
half approach, we would have needed either spin-locks or disable local
IRQ to meddle with shared data. But, what I don't understand is, how
would threaded interrupts simplify the need for locking by integrating
tasklet/softirq functionality.


QUESTION-2
****************
Secondly, what advantage (if any), does a request_threaded_handler
approach have over a work_queue based bottom half approach ? In both
cases it seems, as though the "work" is deferred to a dedicated
thread. So, what is the difference ?


QUESTION-3
****************
Lastly, in the following prototype:

int request_threaded_irq(unsigned int irq, irq_handler_t handler,
irq_handler_t thread_fn, unsigned long irqflags, const char *devname,
void *dev_id)

Is it possible that the "handler" part of the IRQ is continuously
triggered by the relevant IRQ (say a UART receving characters at a
high rate), even while the "thread_fn"(writing rx'd bytes to a
circular buffer) part of the interrupt handler is busy processing
IRQ's from previous wakeups ? So, wouldn't the handler be trying to
"wakeup" an already running "thread_fn" ? How would the running irq
"thread_fn" behave in that case ?

I would really appreciate if someone can help me understand this.

Thanks,
vj
