Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaA3SIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 13:08:35 -0500
Received: from mail-yk0-f172.google.com ([209.85.160.172]:54182 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaA3SIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 13:08:32 -0500
Date: Thu, 30 Jan 2014 15:08:23 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 1/9] perf tools: Fix symbol annotation for relocated
 kernel
Message-ID: <20140130180823.GA8098@ghostprotocols.net>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
 <1391004884-10334-2-git-send-email-adrian.hunter@intel.com>
 <20140129185747.GE3998@ghostprotocols.net>
 <52E9FD31.108@intel.com>
 <20140130085940.GA2643@gmail.com>
 <52EA1988.9050100@intel.com>
 <20140130092036.GA2862@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130092036.GA2862@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 30, 2014 at 10:20:36AM +0100, Ingo Molnar escreveu:
> Ok, cool, thanks!
> 
> I'd suggest the whole fix series if perf/urgent material.

Getting segfaults with:

[acme@ssdandy linux]$ git log --oneline | head -10
c059c953531f perf tests: vmlinux-kallsyms test does not need to set up ref_reloc_sym
be2530836ebe perf symbols: Prevent the use of kcore if the kernel has moved
9b2fd7840cb0 perf record: Get ref_reloc_sym from kernel map
bcf5e06a0c75 perf symbols: Add kallsyms__get_function_start()
94591ed0963e perf machine: Add machine__get_kallsyms_filename()
18923cddb839 perf symbols: Fix symbol annotation for relocated kernel
f428ebd184c8 perf tools: Fix AAAAARGH64 memory barriers
950b8354716e perf tools: Demangle kernel and kernel module symbols too
0d4dd797564c perf/doc: Remove mention of non-existent set_perf_event_pending() from design.txt
993e5ee67a90 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent
[acme@ssdandy linux]$ 

[acme@ssdandy linux]$ perf record usleep 1
Segmentation fault (core dumped)
[acme@ssdandy linux]$ uname -a
Linux ssdandy 3.12.0-rc6+ #2 SMP Mon Oct 21 11:19:07 BRT 2013 x86_64 x86_64 x86_64 GNU/Linux
[acme@ssdandy linux]$ cat /etc/fedora-release 
Fedora release 18 (Spherical Cow)
[acme@ssdandy linux]$ 

- Arnaldo
