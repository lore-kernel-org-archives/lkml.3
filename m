Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936652Ab3DJK3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:29:53 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:54679 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3DJK3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:29:52 -0400
Date: Wed, 10 Apr 2013 12:29:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
Message-ID: <20130410102948.GB28505@gmail.com>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Another thing I just noticed; our update_curr() assumes its called at least once 
> every 4 odd seconds (2^32 ns like).
> 
> update_curr() is 'required' for things like task runtime stats and everything 
> that hangs off of that like cputimers etc.
> 
> Now I'm not entirely sure how the nr_running==1 nohz case deals with this, but I 
> can imagine it might take a while. In this case we might need to 'fix' 
> update_curr() to not asume the time delta fits in 32 bits.

Good point ...

Thanks,

	Ingo
