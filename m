Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3KLVdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:33:43 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53167 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3KLVdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:33:37 -0500
Date: Tue, 12 Nov 2013 22:33:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Simplify '--summary' output
Message-ID: <20131112213334.GF25913@gmail.com>
References: <1384267334-18953-1-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384267334-18953-1-git-send-email-penberg@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> The output of 'perf trace --summary' tries to be too cute with
> formatting and makes it very hard to read.  Simplify it in the spirit of
> "strace -c":
> 
> [penberg@localhost libtrading]$ perf trace -a --duration 10000 --summary -- sleep 1
> ^C

Btw., just a very small feature suggestion - instead of forcing the 
somewhat counter-intuitive '-- sleep X' pattern it might be helpful to 
have a general option parser for 'delay' values, which would allow a wide 
range of time units like:

	--delay 10.5h
        --delay 0.1s
        --delay 0.1sec

etc. - with the default unit being 'seconds'.

That parser could then be applied to '--duration' filter as well, allowing 
things like:

   --duration 10sec

which IMHO are more obvious to read (and easier to remember!) than 
'--duration 10000'.

>  Summary of events:
> 
>  dbus-daemon (555), 10 events, 0.0%, 0.000 msec
> 
>                                                     msec/call
>    syscall            calls      min      avg      max stddev
>    --------------- -------- -------- -------- -------- ------
>    sendmsg                2    0.002    0.005    0.008  55.00
>    recvmsg                2    0.002    0.003    0.005  44.00
>    epoll_wait             1    0.000    0.000    0.000   0.00

In what units is stddev? Percentage? If yes then it might be useful to 
output it as %. [and probably to restrict precision to a single digit, 
standard deviations are rarely more accurate than 0.1%.]

>  NetworkManager (667), 56 events, 0.0%, 0.000 msec
> 
>                                                     msec/call
>    syscall            calls      min      avg      max stddev
>    --------------- -------- -------- -------- -------- ------
>    poll                   2    0.000    0.002    0.003 100.00
>    sendmsg               10    0.004    0.007    0.016  15.41
>    recvmsg               16    0.002    0.003    0.005   8.24
> 
>  zfs-fuse (669), 4 events, 0.0%, 0.000 msec
> 
>                                                     msec/call
>    syscall            calls      min      avg      max stddev
>    --------------- -------- -------- -------- -------- ------
>    futex                  2    0.000    0.001    0.002 100.00

Nice looking output btw! :-)

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
