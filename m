Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaH1UBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:01:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35024 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaH1UBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:01:34 -0400
Date: Thu, 28 Aug 2014 13:01:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Ganesh Rapolu <ganesh.rapolu@hotmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] DOCUMENTATION: Fixed typo in an example in
 memory-barriers.txt
Message-ID: <20140828200129.GG5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <BLU436-SMTP214DCCF4135E3E81A493210E2D10@phx.gbl>
 <53F8D6DD.90306@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F8D6DD.90306@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082820-1542-0000-0000-000004602F49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 11:01:01AM -0700, Randy Dunlap wrote:
> On 08/22/14 23:05, Ganesh Rapolu wrote:
> > In the first example in the memory-barriers.txt file, CPU 2 is assigned to
> > run (x = B; y = A;). However, the rest of the example proceeds as if CPU 2 had been
> > running (x = A; y = B;) as shown by the descriptions of the possible executions:
> > 
> > 	STORE A=3,	STORE B=4,	x=LOAD A->3,	y=LOAD B->4
> > 	STORE A=3,	STORE B=4,	y=LOAD B->4,	x=LOAD A->3
> > 	STORE A=3,	x=LOAD A->3,	STORE B=4,	y=LOAD B->4
> > 	STORE A=3,	x=LOAD A->3,	y=LOAD B->2,	STORE B=4
> > 	STORE A=3,	y=LOAD B->2,	STORE B=4,	x=LOAD A->3
> > 	STORE A=3,	y=LOAD B->2,	x=LOAD A->3,	STORE B=4
> > 	STORE B=4,	STORE A=3,	x=LOAD A->3,	y=LOAD B->4
> > 	STORE B=4, ...
> > 	...
> > 
> > The change was merely to make the inital evironment consistent with what happens in the
> > rest of the example.
> > 
> > Signed-off-by: Ganesh Rapolu <ganesh.rapolu@hotmail.com>
> 
> 
> Comments David, Alexey, Andrew, Paul?
> 
> This would revert Alexey's patch 615cc2c9cf9529846fbc342560d6787c2ccaaeea:
> "Documentation/memory-barriers.txt: fix important typo re memory barriers"
> that was merged on June 6, 2014.
> 
> Thanks.
> 
> 
> > ---
> >  Documentation/memory-barriers.txt | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> > index a4de88f..9a46bbe 100644
> > --- a/Documentation/memory-barriers.txt
> > +++ b/Documentation/memory-barriers.txt
> > @@ -115,8 +115,8 @@ For example, consider the following sequence of events:
> >  	CPU 1		CPU 2
> >  	===============	===============
> >  	{ A == 1; B == 2 }
> > -	A = 3;		x = B;
> > -	B = 4;		y = A;
> > +	A = 3;		x = A;
> > +	B = 4;		y = B;

Alexey's patch was correct as far as it went, but it was incomplete.
(Read his commit log for more information.)

Would either of you like to send a patch fixing up the combinations?

							Thanx, Paul

> >  The set of accesses as seen by the memory system in the middle can be arranged
> >  in 24 different combinations:
> > 
> 
> 
> -- 
> ~Randy
> 

