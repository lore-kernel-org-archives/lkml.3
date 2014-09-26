Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbaIZOMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:12:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:34375 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbaIZOMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:12:36 -0400
Date: Fri, 26 Sep 2014 11:12:30 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 1/2] perf tool: encapsulate dsos list head into struct
 dsos
Message-ID: <20140926141230.GB3879@kernel.org>
References: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com>
 <1411573540-8765-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411573540-8765-2-git-send-email-Waiman.Long@hp.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 24, 2014 at 11:45:39AM -0400, Waiman Long escreveu:
> This is a precursor patch to enable long name searching of DSOs
> using the rbtree. In this patch, a new dsos structure is created
> which contains only a list head structure for the moment. The new
> dsos structure is used, in turn, in the machine structure for the
> user_dsos and kernel_dsos fields. Only the following 3 dsos functions
> are modified to accept the new dsos structure parameter instead
> of list_head:
>  - dsos__add()
>  - dsos__find()
>  - __dsos__findnew()
> 
> Because of the need to find out the corresponding dsos structure to
> properly call dsos__add() in dso__load_sym() of util/symbol-elf.c,
> a new dsos field is also added to the dso structure.

What tree did you use to produce these patches? I just tried on my
perf/core branch and I get some fuzzes:

[acme@zoo linux]$ patch -p1 < /wb/1.patch 
patching file tools/perf/util/dso.c
Hunk #1 succeeded at 755 (offset 2 lines).
Hunk #2 succeeded at 852 (offset 2 lines).
patching file tools/perf/util/dso.h
patching file tools/perf/util/header.c
patching file tools/perf/util/machine.c
Hunk #2 succeeded at 72 (offset 2 lines).
Hunk #3 succeeded at 477 (offset 29 lines).
Hunk #4 succeeded at 994 (offset 29 lines).
patching file tools/perf/util/machine.h
Hunk #2 succeeded at 39 with fuzz 1 (offset 1 line).
patching file tools/perf/util/probe-event.c
patching file tools/perf/util/symbol-elf.c
Hunk #1 succeeded at 929 (offset 13 lines).
[acme@zoo linux]$

I'll fix this up, probably harmless, just a heads up.

- Arnaldo
