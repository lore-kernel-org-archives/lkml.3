Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3IKFzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:55:08 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:50678 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3IKFzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:55:07 -0400
Date: Wed, 11 Sep 2013 07:55:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/5] perf/urgent fixes
Message-ID: <20130911055503.GB15395@gmail.com>
References: <1378836722-31326-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378836722-31326-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hm, after this pull request, 'perf top' started misbehaving on older 
kernels:
             
             ┌─Error:────────────────────────────────────────────────────────────────────────────────────┐
             │The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (cycles).  │
             │/bin/dmesg may provide additional information.                                             │
             │No CONFIG_PERF_EVENTS=y kernel support configured?                                         │

But:

 $ cat /proc/sys/kernel/perf_event_paranoid 
 -1

The syscall really fails:

 16645 perf_event_open(0x1eb7f00, 0xffffffff, 0, 0xffffffff, 0) = -1 EINVAL (Invalid argument)
 16645 perf_event_open(0x1eb7f00, 0xffffffff, 0, 0xffffffff, 0) = -1 EINVAL (Invalid argument)
 16645 perf_event_open(0x1eb7f00, 0xffffffff, 0, 0xffffffff, 0) = -1 EINVAL (Invalid argument)

Caused by:

 575a9aab0f85 perf tools: Add attr->mmap2 support

We must not force mmap2 support to be present on the kernel side - new 
perf top should work on older kernels just as well.

So I've unpulled the tree for now.

Thanks,

	Ingo
