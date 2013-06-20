Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935682Ab3FTDXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:23:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935522Ab3FTDXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:23:30 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=49Xwnclk0kMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=aGTHLlSVUUYA:10 a=VwQbUJbxAAAA:8 a=U0FBzmo6wkCSSZAaCg0A:9 a=CjuIK1q_8ugA:10 a=LI9Vle30uBYA:10 a=-tA_eoRxER7jEvAP:21 a=lE4qiLz5Zc-u4H7M:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Wed, 19 Jun 2013 23:23:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: A question on RCU vs. preempt-RCU
Message-ID: <20130620032328.GC28618@home.goodmis.org>
References: <20130616023611.GA19863@htj.dyndns.org>
 <8761xer1s8.fsf@rustcorp.com.au>
 <20130617182023.GH32663@mtj.dyndns.org>
 <87obb4ngdy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obb4ngdy.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 02:51:13PM +0930, Rusty Russell wrote:
> Tejun Heo <tj@kernel.org> writes:
> > Buth yeah, interesting trick.  We'll be doing IPIs, flushing TLB and
> > taking faults until it hits zero.  It'll all depend on the frequency
> > of preemption but given that branches don't tend to be too expensive
> > on modern processors, maybe it'd be a bit too hairy for possibly
> > marginal gain?
> 
> Yeah, I'm not convinced either, but I am hoping some enthusiast will run
> with the idea in hope of Fame and Glory :)

This actually looks like a trick I think would be fun to implement. But
as it being beneficial... the preempt count is used quite often, the
fact that this page will be constantly in the TLB would have a bigger
impact on general performance than saving the lousy branch.

-- Steve

