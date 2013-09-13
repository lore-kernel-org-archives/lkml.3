Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3IMLaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:30:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45514 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab3IMLaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:30:15 -0400
Date: Fri, 13 Sep 2013 13:29:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Vince Weaver <vince@deater.net>,
        Andi Kleen <ak@linux.intel.com>, acme@infradead.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        torvalds@linux-foundation.org, trinity@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Message-ID: <20130913112956.GA21832@twins.programming.kicks-ass.net>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
 <20130912165733.GA23698@gmail.com>
 <20130912173617.GI18242@two.firstfloor.org>
 <20130913085654.GI31370@twins.programming.kicks-ass.net>
 <20130913095057.GB11611@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130913095057.GB11611@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 11:50:57AM +0200, Ingo Molnar wrote:
> For example if we added 'type' as well we could expose the generic, 
> hardware-independent events via sysfs as well.

Type is already fully implied by where you'll find the event in sysfs:

  /sys/bus/event_sources/devices/$PMU/events/

needs

  perf_event_attr::type := /sys/bus/event_sources/devices/$PMU/type
