Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3HSAUO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 20:20:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43740 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab3HSAUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 20:20:12 -0400
Date: Sun, 18 Aug 2013 17:20:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Update RTFP documentation
Message-ID: <20130819002002.GQ29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818012522.GA27015@linux.vnet.ibm.com>
 <1376789153-27138-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376789153-27138-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818024630.GA28923@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818024630.GA28923@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081900-5806-0000-0000-00002276B0C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 07:46:30PM -0700, Josh Triplett wrote:
> On Sat, Aug 17, 2013 at 06:25:52PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Could you mention the BibTeX formatting changes (and the rationale for
> them) in the commit message, please?

Good point, done.  Short version: For compatibility with my .bib files,
some of which predate bibtex's ability to handle trailing commas.

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> A couple of comments below (and above); with those fixed,
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I took all but the conversion of the LWN article entry tags, please
see below.

							Thanx, Paul

> > ---
> >  Documentation/RCU/RTFP.txt | 855 +++++++++++++++++++++++++++++----------------
> >  1 file changed, 550 insertions(+), 305 deletions(-)
> > 
> > diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
> > index 7f40c72..350be9a 100644
> > --- a/Documentation/RCU/RTFP.txt
> > +++ b/Documentation/RCU/RTFP.txt
> > @@ -39,7 +39,7 @@ in read-mostly situations.  This algorithm does take pains to avoid
> >  write-side contention and parallelize the other write-side overheads by
> >  providing a fine-grained locking design, however, it would be interesting
> >  to see how much of the performance advantage reported in 1990 remains
> > -in 2004.
> > +in 2004 (to say nothing of 2013).
> 
> In lieu of updating this again in 9 years, s/2004.*/today./ please?

Fair point, fixed.

> > +In 2012, Josh Triplett received his Ph.D. with his dissertation
> > +covering RCU-protected resizable hash tables and the relationship
> > +between memory barriers and read-side traversal order:  If the updater
> > +is making changes in the opposite direction from the read-side traveral
> > +order, the updater need only execute a memory-barrier instruction,
> > +but if in the same direction, the updater needs to wait for a grace
> > +period between the individual updates [JoshTriplettPhD].  Also in 2012,
> 
> :)
> 
> > +after seventeen years of attempts, an RCU paper made it into a top-flight
> > +academic journal, IEEE Transactions on Parallel and Distributed Systems
> > +[MathieuDesnoyers2012URCU].  A group of researchers in Spain applied
> 
> What about the 2010 paper in Operating Systems Review?

It is already there, but not visible in this patch:

	2010 produced a simpler preemptible-RCU implementation
	based on TREE_RCU [PaulEMcKenney2010SimpleOptRCU], lockdep-RCU
	[PaulEMcKenney2010LockdepRCU], another resizeable RCU-protected hash
	table [HerbertXu2010RCUResizeHash] (this one consuming more memory,
	but allowing arbitrary changes in hash function, as required for DoS
	avoidance in the networking code), realization of the 2009 RCU-protected
	hash table with atomic node move [JoshTriplett2010RPHash], an update on
	the RCU API [PaulEMcKenney2010RCUAPI].

And:

	@article{JoshTriplett2010RPHash
	,author="Josh Triplett and Paul E. McKenney and Jonathan Walpole"
	,title="Scalable Concurrent Hash Tables via Relativistic Programming"
	,journal="ACM Operating Systems Review"
	,year=2010
	,volume=44
	,number=3
	,month="July"
	,annotation={
	        RP fun with hash tables.
		http://portal.acm.org/citation.cfm?id=1842733.1842750
	}

> > +user-level RCU to crowd simulation [GuillermoVigueras2012RCUCrowd], and
> > +another group of researchers in Europe produced a formal description of
> > +RCU based on separation logic [AlexeyGotsman2012VerifyGraceExtended],
> 
> Oh, interesting, I hadn't seen that one yet.

I am hoping that it will lead to better tools to analyze both RCU
implementations and RCU uses.  ;-)

> > +@phdthesis{JoshTriplettPhD
> > +,author="Josh Triplett"
> > +,title="Relativistic Causal Ordering A Memory Model for Scalable Concurrent Data Structures"
> 
> "A Memory Model ..." is a subtitle, so there should be either a : or a
> --- after "Ordering".

Got it, fixed both in RTFP.txt and in my bibtex database.

> > +,school="Portland State University"
> > +,year="2012"
> > +,annotation={
> > +	RCU-protected hash tables, barriers vs. read-side traversal order.
> > +}
> 
> Consider duplicating the summary above about traversal order versus
> update order, and memory barriers versus grace periods, into the
> annotation.

Done!

> > +@article{GuillermoVigueras2012RCUCrowd
> > +,author = {Vigueras, Guillermo and Ordu\~{n}a, Juan M. and Lozano, Miguel}
> > +,citeulike-article-id = {10632151}
> > +,citeulike-linkout-0 = {http://dx.doi.org/10.1007/s11227-012-0766-x}
> > +,citeulike-linkout-1 = {http://www.springerlink.com/content/25762r0874163570}
> 
> Consider dropping these non-standard BibTeX tags; nothing will ever
> format them, and you already have the doi below.

Done.

> > +,day = {25}
> > +,doi = {10.1007/s11227-012-0766-x}
> > +,issn = {0920-8542}
> > +,journal = {The Journal of Supercomputing}
> > +,keywords = {linux, simulation}
> > +,month = apr
> > +,posted-at = {2012-05-03 09:12:04}
> > +,priority = {2}
> > +,title = {{A Read-Copy Update based parallel server for distributed crowd simulations}}
> > +,url = {http://dx.doi.org/10.1007/s11227-012-0766-x}
> > +,year = {2012}
> > +}
> > +
> > +
> > +@unpublished{JonCorbet2012ACCESS:ONCE
> 
> LWN is not "unpublished"; it's at least "misc", and I'd suggest
> "article".  Ditto for every other LWN cite in this bibliography.

There does seem to be a diverse set of advice out there, with some
agreeing with you on "misc", others advocating for "electronic", and
still others suggesting use of LaBibTex with its "online" tag, and with
the Tex Frequently Asked Questions page saying:

	There is no citation type for URLs, per se, in the standard
	BibTeX styles, though Oren Patashnik (the author of BibTeX)
	is believed to be considering developing one such for use with
	the long-awaited BibTeX version 1.0.

I couldn't find any online .bib files with entries for Linux Weekly News
articles.  Other than my own, of course!  (I know people have cited
them in papers, but Google doesn't see the corresponding .bib files.)

Given all that, I am going to stick with "unpublished" for the moment,
and wait at least one year to see if BibTex version 1.0 comes out.

Seem reasonable?

> > +,Author="Jon Corbet"
> > +,Title="{ACCESS\_ONCE()}"
> > +,month="August"
> > +,day="1"
> > +,year="2012"
> > +,note="\url{http://lwn.net/Articles/508991/}"
> > +,annotation={
> > +	A couple of simple specific compiler optimizations that motivate
> > +	ACCESS_ONCE().
> > +}
> > +}
> 
> - Josh Triplett
> 

