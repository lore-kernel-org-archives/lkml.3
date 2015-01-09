Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbbAIMOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:14:08 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:61218 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbbAIMOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:14:06 -0500
Date: Fri, 9 Jan 2015 12:14:01 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v4 10/11] perf/x86/intel: Perform rotation on Intel CQM
 RMIDs
Message-ID: <20150109121401.GB495@console-pimps.org>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
 <20150106171712.GH3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106171712.GH3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan, at 06:17:12PM, Peter Zijlstra wrote:
> 
> afaict the again label will try and steal yet another rmid, if rmids
> don't decay fast enough, we could end up with all rmids on the limbo
> list and none active. Or am I missing something here?

You're not missing anything, that's true, we will try and steal more
RMIDs. We could perhaps put a limit on how many RMIDs we're willing to
steal, but I think it should definitely be > 1 because RMIDs can
stabilize out of order.

It's worth pointing out that we only steal more RMIDs if the ones on the
limbo list have been queued for the "minimum queue time" - it really is
a last resort.

-- 
Matt Fleming, Intel Open Source Technology Center
