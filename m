Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbaBSWCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:02:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:56601 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbaBSWCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:02:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,508,1389772800"; 
   d="scan'208";a="458418655"
Message-ID: <530529FC.6080704@intel.com>
Date: Wed, 19 Feb 2014 14:02:36 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com> <20140217143340.GR27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140217143340.GR27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 06:33 AM, Peter Zijlstra wrote:
> Then write the PERF_RECORD_DATA structure into the normal ring-buffer
> location; set data_offset to point to the first page boundary, data_size
> to 1mb.
> 
> Then frob things such that perf_mmap_to_page() for the next 1mb of pages
> points to your buffer pages and wipe the page-table entries.

Wouldn't we have to teach a ton of code how to be IRQ safe for this to
work?  Just step one: how do we go modifying page tables safely from an
interrupt?  mm->page_table_lock is a plain non-irq spinlock.
