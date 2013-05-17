Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3EQJqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:46:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43053 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3EQJp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:45:59 -0400
Date: Fri, 17 May 2013 11:45:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rric@kernel.org>, Josh Boyer <jwboyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130517094551.GE23035@pd.tnic>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516175557.GC18325@hansolo.jdub.homelinux.org>
 <20130516181018.GO19669@dyad.programming.kicks-ass.net>
 <20130516205558.GE8356@rric.localhost>
 <20130516213420.GB31393@pd.tnic>
 <20130517090451.GQ19669@dyad.programming.kicks-ass.net>
 <20130517091651.GB23035@pd.tnic>
 <20130517092741.GR19669@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130517092741.GR19669@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 11:27:41AM +0200, Peter Zijlstra wrote:
> But not all x86 hardware even has the stuff enumerated in CPUID, and
> afaict Intel and AMD use a different CPUID bit as well, so what's
> init_hw_perf_events() to do?

Yeah, I think the best solution would be if we force-enable the CPUID
bit on F10h very early and teach amd_pmu_init() to look at it. I even
had a patch which does something like that. I could dust it off and give
it a try... I just hope we can actually enable a reserved bit in CPUID.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
