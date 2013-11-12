Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3KLVue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:50:34 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56837 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3KLVu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:50:28 -0500
Date: Tue, 12 Nov 2013 22:50:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@iki.fi>
Cc: David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf trace: Simplify '--summary' output
Message-ID: <20131112215024.GA29761@gmail.com>
References: <1384267334-18953-1-git-send-email-penberg@kernel.org>
 <20131112213334.GF25913@gmail.com>
 <52829F4F.6070800@gmail.com>
 <52829FB8.6070404@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52829FB8.6070404@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@iki.fi> wrote:

> > %. That was dropped in the recent output change.
> 
> Sorry about that. Why do we show them in percentages, btw? Standard 
> deviation is usually represented in the same unit as the data to make it 
> readable.

So, the problem with output in the same unit is that it's hard to tell
'at a glance' what the real, relative stddev is:

    syscall            calls      min      avg      max stddev
    --------------- -------- -------- -------- -------- ------
    sendmsg                2    0.002    0.005    0.008 0.001
    recvmsg                2    0.002    0.003    0.005 0.0003
    epoll_wait             1    0.000    0.000    0.000 0.000

it's also harder to compare stddevs side by side if they are absolute.

The way we try to solve this in perf stat is to output:

  comet:~/tip> perf stat -a --repeat 10 --null usleep 1000

   Performance counter stats for 'system wide' (10 runs):

       0.001772475 seconds time elapsed                                          ( +-  0.58% )

Oh, btw., would anyone would like to implement a cool new 'perf time' 
subcommand, which offers time(1) look-alike output but with better 
precision and sttdev output?

  comet:~> time usleep 1000

  real    0m0.002s
  user    0m0.000s
  sys     0m0.000s

  # Mockup:

  comet:~> perf time --repeat 10 usleep 1000

  real    0m0.002s      [ +- 1.38% ]
  user    0m0.000s      [ +- 0.53% ]
  sys     0m0.000s      [ +- 0.43% ]

?

I'd use it instead of 'time' all the time ;-)

Thanks,

	Ingo
