Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbbAKKp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 05:45:57 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34307 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbbAKKpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 05:45:54 -0500
Date: Sun, 11 Jan 2015 10:45:51 +0000
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
Message-ID: <20150111104551.GA30245@codeblueprint.co.uk>
References: <1415999712-5850-1-git-send-email-matt@console-pimps.org>
 <1415999712-5850-11-git-send-email-matt@console-pimps.org>
 <20150107121617.GF25325@worktop.programming.kicks-ass.net>
 <20150109125507.GD495@console-pimps.org>
 <20150109125829.GF29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109125829.GF29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan, at 01:58:29PM, Peter Zijlstra wrote:
> 
> Right, but we'll also consider RMIDs with less than this as fit for
> reuse. So we'll re-use RMIDs that are effectively full.
> 
> Our aim is to acquire an 'empty' RMID, not give up and start reusing
> full ones just because, right?

The threshold was designed so that we're guaranteed to make forward
progress. If we're bumping the threshold, *none* of the RMIDs on the
limbo list have an occupancy value less than the threshold value.

At that point, we've got two options,

 1) Increase the threshold value and further skew the results
 2) Steal another RMID and pray it's below the threshold

We actually do both currently.

Now, one thing that we don't do is traverse the entire list of active
RMIDs looking for the least value one, because it's pretty expensive to
do that as it incurs lots of MSR reads and writes.

-- 
Matt Fleming, Intel Open Source Technology Center
