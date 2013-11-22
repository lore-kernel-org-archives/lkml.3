Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab3KVTk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:40:59 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:50484 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3KVTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:40:54 -0500
Date: Fri, 22 Nov 2013 16:40:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/8] perf symbol: Save vmlinux or kallsyms path loaded
Message-ID: <20131122194047.GF11305@ghostprotocols.net>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
 <1384806771-2945-4-git-send-email-dsahern@gmail.com>
 <20131122184458.GE11305@ghostprotocols.net>
 <528FACF0.5090604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528FACF0.5090604@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 22, 2013 at 12:13:52PM -0700, David Ahern escreveu:
> On 11/22/13, 11:44 AM, Arnaldo Carvalho de Melo wrote:
> >Em Mon, Nov 18, 2013 at 01:32:46PM -0700, David Ahern escreveu:
> >>Save vmlinux or kallsyms path loaded using embedded default lookup (ie.,
> >>not a user specified path). Upcoming perf sched timehist command requires
> >>kernel symbols for properly computing idle times and prints a warning
> >>if the kernel symbols are not loaded.

> >What would happen if strdup failed here?

> perf continues on happily. On the timehist command will question
> computation of idle times which require kernel symbols.

> >Why don't we undo anything done so far in this function and return an
> >error?

> In the notion of best effort of continuing. It's not a show stopper
> that strdup failed; it's just not the filename it used for symbols.

So if later on one would need to print that info, it would just show
"unknown"?

- Arnaldo
