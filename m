Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaEMTGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:06:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40943 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaEMTFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:05:51 -0400
Date: Tue, 13 May 2014 12:05:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 20/45] torture: Include "Stopping" string to
 torture_kthread_stopping()
Message-ID: <20140513190543.GP18164@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-20-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507213736.GL27924@cloud>
 <20140510001346.GC8754@linux.vnet.ibm.com>
 <20140510001657.GB7553@thin>
 <20140510004259.GG8754@linux.vnet.ibm.com>
 <20140510034616.GB8451@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510034616.GB8451@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051319-6688-0000-0000-000001C95DF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 08:46:16PM -0700, Josh Triplett wrote:
> On Fri, May 09, 2014 at 05:42:59PM -0700, Paul E. McKenney wrote:
> > On Fri, May 09, 2014 at 05:16:57PM -0700, Josh Triplett wrote:
> > > On Fri, May 09, 2014 at 05:13:46PM -0700, Paul E. McKenney wrote:
> > > > On Wed, May 07, 2014 at 02:37:36PM -0700, josh@joshtriplett.org wrote:
> > > > > On Mon, Apr 28, 2014 at 05:25:08PM -0700, Paul E. McKenney wrote:
> > > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > > 
> > > > > > Currently, torture_kthread_stopping() prints only the name of the
> > > > > > kthread that is stopping, which can be unedifying.  This commit therefore
> > > > > > adds "Stopping" to make things more evident.
> > > > > > 
> > > > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > Feedback below.
> > > > > 
> > > > > >  kernel/torture.c | 5 ++++-
> > > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/kernel/torture.c b/kernel/torture.c
> > > > > > index acc9afc2f26e..f329848c3eee 100644
> > > > > > --- a/kernel/torture.c
> > > > > > +++ b/kernel/torture.c
> > > > > > @@ -674,8 +674,11 @@ EXPORT_SYMBOL_GPL(torture_must_stop_irq);
> > > > > >   */
> > > > > >  void torture_kthread_stopping(char *title)
> > > > > >  {
> > > > > > +	char buf[128];
> > > > > > +
> > > > > > +	snprintf(buf, sizeof(buf), "Stopping %s", title);
> > > > > >  	if (verbose)
> > > > > > -		VERBOSE_TOROUT_STRING(title);
> > > > > > +		VERBOSE_TOROUT_STRING(buf);
> > > > > 
> > > > > This seems like a case where the macro has led to poorer code; rather
> > > > > than using sprintf into a temporary buffer, this should just print.
> > > > > Please consider fixing the output macros to allow formats, as the pr_*
> > > > > macros do.
> > > > > 
> > > > > Also, why do you need "if (verbose)" if the name of the macro has
> > > > > VERBOSE_ in it; shouldn't that mean it checks verbosity itself?
> > > > > (Another good reason not to create a unique verbosity level mechanism,
> > > > > and to use the kernel mechanisms instead.)
> > > > 
> > > > Good catch, removed the redundant "if (verbose)".
> > > > 
> > > > My attempts in the past to leverage existing in-kernel verbosity controls
> > > > has caused problems such as the output appearing or not depending on
> > > > the distro in question.
> > > 
> > > That aside, though, what do you think about making the macros accept
> > > format strings and arguments, in the style of pr_* and pr_fmt?
> > 
> > If I end up needing this in a few more cases, then it would indeed be
> > worth it.
> 
> I'd argue that it's worth it already: doing snprintf into a temporary
> buffer seems ridiculous here, when without these macros you'd just call
> pr_foo("Stopping %s\n", title);

Sold, I will make this change for 3.17.  Or if you would like to send along
a patch, that would be quite welcome as well.  ;-)

							Thanx, Paul

