Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3EQJGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:06:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58381 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3EQJGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:06:47 -0400
Date: Fri, 17 May 2013 11:04:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Robert Richter <rric@kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130517090451.GQ19669@dyad.programming.kicks-ass.net>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
 <20130516181018.GO19669@dyad.programming.kicks-ass.net>
 <20130516205558.GE8356@rric.localhost>
 <20130516213420.GB31393@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516213420.GB31393@pd.tnic>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 11:34:20PM +0200, Borislav Petkov wrote:
> On Thu, May 16, 2013 at 10:55:58PM +0200, Robert Richter wrote:
> > iirc the reason was the different msr range that is switched on fam15h
> > with a different counter to counter msr offset of 2 instead of 1. The
> > code relies on the assumption that the msrs exist on that cpu. Thus
> > the warning if not. Also note that code may have changed in 3.10 in
> > that area.
> 
> Stupid question: why is check_hw_exists() *after* the vendor-specific
> counter detection code in init_hw_perf_events() even though it is
> supposed to check whether hardware is emulated?

Mostly so that check_hw_exists() doesn't need to know about the vendor
specifics like where the MSRs live, how many there are etc..


