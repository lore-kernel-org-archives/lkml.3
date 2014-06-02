Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaFBL5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:57:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbaFBL5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:57:11 -0400
Date: Mon, 2 Jun 2014 13:56:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>, Yan Zheng <zheng.z.yan@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Joe Mario <jmario@redhat.com>,
        Richard Fowles <rfowles@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: [RFC/BUG] not working LLC-load-misses on SandyBridge (42) and Haswell
Message-ID: <20140602115550.GA1215@krava.brq.redhat.com>
References: <1400858147-7155-1-git-send-email-jolsa@kernel.org>
 <878upjg6lx.fsf@sejong.aot.lge.com>
 <20140601142622.GA9131@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140601142622.GA9131@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
Joe asked about issues with LLC-load-misses on Haswell. I tried
and found it non functional on SandyBridge (42) as well:

[jolsa@krava perf]$ ./perf stat -e LLC-load-misses ls
...

 Performance counter stats for 'ls':

   <not supported>      LLC-load-misses          

       0.007195547 seconds time elapsed


both SandyBridge (42 and 45) share following config arrays:
  snb_hw_cache_event_ids and snb_hw_cache_extra_regs

but have different 'x86_pmu.extra_regs' which makes LLC-load-misses
event fail (in valid_mask check) in x86_pmu_extra_regs function

Haswell is sharing the same extra regs/ids config as SandyBridge (42),
so it suffers in the same way.

Not sure if thats known issue, but it looks like we need special
set of snb_hw_cache_event_ids for SandyBridge (42) ?

thanks for info,
jirka
