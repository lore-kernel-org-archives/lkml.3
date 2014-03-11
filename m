Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaCKOFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:05:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaCKOFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:05:09 -0400
Date: Tue, 11 Mar 2014 14:37:32 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/8] perf, tools: Add support for reading JSON event files
Message-ID: <20140311133732.GA22678@krava.redhat.com>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394048978-15909-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:49:32AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a parser for Intel style JSON event files. This allows
> to use an Intel event list directly with perf. The Intel
> event lists can be quite large and are too big to store
> in unswappable kernel memory.
> 
> The parser code knows how to convert the JSON fields
> to perf fields. The conversion code is straight forward.
> It knows (very little) Intel specific information, and can be easily
> extended to handle fields for other CPUs.
> 
> The parser code is partially shared with an independent parsing
> library, which is 2-clause BSD licenced. To avoid any conflicts I marked
> those files as BSD licenced too. As part of perf they become GPLv2.
> 
> The events are handled using the existing alias machinery.
> 
> We output the BriefDescription in perf list.
> 
> Right now the json file can be specified as an argument
> to perf stat/record/list. Followon patches will automate this.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Documentation/perf-list.txt   |   6 +
>  tools/perf/Documentation/perf-record.txt |   3 +
>  tools/perf/Documentation/perf-stat.txt   |   3 +
>  tools/perf/Makefile.perf                 |   2 +
>  tools/perf/builtin-list.c                |   2 +
>  tools/perf/builtin-record.c              |   3 +
>  tools/perf/builtin-stat.c                |   2 +
>  tools/perf/util/jevents.c                | 248 +++++++++++++++++++++++++++++++
>  tools/perf/util/jevents.h                |   3 +
>  tools/perf/util/pmu.c                    | 141 ++++++++++++++----
>  tools/perf/util/pmu.h                    |   2 +

please put the alias code factoring (perf_pmu__new_alias)
and print_pmu_events changes to separate commits

jirka
