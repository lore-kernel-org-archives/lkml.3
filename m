Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab3BVIq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:46:28 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53854
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755219Ab3BVIqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:46:24 -0500
Message-ID: <1361522767.26780.44.camel@laptop>
Subject: Re: [PATCH 0/2] cpustat: use atomic operations to read/update stats
From: Peter Zijlstra <peterz@infradead.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Date: Fri, 22 Feb 2013 09:46:07 +0100
In-Reply-To: <1361512604-2720-1-git-send-email-khilman@linaro.org>
References: <1361512604-2720-1-git-send-email-khilman@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 21:56 -0800, Kevin Hilman wrote:
> On 64-bit platforms, reads/writes of the various cpustat fields are
> atomic due to native 64-bit loads/stores.  However, on non 64-bit
> platforms, reads/writes of the cpustat fields are not atomic and could
> lead to inconsistent statistics.

Which is a problem how?

> This problem was originally reported by Frederic Weisbecker as a
> 64-bit limitation with the nsec granularity cputime accounting for
> full dynticks, but then we realized that it's a problem that's been
> around for awhile and not specific to the new cputime accounting.
> 
> This series fixes this by first converting all access to the cputime
> fields to use accessor functions, and then converting the accessor
> functions to use the atomic64 functions.

Argh!! at what cost? 64bit atomics are like expensive. Wouldn't adding
a seqlock be saner?

