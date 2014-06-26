Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaFZTlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:41:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:41025 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaFZTlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:41:21 -0400
Date: Thu, 26 Jun 2014 16:41:15 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        dsahern@gmail.com, jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] perf trace: add pagefault statistics
Message-ID: <20140626194115.GE18773@kernel.org>
References: <1403799268-1367-1-git-send-email-stfomichev@yandex-team.ru>
 <1403799268-1367-5-git-send-email-stfomichev@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403799268-1367-5-git-send-email-stfomichev@yandex-team.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 26, 2014 at 08:14:27PM +0400, Stanislav Fomichev escreveu:
> 'perf trace' can show summary of events using -S option. This commit
> also reports number of major/minor pagefault events in this summary.
> 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>

Where is it?

[root@zoo /]# perf trace -S -F all -- usleep 1 | tail -30
Failed to open /etc/ld.so.cache, continuing without symbols
     1.241 ( 0.001 ms): brk(                                                                  ) = 0x24c9000
     1.245 ( 0.003 ms): brk(brk: 0x24ea000                                                    ) = 0x24ea000
     1.248 ( 0.001 ms): brk(                                                                  ) = 0x24ea000
     1.253 ( 0.000 ms): minfault [_int_malloc+0x116a] => [heap]@0x24c9008 (d.)
     1.268 ( 0.000 ms): minfault [__GI_____strtoull_l_internal+0x47] => /usr/lib64/libc-2.18.so@0x164ae3 (x.)
     1.273 ( 0.000 ms): minfault [__GI___libc_nanosleep+0x0] => /usr/lib64/libc-2.18.so@0xbc960 (x.)
     1.336 ( 0.062 ms): nanosleep(rqtp: 0x7fff30ccf640                                        ) = 0
     1.344 ( 0.000 ms): exit_group(                                                           

 Summary of events:

 usleep (19155), 151 events, 84.4%, 0:68 faults, 0.000 msec

   syscall            calls      min       avg       max      stddev
                               (msec)    (msec)    (msec)        (%)
   --------------- -------- --------- --------- ---------     ------
   read                   3     0.000     0.002     0.003     50.38%
   open                   3     0.006     0.007     0.008      8.51%
   close                  3     0.001     0.001     0.002      6.05%
   fstat                  3     0.001     0.002     0.002      7.70%
   mmap                   9     0.003     0.005     0.006      9.56%
   mprotect               6     0.004     0.007     0.010     14.12%
   munmap                 1     0.013     0.013     0.013      0.00%
   brk                    4     0.001     0.002     0.003     28.94%
   access                 1     0.007     0.007     0.007      0.00%
   nanosleep              1     0.062     0.062     0.062      0.00%
   execve                 7     0.000     0.086     0.574     94.41%
   arch_prctl             1     0.002     0.002     0.002      0.00%


[root@zoo /]# 

-----------------------------------------

There were minor page faults, were in the summary are they?

I haven't even looked at the code, first I wanted to check if just doing what
is expected would work, i.e. enable all the page fault types, run a workload,
ask for -S and check if there were any stats for major and minor page faults.

I can update the changelog comment with an example if you tell me what I am
doing wrong.

Applied and tested the previous patches.

- Arnaldo
