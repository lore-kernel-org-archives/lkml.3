Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaCJJ7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:59:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:45986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbaCJJ7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,622,1389772800"; 
   d="scan'208";a="495364963"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 03/11] perf: Allow for multiple ring buffers per event
In-Reply-To: <530529FC.6080704@intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-4-git-send-email-alexander.shishkin@linux.intel.com> <20140217143340.GR27965@twins.programming.kicks-ass.net> <530529FC.6080704@intel.com>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 10 Mar 2014 11:59:41 +0200
Message-ID: <87siqqtlv6.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave.hansen@intel.com> writes:

> On 02/17/2014 06:33 AM, Peter Zijlstra wrote:
>> Then write the PERF_RECORD_DATA structure into the normal ring-buffer
>> location; set data_offset to point to the first page boundary, data_size
>> to 1mb.
>> 
>> Then frob things such that perf_mmap_to_page() for the next 1mb of pages
>> points to your buffer pages and wipe the page-table entries.
>
> Wouldn't we have to teach a ton of code how to be IRQ safe for this to
> work?  Just step one: how do we go modifying page tables safely from an
> interrupt?  mm->page_table_lock is a plain non-irq spinlock.

Yes, this does look more than just tricky even if we move the bulk of
interrupt code to an irq_work. Peter, are you quite sure this is what we
want to do just for exporting trace buffers to userspace?

Regards,
--
Alex
