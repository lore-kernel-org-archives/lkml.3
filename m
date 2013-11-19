Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab3KSNXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:23:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3KSNXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:23:20 -0500
Message-ID: <1384867272.5344.28.camel@marge.simpson.net>
Subject: Re: [PATCH] x86, acpi, idle: Restructure the mwait idle routines
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com,
        rui.zhang@intel.com, arjan@linux.intel.com,
        jacob.jun.pan@linux.intel.com, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
Date: Tue, 19 Nov 2013 14:21:12 +0100
In-Reply-To: <20131119113153.GD3694@twins.programming.kicks-ass.net>
References: <20131119090019.GJ3866@twins.programming.kicks-ass.net>
	 <20131119090859.GC3694@twins.programming.kicks-ass.net>
	 <20131119113153.GD3694@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:CQimyiiRLxGU83+icS+FH7ITUz6UK2rrGnjMqiGzkgp
 47umlAJgRE9tVpr3vwrVV/Dd1PcJrDwA5o045bbZ1SdWrbW7f6
 H2pLQJt/rOBWTI3524mInEc8movgZIIfHjNA6NXaUMKLiZ70Rj
 hM/uhaTnbg1lH5opGWZUkQI+rmP11D4BVbsALVw/edCbPiHiNt
 KJ1sJgDdEQHtk0Vn7OSRAFEGdVz1fUnyOI59grPeD2zFrKQLu5
 Vgp1u24cypDVpo7QR4g+A1Vn1gKc6YXxNLlgENfJRYgfYZOTKD
 49sgKb7//BAcO1re+MENbqDb88Jbp3IHNNuo/6jDhEprHw7E83
 OBWisoy5PVNAR/ImKqHkzVEa+BJx27jyD+iPDp4GR68Ae4ahML
 LRCkdnv5XrP5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 12:31 +0100, Peter Zijlstra wrote: 
> People seem to delight in writing wrong and broken mwait idle routines;
> collapse the lot.
> 
> This leaves mwait_play_dead() the sole remaining user of __mwait() and
> new __mwait() users are probably doing it wrong.
> 
> Also remove __sti_mwait() as its unused.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
> 
> Mike, does this cure your core2?

Nope.  Maybe an acpi/bios thingy on this box since diags that fired on
lappy during boot did not fire on desktop, and both are core2 booting
same kernel.  I kinda suspect I'll either be stuck with default_idle or
have to resurrect mwait_idle and carry it locally if I want the thing to
work well.  Guess I'll find out if/when I have time to squabble with it.

Meanwhile, desktop box works fine modulo benchmarks, lappy works fine
too, modulo max_cstate=1 scaring mwait_idle_with_hints away, which I
don't care about much.  Neither box is wonderful at rt testing where I
usually boot max_cstate=1, both just became a bit _less_ wonderful :)

-Mike

