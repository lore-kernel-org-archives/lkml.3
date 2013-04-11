Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935969Ab3DKPLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:11:20 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:49491 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3DKPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:11:19 -0400
Date: Thu, 11 Apr 2013 17:11:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC GIT PULL] nohz: Full dynticks rq clock handling
Message-ID: <20130411151109.GC15699@somewhere>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
 <1365589603.30071.37.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365589603.30071.37.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:26:43PM +0200, Peter Zijlstra wrote:
> 
> Another thing I just noticed; our update_curr() assumes its called at
> least once every 4 odd seconds (2^32 ns like).
> 
> update_curr() is 'required' for things like task runtime stats and
> everything that hangs off of that like cputimers etc.
> 
> Now I'm not entirely sure how the nr_running==1 nohz case deals with
> this, but I can imagine it might take a while. In this case we might
> need to 'fix' update_curr() to not asume the time delta fits in 32
> bits.
> 

Good catch, this is not handled yet.
