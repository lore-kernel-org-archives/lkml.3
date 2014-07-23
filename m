Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbaGXNti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:49:38 -0400
Received: from mail.kernel.org ([198.145.19.201]:42420 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759138AbaGXNth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:49:37 -0400
Date: Wed, 23 Jul 2014 11:05:32 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/52] perf tools: Fix jump label always changing during
 tracing
Message-ID: <20140723140532.GI20303@kernel.org>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-2-git-send-email-adrian.hunter@intel.com>
 <20140722140034.GE20303@kernel.org>
 <20140722141135.GF3935@laptop>
 <53CF5124.2090901@intel.com>
 <20140723065822.GN3935@laptop>
 <53CF6121.3050500@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CF6121.3050500@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 23, 2014 at 10:15:45AM +0300, Adrian Hunter escreveu:
> On 07/23/2014 09:58 AM, Peter Zijlstra wrote:
> > On Wed, Jul 23, 2014 at 09:07:32AM +0300, Adrian Hunter wrote:
> >> On 07/22/2014 05:11 PM, Peter Zijlstra wrote:
> >>> On Tue, Jul 22, 2014 at 11:00:34AM -0300, Arnaldo Carvalho de Melo wrote:
> >>>> Em Tue, Jul 22, 2014 at 04:17:10PM +0300, Adrian Hunter escreveu:
> >>>>> Intel PT decoding walks the object code to reconstruct
> >>>>> the trace.  A jump label change during tracing causes
> >>>>> decoding errors.

> >>> You'd better fix that, jump_labels can change any time and they're all
> >>> over the frigging place.

> >> Perhaps a general method is needed to be able to deal with kernel
> >> self-modifying code.

> > I know people are looking at doing the same to userspace, is that also a
> > problem?

> Yes, most significantly JIT-compiled code.

It would be great to figure out the parts that were patched, so as to
have the original and patched lines disassembled and properly marked as
such in the annotation widgets, using a different colour, and allowing
to flip to/from original/patched.

I wonder if there is some place with a list of the areas that were
patched or that can be patched if enabled, etc, surely there is one for
ftrace stuff, etc.

- Arnaldo
