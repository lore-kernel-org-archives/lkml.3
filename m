Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbbANBi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 20:38:59 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43537 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbANBi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 20:38:58 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 14 Jan 2015 10:35:04 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Kan Liang <kan.liang@intel.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH 5/7] perf tools: Pass struct perf_hpp_fmt to its callbacks
Message-ID: <20150114013504.GB800@sejong>
References: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
 <1420677949-6719-6-git-send-email-namhyung@kernel.org>
 <20150112162140.GK12406@kernel.org>
 <20150112162736.GL12406@kernel.org>
 <20150112164050.GB18267@krava.brq.redhat.com>
 <20150112164406.GC29743@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150112164406.GC29743@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Jiri,

On Mon, Jan 12, 2015 at 01:44:06PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 12, 2015 at 05:40:50PM +0100, Jiri Olsa escreveu:
> > On Mon, Jan 12, 2015 at 01:27:36PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Mon, Jan 12, 2015 at 01:21:40PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > Em Thu, Jan 08, 2015 at 09:45:46AM +0900, Namhyung Kim escreveu:
> > > > > Currently ->cmp, ->collapse and ->sort callbacks doesn't pass
> > > > > corresponding fmt.  But it'll be needed by upcoming changes in
> > > > > perf diff command.
> > > > > 
> > > > > Suggested-by: Jiri Olsa <jolsa@kernel.org>
> > > > 
> > > > 
> > > >   CC       /tmp/build/perf/builtin-evlist.o
> > > > builtin-diff.c: In function ‘data__hpp_register’:
> > > > builtin-diff.c:1036:11: error: assignment from incompatible pointer type [-Werror]
> > > >   fmt->cmp    = hist_entry__cmp_nop;
> > > >            ^
> > > > builtin-diff.c:1037:16: error: assignment from incompatible pointer type [-Werror]
> > > >   fmt->collapse = hist_entry__cmp_nop;
> > > >                 ^
> > > > builtin-diff.c:1043:13: error: assignment from incompatible pointer type [-Werror]
> > > >    fmt->sort  = hist_entry__cmp_baseline;
> > > >              ^
> > > > builtin-diff.c:1047:13: error: assignment from incompatible pointer type [-Werror]
> > > >    fmt->sort  = hist_entry__cmp_delta;
> > > >              ^
> > > > builtin-diff.c:1051:13: error: assignment from incompatible pointer type [-Werror]
> > > >    fmt->sort  = hist_entry__cmp_ratio;
> > > >              ^
> > > > builtin-diff.c:1055:13: error: assignment from incompatible pointer type [-Werror]
> > > >    fmt->sort  = hist_entry__cmp_wdiff;
> > > >              ^
> > > > builtin-diff.c:1058:13: error: assignment from incompatible pointer type [-Werror]
> > > >    fmt->sort  = hist_entry__cmp_nop;
> > > >              ^
> > > > cc1: all warnings being treated as errors
> > > >   LINK     plugin_kvm.so
> > > > make[1]: *** [/tmp/build/perf/builtin-diff.o] Error 1
> > > > make[1]: *** Waiting for unfinished jobs....
> > > >   LINK     plugin_mac80211.so
> > > 
> > > Am I missing something? Lemme continue trying applying the rest of the
> > > kit...
> > 
> > hum,
> > looks like those (= hist_entry__cmp_delta,.. functions) are fixed (=added fmt param)
> > later in patch 6/7 of this series.. which is wrong, should be updated in this patch,
> > as you did below
> 
> I have it all fixed up and pushed to my perf/core branch, thanks for
> checking!

Oops, my bad.  It must came from the many of rebases during the
development.  Sorry about that and really thank you to fix them up.

Thanks,
Namhyung
