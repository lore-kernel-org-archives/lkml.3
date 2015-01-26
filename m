Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbbAZOYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:24:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:47267 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbbAZOYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:24:51 -0500
Date: Mon, 26 Jan 2015 15:24:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
In-Reply-To: <2137807.aqSxQQCuJ3@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.11.1501261523370.5526@nanos>
References: <54866625.8010406@linux.intel.com> <54C5FE6A.9010300@linux.intel.com> <alpine.DEB.2.11.1501260946390.5526@nanos> <2137807.aqSxQQCuJ3@vostro.rjw.lan>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Rafael J. Wysocki wrote:
> On Monday, January 26, 2015 10:40:24 AM Thomas Gleixner wrote:
> > The only remaining issue might be a NMI calling into
> > ktime_get_mono_fast_ns() before timekeeping is resumed. Its probably a
> > non issue on x86/tsc, but it might be a problem on other platforms
> > which turn off devices, clocks, It's not rocket science to prevent
> > that.
> 
> I don't see any users of ktime_get_mono_fast_ns() at all, unless some non-trivial
> macros are involved.  At least grepping for it only returns the definition,
> declarations and the line in trace.c.

You can trace in NMI and perf is going to use ktime_get_mono_fast_ns()
eventually as well.

Thanks,

	tglx
