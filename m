Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbaFLIy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:54:28 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:33176 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbaFLIy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:54:26 -0400
Message-ID: <1402563262.5171.2.camel@marge.simpson.net>
Subject: Re: console: lockup on boot
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Peter Hurley <peter@hurleysoftware.com>, pmladek@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 12 Jun 2014 10:54:22 +0200
In-Reply-To: <20140612082645.GF9511@quack.suse.cz>
References: <5388838B.8070802@oracle.com>
	 <53888E76.5040101@hurleysoftware.com> <20140530140757.GC2419@quack.suse.cz>
	 <53921116.5050804@oracle.com> <53972B5C.5020605@hurleysoftware.com>
	 <53986DFB.9030006@oracle.com> <20140611203436.GD9511@quack.suse.cz>
	 <20140611213111.GE9511@quack.suse.cz> <53991958.4070106@oracle.com>
	 <20140612082645.GF9511@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 10:26 +0200, Jan Kara wrote: 
> On Wed 11-06-14 23:07:04, Sasha Levin wrote:

> > The first patch fixed it (I assumed that there's no need to try the second).
>   Good. So that shows that it is the increased lockdep coverage which is
> causing problems - with my patch, lockdep is able to identify some problem
> because console drivers are now called with lockdep enabled. But because
> the problem was found in some difficult context, lockdep just hung the
> machine when trying to report it... Sadly the stacktraces you posted don't
> tell us what lockdep found.
> 
> Adding Peter Zijlstra to CC. Peter, any idea how lockdep could report
> problems when holding logbuf_lock? One possibility would be to extend
> logbuf_cpu recursion logic to every holder of logbuf_lock. That will at
> least avoid the spinlock recursion killing the machine but we won't be able
> to see what lockdep found...

Could tell lockdep to use trace_printk().

