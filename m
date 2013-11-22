Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3KVPul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:50:41 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35945 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3KVPuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:50:39 -0500
Subject: Re: [PATCH 22/22] perf tools: Overload pr_stat traceevent print
 function
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
In-Reply-To: <1385031680-9014-23-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
	 <1385031680-9014-23-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Nov 2013 00:50:31 +0900
Message-ID: <1385135431.1747.125.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-11-21 (목), 12:01 +0100, Jiri Olsa:
> The traceevent lib uses pr_stat to display all standard
> info. It's defined as __weak. Overloading it with perf
> version plugged into perf output system logic.
> 
> Displaying the pr_stat stuff under '-v' option.

[SNIP]
>  
> +/*
> + * Overloading libtraceevent standard info print
> + * function, display with -v in perf.
> + */
> +void pr_stat(const char *fmt, ...)
> +{
> +	va_list args;
> +
> +	if (verbose >= 1) {
> +		va_start(args, fmt);
> +		vfprintf(stderr, fmt, args);
> +		fprintf(stderr, "\n");
> +		va_end(args);
> +	}
> +}

It'd be better if it use or does same as eprintf() like other pr_*
functions does.

Thanks,
Namhyung


