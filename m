Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaDGS5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:57:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53380 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaDGS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:57:11 -0400
Date: Mon, 7 Apr 2014 20:56:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Michele Ballabio <barra_cuda@katamail.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
Message-ID: <20140407185658.GK11096@twins.programming.kicks-ass.net>
References: <5341707F.5000406@katamail.com>
 <20140407150337.GO10526@twins.programming.kicks-ass.net>
 <20140407150705.GB13658@twins.programming.kicks-ass.net>
 <5342EB78.3060002@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5342EB78.3060002@gmx.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 08:16:24PM +0200, Toralf Förster wrote:

> v3.14-10353-g2b3a8fd works fine AFAICS
> (BTW the fix is stable material, right ?)

I'm fairly sure its not; its a rather invasive series; see:

2432e1364bbe x86: Nuke the supervisor_stack field in i386 thread_info
b807902a88c4 x86: Nuke GET_THREAD_INFO_WITH_ESP() macro for i386
0788aa6a23cb x86: Prepare removal of previous_esp from i386 thread_info structure
198d208df437 x86: Keep thread_info on thread stack in x86_32

Let me see if there's anything 'simpler' we can stuff in .13+
