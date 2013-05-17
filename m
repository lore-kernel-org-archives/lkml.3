Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3EQJ31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:29:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58767 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab3EQJ30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:29:26 -0400
Date: Fri, 17 May 2013 11:27:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Robert Richter <rric@kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130517092741.GR19669@dyad.programming.kicks-ass.net>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
 <20130516181018.GO19669@dyad.programming.kicks-ass.net>
 <20130516205558.GE8356@rric.localhost>
 <20130516213420.GB31393@pd.tnic>
 <20130517090451.GQ19669@dyad.programming.kicks-ass.net>
 <20130517091651.GB23035@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517091651.GB23035@pd.tnic>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 11:16:51AM +0200, Borislav Petkov wrote:
> On Fri, May 17, 2013 at 11:04:51AM +0200, Peter Zijlstra wrote:
> > Mostly so that check_hw_exists() doesn't need to know about the vendor
> > specifics like where the MSRs live, how many there are etc..
> 
> Yep, but there will still be issues with perf when booted on a guest and
> kvm not supporting it. And AFAIU, they're signalling this by turning off
> CPUID bits so that initializing perf doesn't happen.
> 
> So, I think init_hw_perf_events should as a first step look at CPUID
> bits and then do anything else. And this is done on Intel with
> X86_FEATURE_ARCH_PERFMON. But Robert is fixing this on AMD too so...

But not all x86 hardware even has the stuff enumerated in CPUID, and afaict
Intel and AMD use a different CPUID bit as well, so what's
init_hw_perf_events() to do?
