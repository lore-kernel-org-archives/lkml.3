Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab3IJJRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 05:17:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41439 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab3IJJRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 05:17:18 -0400
Date: Tue, 10 Sep 2013 11:17:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        namhyung.kim@lge.com, dsahern@gmail.com
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130910091706.GP26785@twins.programming.kicks-ass.net>
References: <1377079825-19057-3-git-send-email-eranian@google.com>
 <20130909192810.GA3825@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909192810.GA3825@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 04:47:45PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Aug 21, 2013 at 12:10:25PM +0200, Stephane Eranian escreveu:
> > This patch adds support for the new PERF_RECORD_MMAP2
> > record type exposed by the kernel. This is an extended
> > PERF_RECORD_MMAP record. It adds for each file-backed
> > mapping the device major, minor number and the inode
> > number and generation. This triplet uniquely identifies
> > the source of a file-backed mapping. It can be used to
> > detect identical virtual mappings between processes, for
> > instance.
> > 
> > The patch will prefer MMAP2 over MMAP.
> 
> I noticed the kernel part is in, and I'm going to use MMAP2 on that new
> tool, so tried merging it, but:
> 
> I fixed it up wrt another patch that makes machine__find_thread receive pid/tid
> but then 'perf test' complains about it, see below, trying to fix...

Right, so I fed both patches to Ingo, but apparently (checked IRC
backlog) the tools patch didn't apply due to collisions with patches
from acme.

Apparently Ingo forgot to prod both of you to resolve (as I was out on
PTO).
