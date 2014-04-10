Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbaDJSnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:43:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54415 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaDJSnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:43:40 -0400
Date: Thu, 10 Apr 2014 19:28:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
Message-ID: <20140410172851.GF26782@laptop.programming.kicks-ass.net>
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds>
 <20140409121940.GA12890@node.dhcp.inet.fi>
 <1397108579.2586.15.camel@j-VirtualBox>
 <20140410091824.GL10526@twins.programming.kicks-ass.net>
 <1397150084.3032.4.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397150084.3032.4.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 10:14:44AM -0700, Jason Low wrote:
> So one thing I noticed that is different in the current code is that in
> debug_mutex_unlock(), there is is a possibility that it does not unlock
> the mutex (when !debug_locks). May be interesting to try out this
> patch too:

Yeah; look at a few mails down :-) I spotted it too when I woke up.
