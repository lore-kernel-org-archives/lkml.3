Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3IJKZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 06:25:59 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:33451 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3IJKZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 06:25:57 -0400
Date: Tue, 10 Sep 2013 12:25:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] perf callchain: Convert children list to rbtree
Message-ID: <20130910102554.GA5087@gmail.com>
References: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
 <1378801458-2515-2-git-send-email-namhyung@kernel.org>
 <20130910095216.GB18115@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910095216.GB18115@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Tue, Sep 10, 2013 at 05:24:16PM +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > Current collapse stage has a scalability problem which can be
> > reproduced easily with parallel kernel build.  This is because it
> > needs to traverse every children of callchain linearly during the
> > collapse/merge stage.  Convert it to rbtree reduced the overhead
> > significantly.
> > 
> > On my 400MB perf.data file which recorded with make -j32 kernel build:
> 
> 
> nice!!!

Nice indeed!

> tried on 2.6 GB data file from kernel make -j64 and got report speed up 
> from 'never' to 2m52.756s ;-)

It's still rather long though, unacceptable for everyday usage :-/

Frederic thought that we could reduce minimize collapsing to begin with.

Frederic, could you outline that in more detail please?

Thanks,

	Ingo
