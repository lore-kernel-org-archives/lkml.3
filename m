Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3KGInY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:43:24 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60545 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3KGInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:43:15 -0500
MIME-Version: 1.0
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 7 Nov 2013 17:42:54 +0900
Message-ID: <CAAVeFuJWKwAQ338R86O3WMarFDP2ZJDayLddGio9uXiXPsuyFA@mail.gmail.com>
Subject: Is there a notification mechanism for enabled/disabled trace events?
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Trace events can be enabled through debugfs by e.g. writing '1' into
their enable node. This is a very useful feature as some tracing
functions can introduce overhead and we only want them active when
needed.

There is one additional thing that I would need though, which is to be
notified when a given trace event is enabled or disabled.

Here is why: I have a power monitoring hardware that can report how
much power is currently used by the system. Having this information
correlated with other traces (cpufreq, cpuidle, ...) is very useful ;
it can be done by repeatedly scheduling a work that probes the power
usage and traces it. The job should only be running when the power
monitoring trace event is enabled, but AFAIK there is no way to be
notified when it is enabled or disabled. So here are a few questions:

1) Is there such a notification mechanism for trace events that I have missed?

2) If not, is there any objection to having one? I'd say my use-case
is not so uncommon and others would certainly benefit from it.

3) What would be the right place to have it? ftrace_event_reg() looks
like a good place to call a notifier chain, however I'm not sure where
the notifier head should be stored, due to my poor understanding of
ftrace.

Any answer/comments greatly appreciated!

Thanks,
Alex.
