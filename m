Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3LLUB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:01:58 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:45691 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3LLUB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:01:56 -0500
Date: Thu, 12 Dec 2013 17:01:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 07/71] perf tools: Record whether a dso is 64-bit
Message-ID: <20131212200147.GB11191@ghostprotocols.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-8-git-send-email-alexander.shishkin@linux.intel.com>
 <52A8BC5D.2030603@gmail.com>
 <52A9A672.9050509@intel.com>
 <52A9E826.1020909@gmail.com>
 <20131212190525.GA11191@ghostprotocols.net>
 <52AA0B80.5060509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AA0B80.5060509@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 12, 2013 at 12:16:16PM -0700, David Ahern escreveu:
> On 12/12/13, 12:05 PM, Arnaldo Carvalho de Melo wrote:
> 
> >Well, if we can pass somehow the magic number of an executable mmap
> >in the PERF_RECORD_MMAP2 record, we would be able, together with the
> >data we already have in the perf.data header (uname in a live session),
> >to figure that out, no?
> 
> Sure, but any kernel-side only solution will be extremely limited in
> user base for years.

You mean it will take time for the kernel with this feature to become
widespread?

Sure, but how do you propose to properly implement this using existing
facilities?

I can't think of any way that doesn't requires having access to the file
referenced via PERF_RECORD_{MMAP,MMAP2}, in userspace, and that is racy.

For older kernels, that doesn't support this, we can do as I think you
envision, but that doesn't precludes trying to put in place a more
robust solution.

- Arnaldo
