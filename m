Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3GAQTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:19:13 -0400
Received: from one.firstfloor.org ([193.170.194.197]:56297 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3GAQTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:19:12 -0400
Date: Mon, 1 Jul 2013 18:19:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/7] v2 Provide infrastructure for
 full-system idle
Message-ID: <20130701161910.GN6123@two.firstfloor.org>
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <87a9m65mv6.fsf@tassilo.jf.intel.com>
 <20130701160314.GM3773@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701160314.GM3773@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am guessing that you want CONFIG_NO_HZ_FULL to implicitly enable
> the sysidle code so that CONFIG_NO_HZ_FULL_SYSIDLE can be eliminated.
> I will be happy to take that step, but only after I gain full confidence
> in the correctness and performance of the sysidle code.

FWIW if you want useful testing you need to enable it by default
(as part of NO_IDLE_HZ) anyways. Users will most likely pick
whatever is "default" in Kconfig.

> > If you want a switch for testing I would advise a sysctl or sysfs knob
> 
> This would work well for the correctness part, but not for the performance
> part.

What performance part? 

Are you saying this adds so many checks to hot paths that normal runtime
if() with a flag is too expensive?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
