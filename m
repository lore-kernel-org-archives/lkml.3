Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab3AWWCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 17:02:18 -0500
Received: from mail-gh0-f179.google.com ([209.85.160.179]:54053 "EHLO
	mail-gh0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWWCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:02:07 -0500
Date: Wed, 23 Jan 2013 19:02:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Colin King <colin.king@canonical.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf evsel: fix NULL pointer deference when
 evsel->counts is NULL
Message-ID: <20130123220200.GE6687@ghostprotocols.net>
References: <1358613414-13005-1-git-send-email-colin.king@canonical.com>
 <871udfkua5.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871udfkua5.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 21, 2013 at 01:53:21PM +0900, Namhyung Kim escreveu:
> On Sat, 19 Jan 2013 16:36:54 +0000, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>

> > __perf_evsel__read_on_cpu() only bails out with -ENOMEM if
> > evsel->counts is NULL and perf_evsel__alloc_counts() has returned
> > an error.  If perf_evsel__alloc_counts() does not return an error
> > we get an NULL pointer deference on evsel->counts->cpu[cpu]
> > if evsel->counts is NULL.

> perf_evsel__alloc_counts() should allocate evsel->counts when it sees
> evsel->counts is NULL and return negative error code if the allocation
> fails.

> So I don't see any problem in current code.  With your code, it won't
> try to allocate if ->counts is NULL but overwrite existing ->counts?

Right, the patch introduces a problem in code that works perfectly :-)

- Arnaldo
