Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaASA5J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 19:57:09 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:50665 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaASA5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 19:57:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140118212227.GA10038@linux.vnet.ibm.com>
References: <20140115023958.GA10038@linux.vnet.ibm.com>
	<20140115080753.GW31570@twins.programming.kicks-ass.net>
	<20140115205346.GF10038@linux.vnet.ibm.com>
	<20140115232134.GM31570@twins.programming.kicks-ass.net>
	<CA+55aFydYLQeBq=4AQQp_4dAnq09ocLmde1LFaXiNAJ=wJzfFA@mail.gmail.com>
	<20140116103659.GO7572@laptop.programming.kicks-ass.net>
	<20140118100105.GV10038@linux.vnet.ibm.com>
	<20140118113406.GY30183@twins.programming.kicks-ass.net>
	<20140118122548.GX10038@linux.vnet.ibm.com>
	<20140118124136.GZ30183@twins.programming.kicks-ass.net>
	<20140118212227.GA10038@linux.vnet.ibm.com>
Date: Sat, 18 Jan 2014 16:57:05 -0800
X-Google-Sender-Auth: 2RO_x2DA0XkfXkzQrkMltZHOKPU
Message-ID: <CA+55aFww9F7DA2V611OjkDyf8nfBVFZkLCu1M243mcj7DKqekA@mail.gmail.com>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Matt Turner <mattst88@gmail.com>,
        Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Daniel J Blueman <daniel@numascale.com>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 1:22 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Yes, this requires that -all- updates to the fields in the machine word
> in question use atomic rmw.  Which would not be pretty from a core-code
> perspective.  Hence my suggestion of ceasing Linux-kernel support for
> DEC Alpha CPUs that don't support byte operations.  Also need 16-bit
> operations as well, of course...

I'm not seeing this.

Why the hell would you have byte- or halfword-sized versions of the
store_release or load_acquire things on alpha anyway?

What it means is that data structures that do locking or atomics need
to be "int" or "long" on alpha.  That has always been true. What do
you claim has changed?

                  Linus
