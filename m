Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3DZQkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:40:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39131 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3DZQj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:39:58 -0400
Date: Fri, 26 Apr 2013 18:39:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, tytso@mit.edu,
        davem@davemloft.net, fweisbec@gmail.com, oleg@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel/P4: Robistify P4 PMU types
Message-ID: <20130426163952.GC15361@pd.tnic>
References: <20130424072630.GB1780@gmail.com>
 <tip-5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886@git.kernel.org>
 <20130426161328.GA16818@pd.tnic>
 <20130426162444.GC17430@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130426162444.GC17430@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 08:24:44PM +0400, Cyrill Gorcunov wrote:
> And if possible some branch instructions testing.

By that you mean, see whether it counts branches?

./perf stat sleep 0

 Performance counter stats for 'sleep 0':

          2.483869 task-clock                #    0.463 CPUs utilized
                 1 context-switches          #    0.403 K/sec
                 0 cpu-migrations            #    0.000 K/sec
               168 page-faults               #    0.068 M/sec
         3,435,630 cycles                    #    1.383 GHz
           736,680 stalled-cycles-frontend   #   21.44% frontend cycles idle
           656,603 stalled-cycles-backend    #   19.11% backend  cycles idle
         2,932,775 instructions              #    0.85  insns per cycle
                                             #    0.25  stalled cycles per insn
           590,855 branches                  #  237.877 M/sec
            12,882 branch-misses             #    2.18% of all branches
	    ^^^^^^^^^^^^^^^^^^^^

Those above?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
