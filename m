Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbbAIPDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:03:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbbAIPDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:03:16 -0500
Date: Fri, 9 Jan 2015 13:03:14 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf probe can't insert return kprobe
Message-ID: <20150109150314.GS2517@redhat.com>
References: <20150109145539.GC14750@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109145539.GC14750@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 09, 2015 at 03:55:39PM +0100, Jiri Olsa escreveu:
> hi,
> I couldn't use following perf command to insert return probe:
> 
>   # perf probe -a fork_exit=do_fork%return
>   Added new event:
>   Failed to write event: Invalid argument
>     Error: Failed to add events.

Wonder if we have any way of forcing 'perf probe' to show what it will
feed the kernel, perhaps -v?

> 
> I'm pretty sure I used this command before, so seems like
> it's broken. I can still use debugfs tracing interface to
> do that:
>   # echo 'r:do_fork_entry do_fork' > kprobe_events
> 
> I used Arnaldo's latest perf/core and FC20 kernel:
> 
>   # uname -a
>   Linux krava 3.17.7-200.fc20.x86_64 #1 SMP Wed Dec 17 03:35:33 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
>   # ./perf version
>   perf version 3.18.g6a7d78
> 
> 
> thanks,
> jirka
