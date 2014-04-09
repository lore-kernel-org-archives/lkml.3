Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbaDIISh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 04:18:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34789 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366AbaDIISf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 04:18:35 -0400
Date: Wed, 9 Apr 2014 10:18:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Brown, Len" <len.brown@intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86 idle: Repair large-server 50-watt
 idle-power regression
Message-ID: <20140409081824.GZ10526@twins.programming.kicks-ass.net>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
 <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
 <tip-40e2d7f9b5dae048789c64672bf3027fbb663ffa@git.kernel.org>
 <1395102010.2474.21.camel@buesod1.americas.hpqcorp.net>
 <1A7043D5F58CCB44A599DFD55ED4C94845CA12EC@fmsmsx115.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C94845CA12EC@fmsmsx115.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 09:43:54PM +0000, Brown, Len wrote:
> #1: skip flush for C1
> #2: skip flush for C1 and C1E

One stray thought I had: IFF the erratum is due to the cache flushing of
the higher C states, these two patches should still be correct while
also (possibly) avoiding the performance penalty, since C1* doesn't
flush caches yet.

Of course, I've no clue if this is indeed the root cause of this
particular erratum and I'm not sure you guys are allowed to say even if
you would know :/
