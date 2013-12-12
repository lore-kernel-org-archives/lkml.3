Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3LLNqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:46:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:1319 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab3LLNqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:46:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,878,1378882800"; 
   d="scan'208";a="443085703"
Message-ID: <52A9BE15.4090105@intel.com>
Date: Thu, 12 Dec 2013 15:45:57 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v0 21/71] perf tools: Add feature test for __sync_val_compare_and_swap
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com> <1386765443-26966-22-git-send-email-alexander.shishkin@linux.intel.com> <20131211192407.GD1458@ghostprotocols.net> <20131211200721.GN22695@tassilo.jf.intel.com>
In-Reply-To: <20131211200721.GN22695@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 22:07, Andi Kleen wrote:
>> Can you provide more info about these gcc builtins and what is the
>> minimum system where this test will succeed?
> 
> CMPXCHG for x86 is available since the 486 or so, so practically
> everywhere.
> 
> I think that's mainly for other architectures.
> 
> it would be reasonable to just use #if defined(__x86_64__) || defined(__i386__)
> instead.

__sync_val_compare_and_swap() is being used in the itrace abstraction which
is architecture neutral, so I can't use x86 defines.

