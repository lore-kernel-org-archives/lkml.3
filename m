Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbaGNTZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:25:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:7256 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953AbaGNTYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:24:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="543220252"
Date: Mon, 14 Jul 2014 12:24:51 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
Message-ID: <20140714192451.GC5803@tassilo.jf.intel.com>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
 <1405123285-23544-2-git-send-email-andi@firstfloor.org>
 <CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You could do better if you tagged the event during setup as load vs. store.
> And then you could simply propagate the flag to the data source struct.

This would require listing all PEBS events in the table again.
The whole point of the other patch was to get rid of that.

Besides it wouldn't work for a range of events (like UOPS_RETIRED.ALL)

-Andi
