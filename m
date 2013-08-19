Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799Ab3HSEKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:10:01 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59178 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab3HSEKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:10:00 -0400
Date: Sun, 18 Aug 2013 21:09:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Update RTFP documentation
Message-ID: <20130819040923.GG29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818012522.GA27015@linux.vnet.ibm.com>
 <1376789153-27138-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376789153-27138-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818024630.GA28923@leaf>
 <20130819002002.GQ29406@linux.vnet.ibm.com>
 <20130819003850.GA10079@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819003850.GA10079@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081904-5406-0000-0000-00000B93061E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 05:38:51PM -0700, Josh Triplett wrote:
> On Sun, Aug 18, 2013 at 05:20:02PM -0700, Paul E. McKenney wrote:
> > On Sat, Aug 17, 2013 at 07:46:30PM -0700, Josh Triplett wrote:
> > > On Sat, Aug 17, 2013 at 06:25:52PM -0700, Paul E. McKenney wrote:
> > > > +In 2012, Josh Triplett received his Ph.D. with his dissertation
> > > > +covering RCU-protected resizable hash tables and the relationship
> > > > +between memory barriers and read-side traversal order:  If the updater
> > > > +is making changes in the opposite direction from the read-side traveral
> > > > +order, the updater need only execute a memory-barrier instruction,
> > > > +but if in the same direction, the updater needs to wait for a grace
> > > > +period between the individual updates [JoshTriplettPhD].  Also in 2012,
> > > 
> > > :)
> > > 
> > > > +after seventeen years of attempts, an RCU paper made it into a top-flight
> > > > +academic journal, IEEE Transactions on Parallel and Distributed Systems
> > > > +[MathieuDesnoyers2012URCU].  A group of researchers in Spain applied
> > > 
> > > What about the 2010 paper in Operating Systems Review?
> > 
> > It is already there, but not visible in this patch:
> > 
> > 	2010 produced a simpler preemptible-RCU implementation
> > 	based on TREE_RCU [PaulEMcKenney2010SimpleOptRCU], lockdep-RCU
> > 	[PaulEMcKenney2010LockdepRCU], another resizeable RCU-protected hash
> > 	table [HerbertXu2010RCUResizeHash] (this one consuming more memory,
> > 	but allowing arbitrary changes in hash function, as required for DoS
> > 	avoidance in the networking code), realization of the 2009 RCU-protected
> > 	hash table with atomic node move [JoshTriplett2010RPHash], an update on
> > 	the RCU API [PaulEMcKenney2010RCUAPI].
> > 
> > And:
> > 
> > 	@article{JoshTriplett2010RPHash
> > 	,author="Josh Triplett and Paul E. McKenney and Jonathan Walpole"
> > 	,title="Scalable Concurrent Hash Tables via Relativistic Programming"
> > 	,journal="ACM Operating Systems Review"
> > 	,year=2010
> > 	,volume=44
> > 	,number=3
> > 	,month="July"
> > 	,annotation={
> > 	        RP fun with hash tables.
> > 		http://portal.acm.org/citation.cfm?id=1842733.1842750
> > 	}
> 
> Right, I saw it in the file when I checked; I meant, that journal paper
> seems to contradict "after seventeen years of attempts, an RCU paper
> made it into a top-flight academic journal". :)

Ah, from what I can see, OSR is on its way up, but still mid-ranks.
(Some years back, it was low-end -- unreviewed.)

> > > > +,day = {25}
> > > > +,doi = {10.1007/s11227-012-0766-x}
> > > > +,issn = {0920-8542}
> > > > +,journal = {The Journal of Supercomputing}
> > > > +,keywords = {linux, simulation}
> > > > +,month = apr
> > > > +,posted-at = {2012-05-03 09:12:04}
> > > > +,priority = {2}
> > > > +,title = {{A Read-Copy Update based parallel server for distributed crowd simulations}}
> > > > +,url = {http://dx.doi.org/10.1007/s11227-012-0766-x}
> > > > +,year = {2012}
> > > > +}
> > > > +
> > > > +
> > > > +@unpublished{JonCorbet2012ACCESS:ONCE
> > > 
> > > LWN is not "unpublished"; it's at least "misc", and I'd suggest
> > > "article".  Ditto for every other LWN cite in this bibliography.
> > 
> > There does seem to be a diverse set of advice out there, with some
> > agreeing with you on "misc", others advocating for "electronic", and
> > still others suggesting use of LaBibTex with its "online" tag, and with
> > the Tex Frequently Asked Questions page saying:
> > 
> > 	There is no citation type for URLs, per se, in the standard
> > 	BibTeX styles, though Oren Patashnik (the author of BibTeX)
> > 	is believed to be considering developing one such for use with
> > 	the long-awaited BibTeX version 1.0.
> > 
> > I couldn't find any online .bib files with entries for Linux Weekly News
> > articles.  Other than my own, of course!  (I know people have cited
> > them in papers, but Google doesn't see the corresponding .bib files.)
> > 
> > Given all that, I am going to stick with "unpublished" for the moment,
> > and wait at least one year to see if BibTex version 1.0 comes out.
> 
> Several different tags make sense, but "unpublished" isn't one of them.
> "unpublished" exists for entirely un-reviewed works such as self-hosted
> PDFs.  LWN has editorial standards.  Thus, of the standard tags that
> work with all BibTeX styles, I think either "article" or "misc" would
> make more sense than "unpublished".
> 
> An example from one of my own .bib files:
> 
> @article{tiny-rcu-lwn,
> author = "Paul E. McKenney",
> title = {{RCU: The Bloatwatch Edition}},
> journal = "Linux Weekly News",
> month = "March",
> year = "2009",
> day = "17",
> url = {https://lwn.net/Articles/323929/}
> }
> 
> (With the obvious change that since you don't use "url" in your .bib
> files, that should go in "howpublished" or "note" instead.)

I might do this at some point, but don't want to do it twice.  If Patashnik
hasn't released a new BibTeX by this time next year, I will probably go
with "misc".

I do agree that LWN deserves more respect, but on the other hand, RTFP.txt
has been using "unpublished" since January 2008, so I am willing to hold
off another year.  ;-)

							Thanx, Paul

