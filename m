Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3LSVRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:17:09 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:44725 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3LSVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:17:07 -0500
Date: Thu, 19 Dec 2013 22:17:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Len Brown <lenb@kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power
 regression
Message-ID: <20131219211701.GB3464@gmail.com>
References: <52B316FF.50906@zytor.com>
 <20131219160210.GA28426@gmail.com>
 <52B31B21.6010901@zytor.com>
 <20131219162136.GM16438@laptop.programming.kicks-ass.net>
 <52B323BE.7090108@zytor.com>
 <20131219170741.GB30382@gmail.com>
 <20131219172535.GN16438@laptop.programming.kicks-ass.net>
 <20131219175037.GK2480@laptop.programming.kicks-ass.net>
 <20131219181812.GC32508@gmail.com>
 <44cc7c3a-7114-4f37-a844-77e552dbc7aa@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44cc7c3a-7114-4f37-a844-77e552dbc7aa@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> CLFLUSH is only (guaranteed to be) ordered with respect to MFENCE 
> according to the SDM.

Yes, I quoted the relevant text a couple of hours ago, CLFLUSH is 
pretty special, so it's not ordered against atomics or serializing 
instructions for example - only ordered against explict MFENCE calls, 
which on x86 is mb()/smp_mb().

Thanks,

	Ingo
