Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbaLINjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:39:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbaLINjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:39:54 -0500
Date: Tue, 9 Dec 2014 11:39:47 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        ak@linux.intel.com, Jiri Olsa <jolsa@redhat.com>, acme@kernel.org
Subject: Re: [PATCH v7 1/6] perf: add ability to sample machine state on
 interrupt
Message-ID: <20141209133947.GD2406@redhat.com>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
 <1411559322-16548-2-git-send-email-eranian@google.com>
 <20141121212631.GF5395@redhat.com>
 <20141209133031.GC2406@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209133031.GC2406@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 09, 2014 at 11:30:31AM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Nov 21, 2014 at 07:26:31PM -0200, Arnaldo Carvalho de Melo escreveu:
> > Em Wed, Sep 24, 2014 at 01:48:37PM +0200, Stephane Eranian escreveu:
> > > This patch also adds a new ABI version
> > > PERF_ATTR_SIZE_VER4 because we extend
> > > the perf_event_attr struct with a new u64
> > > field.
 
> I think this problem is also related to this changeset:
 
> [root@zoo ~]# perf test -v 15
> 15: struct perf_event_attr setup                           :
<SNIP>
> running '/home/acme/libexec/perf-core/tests/attr/test-stat-default'
> expected size=96, got 104
> FAILED '/home/acme/libexec/perf-core/tests/attr/test-stat-default' -
> match failure
> test child finished with 0
> ---- end ----
> struct perf_event_attr setup: Ok
> [root@zoo ~]# uname -r
> 3.17.3-200.fc20.x86_64
> [root@zoo ~]#
> 
> Checking if this is just a matter of updating the test entry.

Well, here I think that size variable needs to somehow be tested against
the value of another field, the ABI one, so that for each ABI we test
against the rightsize, that is, after this cset, 8 bytes (sizeof u64)
bigger, Jiri?

- Arnaldo
