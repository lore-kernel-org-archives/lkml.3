Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3JGUQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:16:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:11728 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab3JGUQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:16:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1051,1371106800"; 
   d="scan'208";a="371045976"
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC PATCH 00/50] tools/perf: Speed up the build system
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
Date: Mon, 07 Oct 2013 13:15:59 -0700
In-Reply-To: <1381147003-2574-1-git-send-email-mingo@kernel.org> (Ingo
	Molnar's message of "Mon, 7 Oct 2013 13:55:53 +0200")
Message-ID: <87y564zvk0.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:
>
> The series also includes a number of fixes and convenience features:
>
>    - auto-detect the number of CPUs on the system and add the -j<cpus>
>      option automatically

FWIW I would prefer if you not do that automatically, because:

- Often the optimal factor is not 1, but something like 1.5*CPUs
(but I'm not sure it's the same on all systems, probably depends on 
the IO capacity and memory)
- It may use a lot of memory, so should be something controlled by the
user.
- Often it's useful to use a few threads less to avoid interactivity
problems on a workstation.
- With LTO there can be rare cases where you need to lower it to avoid
running out of memory.
- Kernel build users should be already trained to set that parameter
and it's not really a big burden.

The rest looks like a great improvement.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
