Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875Ab3DKVBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:01:13 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55737 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934232Ab3DKVBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:01:10 -0400
Date: Thu, 11 Apr 2013 14:00:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 2/2] kthread: Document ways of reducing OS
 jitter due to per-CPU kthreads
Message-ID: <20130411210056.GS29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130411160524.GA30384@linux.vnet.ibm.com>
 <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365696359-30958-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <5166F062.2090007@infradead.org>
 <20130411184053.GN29861@linux.vnet.ibm.com>
 <51671878.9050800@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51671878.9050800@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041121-3620-0000-0000-000001FF787E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 01:09:28PM -0700, Randy Dunlap wrote:
> On 04/11/13 11:40, Paul E. McKenney wrote:
> > On Thu, Apr 11, 2013 at 10:18:26AM -0700, Randy Dunlap wrote:
> >> On 04/11/2013 09:05 AM, Paul E. McKenney wrote:
> >>> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >>>
> >>> The Linux kernel uses a number of per-CPU kthreads, any of which might
> >>> contribute to OS jitter at any time.  The usual approach to normal
> >>> kthreads, namely to affinity them to a "housekeeping" CPU, does not
> >>
> >> ugh.               to affine them
> > 
> > How about s/affinity/bind/ instead?
> 
> Yes, that's good.
> 
> >>> work with these kthreads because they cannot operate correctly if moved
> >>> to some other CPU.  This commit therefore lists ways of controlling OS
> >>> jitter from the Linux kernel's per-CPU kthreads.
> >>>
> >>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> >>> Cc: Steven Rostedt <rostedt@goodmis.org>
> >>> Cc: Borislav Petkov <bp@alien8.de>
> >>> Cc: Arjan van de Ven <arjan@linux.intel.com>
> >>> Cc: Kevin Hilman <khilman@linaro.org>
> >>> Cc: Christoph Lameter <cl@linux.com>
> >>> ---
> >>>  Documentation/kernel-per-CPU-kthreads.txt | 159 ++++++++++++++++++++++++++++++
> >>>  1 file changed, 159 insertions(+)
> >>>  create mode 100644 Documentation/kernel-per-CPU-kthreads.txt
> >>>
> >>> diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
> >>> new file mode 100644
> >>> index 0000000..495dacf
> >>> --- /dev/null
> >>> +++ b/Documentation/kernel-per-CPU-kthreads.txt
> >>> @@ -0,0 +1,159 @@
> >>> +REDUCING OS JITTER DUE TO PER-CPU KTHREADS
> >>> +
> >>> +
> >>> +Name: irq/%d-%s
> >>> +Purpose: Handle threaded interrupts.
> >>> +To reduce corresponding OS jitter, do the following:
> >>> +1.	Use irq affinity to force the irq threads to execute on
> >>> +	some other CPU.
> >>
> >> It would be very nice to explain here how that is done.
> > 
> > Documentation/IRQ-affinity.txt
> > 
> > I added a pointer to this near the beginning.
> > 
> 
> Good.
> 
> > Thank you for your review and comments!  Given my rationale above,
> > are you still comfortable with my applying your Reviewed-by?
> 
> Sure.  Thanks.
> 
> >> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

I have added your Reviewed-by, thank you again!

							Thanx, Paul

