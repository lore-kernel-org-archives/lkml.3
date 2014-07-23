Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbaGWGIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:08:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:61158 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbaGWGIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:08:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,715,1400050800"; 
   d="scan'208";a="565874510"
Message-ID: <53CF5124.2090901@intel.com>
Date: Wed, 23 Jul 2014 09:07:32 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/52] perf tools: Fix jump label always changing during
 tracing
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-2-git-send-email-adrian.hunter@intel.com> <20140722140034.GE20303@kernel.org> <20140722141135.GF3935@laptop>
In-Reply-To: <20140722141135.GF3935@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 05:11 PM, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 11:00:34AM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Tue, Jul 22, 2014 at 04:17:10PM +0300, Adrian Hunter escreveu:
>>> Intel PT decoding walks the object code to reconstruct
>>> the trace.  A jump label change during tracing causes
>>> decoding errors.
> 
> You'd better fix that, jump_labels can change any time and they're all
> over the frigging place.
> 

Perhaps a general method is needed to be able to deal with kernel
self-modifying code.

