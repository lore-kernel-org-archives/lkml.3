Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3EASzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:55:54 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:58586 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3EASzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:55:36 -0400
Message-ID: <51816525.7060305@gmail.com>
Date: Wed, 01 May 2013 14:55:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 09/10] sched: task_sched_runtime introduce micro optimization
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com> <1367291838-5490-10-git-send-email-kosaki.motohiro@gmail.com> <20130501110047.GD28253@dyad.programming.kicks-ass.net> <CAPM31RJ0HWQCU=oDnd=iTyEZzsTS3xSe89rmgVK8cd8umAC5BQ@mail.gmail.com>
In-Reply-To: <CAPM31RJ0HWQCU=oDnd=iTyEZzsTS3xSe89rmgVK8cd8umAC5BQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Stronger:
> 
> +#ifdef CONFIG_64BIT
> +       if (!p->on_cpu)
> +               return p->se.sum_exec_runtime;
> +#endif
> 
> [ Or !p->on_cpu || !add_delta ].
> 
> We can take the racy read versus p->on_cpu since:
>   If we race with it leaving cpu: we take lock, we're correct
>   If we race with it entering cpu: unaccounted time ---> 0, this is
> indistinguishable from the read occurring a few cycles earlier.

OK, agreed. That's nice.


