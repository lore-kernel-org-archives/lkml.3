Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaAVNVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:21:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbaAVNVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:21:05 -0500
Date: Wed, 22 Jan 2014 14:20:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 00/24] perf tools: Add support to accumulate hist
 periods (v6)
Message-ID: <20140122132018.GC1132@krava.brq.redhat.com>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 02:25:33PM +0900, Namhyung Kim wrote:
> Hello,
> 
> This is a new attempt to implement cumulative hist period report.
> This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
> rewrote it from scratch.
> 
> This patchset is based on my previous patchset [2] but I think it's
> almost independent so that it can be applied separately.
> 
> Please see the patch 03/24.  I refactored functions that add hist
> entries with struct hist_entry_iter.  While I converted all functions
> carefully, it'd be better anyone can test and confirm that I didn't
> mess up something - especially for branch stack and mem stuff.
> 
> This patchset basically adds period in a sample to every node in the
> callchain.  A hist_entry now has an additional fields to keep the
> cumulative period if --children option is given on perf report.
> 
> I changed the option as a separate --children and added a new
> "Children" column (and renamed the default "Overhead" column into
> "Self").  The output will be sorted by children (cumulative) overhead
> for now.  The reason I changed to the --children is that I still think
> it's much different from other --call-graph options.  The --call-graph
> option will take care of it even with --children option.
> 
> I know that the UI should be changed also to be more flexible as Ingo
> requested, but I'd like to do this first and then move to work on the
> next.  I also added a new config option to enable it by default.
> 
>  * changes in v6:
>   - separate struct hist_iter_ops (Jiri)
>   - check iter->he before calling ->add_entry_cb (Jiri)
>   - fix locking issue on perf top (Jiri)

I have changes on top of this patchset and all looks great, I was
just going throught this again and wanted to send my ack, but it
no longer merges to the acme's perf/core.

Could you please send updated version, and I'll finish the
review.. I promise ;-)

thanks,
jirka
