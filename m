Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaAKPhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 10:37:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaAKPg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 10:36:56 -0500
Date: Sat, 11 Jan 2014 16:36:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        eranian@google.com, fweisbec@gmail.com, mingo@kernel.org,
        adrian.hunter@intel.com, dsahern@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] perf, tools: Add support for prepending LBRs to the
 callstack
Message-ID: <20140111153614.GC1131@krava.brq.redhat.com>
References: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389357126-3003-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 04:32:03AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> I never found the default LBR display mode which generates histograms
> of individual branches particularly useful.
> 
> This implements an alternative mode that creates histograms over complete
> branch traces, instead of individual branches, similar to how normal
> callgraphs are handled. This is done by putting it in
> front of the normal callgraph and then using the normal callgraph
> histogram infrastructure to unify them.
> 
> This way in complex functions we can understand the control flow
> that lead to a particular sample.
> 
> The default output is unchanged.
> 
> This is only implemented in perf report, no change to record
> or anywhere else.
> 
> This adds the basic code to report:
> - add a new "branch" option to the -g option parser to enable this mode
> - when the flag is set include the LBR into the callstack in machine.c.
> The rest of the history code is unchanged and doesn't know the difference
> between LBR entry and normal call entry.

sounds like nice idea, but I could not get the patchset applied
on acme's perf/core

jirka
