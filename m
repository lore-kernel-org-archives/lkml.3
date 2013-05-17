Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3EQJRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:17:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34307 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab3EQJQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:16:59 -0400
Date: Fri, 17 May 2013 11:16:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rric@kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130517091651.GB23035@pd.tnic>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
 <20130516181018.GO19669@dyad.programming.kicks-ass.net>
 <20130516205558.GE8356@rric.localhost>
 <20130516213420.GB31393@pd.tnic>
 <20130517090451.GQ19669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130517090451.GQ19669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 11:04:51AM +0200, Peter Zijlstra wrote:
> Mostly so that check_hw_exists() doesn't need to know about the vendor
> specifics like where the MSRs live, how many there are etc..

Yep, but there will still be issues with perf when booted on a guest and
kvm not supporting it. And AFAIU, they're signalling this by turning off
CPUID bits so that initializing perf doesn't happen.

So, I think init_hw_perf_events should as a first step look at CPUID
bits and then do anything else. And this is done on Intel with
X86_FEATURE_ARCH_PERFMON. But Robert is fixing this on AMD too so...

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
