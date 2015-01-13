Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbbAMLZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:25:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:51291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbAMLZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:25:31 -0500
Date: Tue, 13 Jan 2015 12:25:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, corbet@lwn.net, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, rientjes@google.com,
        ak@linux.intel.com, mgorman@suse.de, raistlin@linux.it,
        kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org,
        gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com,
        oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com,
        keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu,
        vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing a
 timeslice
Message-ID: <20150113112516.GH25256@twins.programming.kicks-ass.net>
References: <54935842.5020507@oracle.com>
 <alpine.DEB.2.11.1412182355020.17382@nanos>
 <54936562.5070502@oracle.com>
 <alpine.DEB.2.11.1412190045590.17382@nanos>
 <54949BF0.8030403@oracle.com>
 <alpine.DEB.2.11.1412200041220.17382@nanos>
 <5498498B.90703@oracle.com>
 <20141223105251.GB22203@gmail.com>
 <5499867C.1010201@oracle.com>
 <5499B8A2.4080008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5499B8A2.4080008@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 01:46:58PM -0500, Rik van Riel wrote:
> An uncontended futex is taken without ever going into kernel
> space. Adaptive spinning allows short duration futexes to be
> taken without going into kernel space.

The going into kernel is a red herring afaict, a no-op syscall costs ~180
cycles or something like that. So sure you can do a wee spin (~90 cycles
to try and amortize that), but I really doubt that this is the problem.
