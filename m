Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaFONSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:18:20 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43666 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaFONRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:17:46 -0400
Subject: Re: [PATCH 9/9] perf, tools: Add a --quiet flag to perf list
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1402700580-26939-10-git-send-email-andi@firstfloor.org>
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
	 <1402700580-26939-10-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Jun 2014 22:17:41 +0900
Message-ID: <1402838261.1684.39.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

2014-06-13 (금), 16:03 -0700, Andi Kleen:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a --quiet flag to perf list to not print the event descriptions
> that were earlier added for JSON events. This may be useful to
> get a less crowded listing.
> 
> It's still default to print descriptions as that is the more useful
> default for most users.  Requested by Namhyung Kim.

Did I request the --quiet thing?  It seems like there's a
miscommunication.. :-/

I still prefer -v option and not printing descriptions by default - but
want to inform users to use -v option.  However I also want to hear from
others on this.

Btw, it'd better if it can support event glob on the pmu events (or
simply all events) too as this will increase the number of events
significantly.  But this can be a further work.

Thanks,
Namhyung


> 
> Before:
> 
> % perf list
> ...
>   baclears.any                                       [Counts the total number when the front end is
>                                                       resteered, mainly when the BPU cannot provide a
>                                                       correct prediction and this is corrected by other
>                                                       branch handling mechanisms at the front end]
>   br_inst_exec.all_branches                          [Speculative and retired branches]
> 
> After:
> 
> % perf list --quiet
> ...
>   baclears.any                                       [Kernel PMU event]
>   br_inst_exec.all_branches                          [Kernel PMU event]


