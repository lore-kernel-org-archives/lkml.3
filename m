Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaCNNY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:24:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaCNNYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:24:55 -0400
Date: Fri, 14 Mar 2014 14:24:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: eranian@google.com, jmario@redhat.com, jolsa@redhat.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: Re: perf MMAP2 interface and COW faults
Message-ID: <20140314132447.GW27965@twins.programming.kicks-ass.net>
References: <20140313200352.GU25953@redhat.com>
 <20140314111705.GU27965@twins.programming.kicks-ass.net>
 <20140314125837.GW25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314125837.GW25953@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 08:58:37AM -0400, Don Zickus wrote:
> Hmmm.  That will probably work for future mmap events.  My problem is for
> synthesized mmap events.  We read the same protection bits from
> /proc/<pid>/maps file, so I assume the same strategy can work for those
> events too?

Yeah, so /proc/$pid/maps doesn't contain all those bits, but it does
have the prot read/write/exec and flags shared/private thing, which
should be sufficient for your needs.
