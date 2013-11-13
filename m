Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3KMM5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:57:40 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:34754 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3KMM5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:57:37 -0500
Date: Wed, 13 Nov 2013 13:57:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Tweak summary output
Message-ID: <20131113125734.GA22140@gmail.com>
References: <1384345308-24404-1-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384345308-24404-1-git-send-email-penberg@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> Tweak the summary output as suggested by Ingo Molnar:
> 
>   [penberg@localhost ~]$ perf trace -a --duration 10000 --summary -- sleep 1
>   ^C
>    Summary of events:
> 
>    Xorg (817), 148 events, 0.0%, 0.000 msec
> 
>      syscall            calls      min       avg       max      stddev
>                                  (msec)    (msec)    (msec)        (%)
>      --------------- -------- --------- --------- ---------     ------
>      read                   7     0.002     0.004     0.011     32.00%
>      rt_sigprocmask        40     0.001     0.001     0.002      1.31%
>      ioctl                  6     0.002     0.003     0.005     19.45%
>      writev                 7     0.004     0.018     0.059     43.76%
>      select                 9     0.000    74.513   507.869     74.61%
>      setitimer              4     0.001     0.002     0.002     10.08%

Acked-by: Ingo Molnar <mingo@kernel.org>

Are you convinced about double-digit precision output for percentages?

I think it suggest a false level of accuracy, but YYMV - typographically 
xx.yy certainly looks nicer than xx.y (it's more symmetric).

Thanks,

	Ingo
