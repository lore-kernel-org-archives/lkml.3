Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083AbaE2N7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:59:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780AbaE2N7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:59:31 -0400
Date: Thu, 29 May 2014 15:59:00 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCHSET 00/27] perf tools: Add support to accumulate hist
 periods (v11)
Message-ID: <20140529135859.GF1177@krava.brq.redhat.com>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:58:03PM +0900, Namhyung Kim wrote:
> Hello,
> 
> This is a new attempt to implement cumulative hist period report.
> This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
> rewrote it from scratch.
> 
> This patchset basically adds period in a sample to every node in the
> callchain.  A hist_entry now has an additional fields to keep the
> cumulative period if --children option is given on perf report.
> 
> I changed the option as a separate --children and added a new
> "Children" column (and renamed the default "Overhead" column into
> "Self").  The output will be sorted by children (cumulative) overhead
> for now.  It also adds 'overhead_children' field to -F/--fields option
> to be selected by user and it'll show you "N/A" if the cumulation is
> not supported (due to missing callchain).
> 
> I added Tested-by from Rodrigo Campos since this version is basically
> rebase of previous series + bugfix.  But it still needs to be tested
> more intensively IMHO.  Also note that, this will change default
> behavior of perf report/top if callchain is recorded, so might confuse
> old users.  Let's see how many of them come to shout. :)  I think we
> need to merge Jiri's TUI column header patch at least.
> 
> 
>  * changes in v11:
>   - factor out hists__inc_nr_samples  (Jiri)
>   - remove unrelated change  (Jiri)
>   - disable accumulation on branch or mem mode
>   - slightly refactor hist_iter code

apart from that comment I sent, I think it's ready to go in

thanks,
jirka
