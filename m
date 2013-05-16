Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3EPUAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:00:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56101 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab3EPUAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:00:19 -0400
Date: Thu, 16 May 2013 22:00:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Gleb Natapov <gleb@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Josh Boyer <jwboyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Richter <rric@kernel.org>
Subject: Re: Drop WARN on AMD lack of perfctrs
Message-ID: <20130516200011.GA31393@pd.tnic>
References: <20130516151026.GB18325@hansolo.jdub.homelinux.org>
 <20130516175117.GK19669@dyad.programming.kicks-ass.net>
 <20130516193137.GI14597@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130516193137.GI14597@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 10:31:37PM +0300, Gleb Natapov wrote:
> Actually it looks like it is the opposite: CPUID crap indicates
> it got no perf, but the code expects this cpu model to have it.

Yep, AFAICT the code should look at cpu_has_perfctr_core already in
amd_pmu_init() and exit if the CPUID bit is not set.

Robert?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
-
-
