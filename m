Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbaCYVG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:06:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:46331 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbaCYVGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:06:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,730,1389772800"; 
   d="scan'208";a="479901860"
Date: Tue, 25 Mar 2014 14:06:50 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] tools, perf: Allow the user to disable time stamps
Message-ID: <20140325210650.GI15074@tassilo.jf.intel.com>
References: <1395780272-27106-1-git-send-email-andi@firstfloor.org>
 <CABPqkBSpoc1LX3=hZTnwM9KAeu943kbS0UgCbupWJf1idtdWNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSpoc1LX3=hZTnwM9KAeu943kbS0UgCbupWJf1idtdWNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also here's updated data with ls -lh. 24% saving here.
The perf output is actually not that inaccurate
for this case.

% perf record  --no-time -c 100003 -p 10247 sleep 1
% ls -lh perf.data
-rw------- 1 ak users 681K Mar 25 14:04 perf.data
% perf record  -c 100003 -p 10247 sleep 1
[ perf record: Woken up 4 times to write data ]
[ perf record: Captured and wrote 0.869 MB perf.data (~37982 samples) ]
% ls -lh perf.data
-rw------- 1 ak users 893K Mar 25 14:04 perf.data

-Andi
