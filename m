Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3JINRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:17:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab3JINRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:17:08 -0400
Date: Wed, 9 Oct 2013 15:16:39 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf trace: Add summary option to dump syscall
 statistics
Message-ID: <20131009131639.GB5459@krava.redhat.com>
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com>
 <1381289214-24885-3-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381289214-24885-3-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:26:53PM -0600, David Ahern wrote:
> When enabled dumps a summary of all syscalls by task with the usual
> statistics -- min, max, average and relative stddev. For example,
> 
> make - 26341 :       3344   [ 17.4% ]      0.000 ms
> 
>                 read :   52    0.000     4.802     0.644   30.08
>                write :   20    0.004     0.036     0.010   21.72
>                 open :   24    0.003     0.046     0.014   23.68
>                close :   64    0.002     0.055     0.008   22.53
>                 stat : 2714    0.002     0.222     0.004    4.47
>                fstat :   18    0.001     0.041     0.006   46.26
>                 mmap :   30    0.003     0.009     0.006    5.71
>             mprotect :    8    0.006     0.039     0.016   32.16
>               munmap :   12    0.007     0.077     0.020   38.25
>                  brk :   48    0.002     0.014     0.004   10.18
>         rt_sigaction :   18    0.002     0.002     0.002    2.11
>       rt_sigprocmask :   60    0.002     0.128     0.010   32.88
>               access :    2    0.006     0.006     0.006    0.00
>                 pipe :   12    0.004     0.048     0.013   35.98
>                vfork :   34    0.448     0.980     0.692    3.04
>               execve :   20    0.000     0.387     0.046   56.66
>                wait4 :   34    0.017  9923.287   593.221   68.45
>                fcntl :    8    0.001     0.041     0.013   48.79
>             getdents :   48    0.002     0.079     0.013   19.62
>               getcwd :    2    0.005     0.005     0.005    0.00
>                chdir :    2    0.070     0.070     0.070    0.00
>            getrlimit :    2    0.045     0.045     0.045    0.00
>           arch_prctl :    2    0.002     0.002     0.002    0.00
>            setrlimit :    2    0.002     0.002     0.002    0.00
>               openat :   94    0.003     0.005     0.003    2.11
> 

Should the syscalls columns be aligned with the data?

jirka
---
              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]
                                  syscall  count    min     max    avg  stddev
                                                   msec    msec   msec     %
 _____________________________________________________________________________

                  ls - 10994 :        530   [ 97.4% ]      0.000 ms

                                    read :    18     0.000     0.016     0.003   25.51
                                    open :    24     0.002     0.026     0.005   19.46

