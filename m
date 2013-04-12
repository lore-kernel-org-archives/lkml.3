Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3DLIFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:05:18 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37141
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab3DLIFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:05:11 -0400
Message-ID: <1365753904.17140.22.camel@laptop>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>
Date: Fri, 12 Apr 2013 10:05:04 +0200
In-Reply-To: <20130411191355.GO29861@linux.vnet.ibm.com>
References: <20130411160524.GA30384@linux.vnet.ibm.com>
	 <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20130411182502.GA31684@pd.tnic>
	 <20130411191355.GO29861@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 12:13 -0700, Paul E. McKenney wrote:
> > > +2. Many architectures will place dyntick-idle CPUs into deep sleep
> > > +   states, which further degrades from-idle transition latencies.
> > 
> > Above you say "to and from the idle loop", now it is from-idle. Simply say:
> > 
> > "... which further degrades idle transision latencies" which means both :).
> 
> If people speak for this item, I will update it.  Arjan suggested removing
> it entirely.

So I haven't yet read the entire document, but:

+2.     Many architectures will place dyntick-idle CPUs into deep sleep
+       states, which further degrades from-idle transition latencies.
+
+Therefore, systems with aggressive real-time response constraints
+often run CONFIG_NO_HZ=n kernels in order to avoid degrading from-idle
+transition latencies.

I'm not sure that's the reason.. We can (and do) limit C states to curb
the idle-exit times. The reason we often turn off NOHZ all together is
to further reduce the cost of the idle paths.

All the mucking about with clock states and such is a rather expensive
thing
to do all the time.



