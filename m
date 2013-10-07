Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3JGRkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:40:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42505 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3JGRkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:40:51 -0400
Date: Mon, 7 Oct 2013 19:40:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Clean up cap_user_time* setting
Message-ID: <20131007174037.GI3081@twins.programming.kicks-ass.net>
References: <tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org>
 <524F097A.9010506@intel.com>
 <20131004185539.GT15690@laptop.programming.kicks-ass.net>
 <20131006091054.GA4342@gmail.com>
 <5252EDBE.7030805@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5252EDBE.7030805@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:22:06AM -0700, H. Peter Anvin wrote:
> CONFIG_X86_TSC is a baseline control option; we shouldn't key
> functionality off of it.  It's fine to say notsc -> no tracing, but
> making it a compile-time key makes me a bit uphappy.  We cut off 386,
> but cutting of 486 at this point makes me nervous.

The thing that annoys me about notsc is that it disables usage even if
its present.

I've no problem with 486 which simply doesn't have TSC and thus
cpu_has_tsc will be false and other stuff will happen -- and I don't
think my proposition would actually change anything there.

What is completely insane is people using notsc on say a haswell chip
and expecting something sane to happen.

So I'm not proposing we remove !cap_has_tsc support; all I'm proposing
is we remove the notsc knob that avoids using the TSC on perfectly good
hardware.
