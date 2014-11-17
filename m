Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaKQVYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:24:13 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:39915 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaKQVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:24:12 -0500
Date: Mon, 17 Nov 2014 13:24:00 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org, Peter Zijlstra <peterz@infradead.org>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH v8 02/14] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20141117212400.GB13111@us.ibm.com>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1415972627-37514-3-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415972627-37514-3-git-send-email-alexander.shishkin@linux.intel.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111721-0025-0000-0000-0000062C5EA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Shishkin [alexander.shishkin@linux.intel.com] wrote:
| From: Peter Zijlstra <peterz@infradead.org>
| 
| This patch introduces "AUX space" in the perf mmap buffer, intended for
| exporting high bandwidth data streams to userspace, such as instruction
| flow traces.
| 
| AUX space is a ring buffer, defined by aux_{offset,size} fields in the
| user_page structure, and read/write pointers aux_{head,tail}, which abide
| by the same rules as data_* counterparts of the main perf buffer.

The "format" of this raw stream of data can differ across processors
(and architecutres) correct ? i.e the perf tool processing of this
aux data will also differ across processors ?

Power8 processors support what we call 24x7 counters that collect info
on a large number of events. The current 24x7 support in
(arch/powerpc/perf/hv-24x7.c) currently uses reading one counter at a
time using the pmu->read() interface.

We are looking for ways to export much larger number of counters through
one pmu->read() or another call. I am trying to see if the hv-24x7 pmu
could use this aux interface and then have/implement a helper in perf
tool to extract the counter values.

Sukadev

