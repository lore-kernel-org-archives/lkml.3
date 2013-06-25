Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3FYHiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:38:02 -0400
Received: from gate.crashing.org ([63.228.1.57]:46529 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3FYHiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:38:00 -0400
Message-ID: <1372145785.3944.195.camel@pasglop>
Subject: Re: Regression in RCU subsystem in latest mainline kernel
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Rojhalat Ibrahim <imr@rtschenk.de>, linux-kernel@vger.kernel.org
Date: Tue, 25 Jun 2013 17:36:25 +1000
In-Reply-To: <20130625071914.GA29957@concordia>
References: <1626500.7WAVXjfS9F@pcimr>
	 <20130614122800.GL5146@linux.vnet.ibm.com> <1645938.As0LR1yeVd@pcimr>
	 <1371243967.9844.338.camel@gandalf.local.home>
	 <1371261741.21896.20.camel@pasglop> <20130617074213.GA3589@concordia>
	 <20130619040906.GA5146@linux.vnet.ibm.com>
	 <20130625071914.GA29957@concordia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 17:19 +1000, Michael Ellerman wrote:
> Here's another trace from 3.10-rc7 plus a few local patches.
> 
> We suspect that the perf enable could be causing a flood of
> interrupts, but why
> that's clogging things up so badly who knows.

Additionally, perf being potentially NMIs , we might be hitting a bad
case of reentrance in RCU ... hard to tell.

Cheers,
Ben.


