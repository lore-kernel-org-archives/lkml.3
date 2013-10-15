Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3JOBlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 21:41:46 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6454 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab3JOBlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 21:41:45 -0400
X-Spam-Score: -100.8
Message-ID: <525C9D18.6040909@asianux.com>
Date: Tue, 15 Oct 2013 09:40:40 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel/rcutorture.c: about using scnprintf() instead
 of sprintf().
References: <5253C335.5050609@asianux.com> <20131013110518.GC5790@linux.vnet.ibm.com> <525B4BB0.1090609@asianux.com> <525B555C.3040102@asianux.com> <20131014112457.GN5790@linux.vnet.ibm.com>
In-Reply-To: <20131014112457.GN5790@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 07:24 PM, Paul E. McKenney wrote:
> On Mon, Oct 14, 2013 at 10:22:20AM +0800, Chen Gang wrote:
>>>  - intend to shrink maximized buffer (PAGE_SIZE -> 64, 256 ..) for test.
> 
> This is a good start!  However, you should also test the original kernel
> to be sure that it really fails.  You should of course start by asking
> yourself how you would expect it to fail.
> 

When shrink size, for scnprintf() we already got truncation, that means
if we still use sprintf(), it will cause memory overflow.

For memory overflow, it does not means OS will stop quickly, one of the
worst condition is "it may still seems going 'well' but sometimes
may/will show some amazing things which is not easy to find root cause".

So for this kind of memory overflow, "shrinking size and letting
scnprintf() instead of sprintf() to see whether truncation" is well enough.


> What other change should you make to test this in order to be sure that
> it will really work when someone tries it on 1024 CPUs?  (I am asking
> rather than telling because you really need to have this stuff worked
> out on your initial submission.)
> 

Hmm... Can it really work on 1024 CPUs? sorry I don't know. But in fact,
that is not about this patch (it is just one of case which may cause
issues).

This patch is only about "use truncation instead of memory overflow, and
make sure the modification without negative effect". So in my opinion,
current test case is enough for this requirement.

Maybe you want to let this module get additional test to find additional
issues? (If so, I will try when my time resource is possible).


> Another way of thinking about this is to ask yourself the question "If
> someone ran rcutorture with torture_type=srcu on a system with 1024 CPUs
> (to say nothing of 4096 CPUs), what would they want to happen?"  Then:
> "How would I test for that on a smaller system?"
> 

We have to face the efficiency: it is only a test module, if the tester
(assume he/she is a programmer, too) notices about the truncation, they
can simply extend the maximize length to avoid truncation.

At least for me, "rcutorture.c" is really easy enough for a programmer
to test rcu (and also, it is really a useful tool for test rcu).

And for "1024 CPUs",  I think one of efficient way is: "when some
members use it under 1024 CPUs, if they find something can be
improvement, they can report/send related patch".


Hmm... maybe the comment "it is ... additional test or consideration"
need be removed: 'additional' and 'consideration' are not suitable words
to be appeared in comments (they are not precise word).


Thanks.
-- 
Chen Gang
