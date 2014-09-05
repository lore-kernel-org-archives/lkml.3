Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbaIEBNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 21:13:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:44352 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637AbaIEBNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 21:13:17 -0400
Date: Thu, 4 Sep 2014 22:13:11 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build-id matching on vmlinux
Message-ID: <20140905011311.GB30520@kernel.org>
References: <1409035119-24357-1-git-send-email-namhyung@kernel.org>
 <CABPqkBRdbp6nDBFsz0gdp+qpNu+H6C4pyPTAC-EKYFoca2z+sQ@mail.gmail.com>
 <8761h2ap9f.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761h2ap9f.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 05, 2014 at 09:23:56AM +0900, Namhyung Kim escreveu:
> Hmm.. now I'm curious that why the -H option is needed at all.. the perf
> record already wrote build-ids that are actually hits..

Probably because when 'perf buildid-list' was introduced 'perf record'
was inserting all the PERF_RECORD_MMAP dsos into the buildid-list, not
just the ones with hits.

Then, later on, 'perf record' probably moved to register just the ones
with hits.

This way -H ends up being a nop, i.e. should produce the same result as
'perf buildid-list' with no options.

If it doesn't, then it is a bug.

- Arnaldo
