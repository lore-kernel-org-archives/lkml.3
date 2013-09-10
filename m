Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab3IJLer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:34:47 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:57162 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3IJLeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:34:46 -0400
Date: Tue, 10 Sep 2013 13:34:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/3] perf callchain: Convert children list to rbtree
Message-ID: <20130910113441.GB28268@somewhere>
References: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
 <1378801458-2515-2-git-send-email-namhyung@kernel.org>
 <20130910095216.GB18115@krava.redhat.com>
 <20130910102554.GA5087@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910102554.GA5087@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 12:25:54PM +0200, Ingo Molnar wrote:
> 
> * Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Tue, Sep 10, 2013 at 05:24:16PM +0900, Namhyung Kim wrote:
> > > From: Namhyung Kim <namhyung.kim@lge.com>
> > > 
> > > Current collapse stage has a scalability problem which can be
> > > reproduced easily with parallel kernel build.  This is because it
> > > needs to traverse every children of callchain linearly during the
> > > collapse/merge stage.  Convert it to rbtree reduced the overhead
> > > significantly.
> > > 
> > > On my 400MB perf.data file which recorded with make -j32 kernel build:
> > 
> > 
> > nice!!!
> 
> Nice indeed!
> 
> > tried on 2.6 GB data file from kernel make -j64 and got report speed up 
> > from 'never' to 2m52.756s ;-)
> 
> It's still rather long though, unacceptable for everyday usage :-/
> 
> Frederic thought that we could reduce minimize collapsing to begin with.
> 
> Frederic, could you outline that in more detail please?

Yeah. Currently when we sort by comm, hists are first sorted by tid. Then
in the end of the record, the hists are compared and those that have the
same comm are collapsed in one.

So what I'm trying to do now is to gather those hists from the very beginning,
which should remove the need for collapsing.

> 
> Thanks,
> 
> 	Ingo
