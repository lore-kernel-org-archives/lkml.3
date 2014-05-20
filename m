Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaETNPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:15:31 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:51230 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaETNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:15:30 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Tue, 20 May 2014 09:19:27 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/3] perf: disable sampled events if no PMU interrupt
In-Reply-To: <20140520091216.GS2485@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1405200917060.18606@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu> <alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu> <20140520091216.GS2485@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Peter Zijlstra wrote:

> > +#define PERF_PMU_NO_INTERRUPT		1
> 
> Are you ok with me making that:
> 
> #define PERF_PMU_CAP_NO_INTERRUPT		0x01

sounds good.  All my recent fuzzing has made me paranoid enough to 
double check that yes indeed we don't need to slap an ULL on the end of 
that.

Though I hope 32-bits is enough for this, I feel like we've just added the 
feature and suddenly all kinds of uses are coming out of the woodwork.

Vince
