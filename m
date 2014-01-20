Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaATVjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:39:51 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38402 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaATVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:39:49 -0500
MIME-Version: 1.0
In-Reply-To: <20140120092931.GA3836@gmail.com>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	<20140116121955.GQ31570@twins.programming.kicks-ass.net>
	<20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
	<CAJvTdKnoNh2YAvtXraYxTct+8e6e_8Om9cAZGSTpy8UO=t=W4w@mail.gmail.com>
	<20140120082620.GB30183@twins.programming.kicks-ass.net>
	<52DCE4CF.2060605@zytor.com>
	<20140120091600.GW31570@twins.programming.kicks-ass.net>
	<52DCEAF4.3040902@zytor.com>
	<20140120092931.GA3836@gmail.com>
Date: Mon, 20 Jan 2014 16:39:45 -0500
X-Google-Sender-Auth: k4GnFEcg7e2T-GCaPnq2sls9EoA
Message-ID: <CAJvTdKmF0Bzo+=VRD=3dZKVZAxAQ=am33fFGR7XH4hYd2=9Mww@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tip tree
From: Len Brown <lenb@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As a side note, at minimum the semantic and compatibility difference
> needs to be _very_ clearly present in the naming. Something like
> mwait_old_() or mwait_core2_(). That way such dependencies and
> assumptions don't get lost in code restructuring, etc.

Agreed.
We started with mwait_idle() -- which was erroneously removed
and is now being restored under it original name.

The "new" function is mwait_idle_with_hints() -- which uses
the additional hints that were not available w/ the original MWAIT instruction.
Where "new" is Core Duo and later -- all the processor that can use
MWAIT for C-states deeper than C1.

Len Brown, Intel Open Source Technology Center
