Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3AZNKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 08:10:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49906 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3AZNKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 08:10:21 -0500
Message-ID: <1359205815.22942.14.camel@marge.simpson.net>
Subject: Re: [PATCH -v4 0/5] x86,smp: make ticket spinlock proportional
 backoff w/ auto tuning
From: Mike Galbraith <bitbucket@online.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, knoel@redhat.com, chegu_vinod@hp.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Date: Sat, 26 Jan 2013 14:10:15 +0100
In-Reply-To: <20130126120509.GD13445@gmail.com>
References: <20130125140553.060b8ced@annuminas.surriel.com>
	 <1359184867.5835.85.camel@marge.simpson.net>
	 <20130126120509.GD13445@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:GKNw3cssn9NTgTBlSljADjrgv9J+b+swKb56l7rovFH
 ie0E+eIL7suTogpJ1x+BKKloEtPtJmX/NR8lZqQ3guq+zQ4i+P
 7NrImCSZ730SMJd0hZfHnbGWYozQT+bi2QyfdabEhK54v6/mWz
 2+lYN6xPq6Qb8QxzFbGIgaXJ2//846Pf3T6JT3J5ZDl0LrKKWA
 5L6n0F8Eas8Ats5yTS/Zgw2hpNPREAY9WBgOpzDk3/sss2uMyp
 zIlXJsGg6JmMoq9+fbUL79dEQioZgSgByLMYft4sp6oYzGiXOu
 +Fj2gqq1pQZxR/gJuDDXXyJPj/wnu2xU6m/dM0KzCtp71aTkRF
 OmZ3fFM+s5Uxfwb0Urrsx7L04Gwl1/3kEp9DzVQJe61CbSMP5t
 lImQqytYdxHnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-26 at 13:05 +0100, Ingo Molnar wrote: 
> * Mike Galbraith <bitbucket@online.de> wrote:
> 
> > On Fri, 2013-01-25 at 14:05 -0500, Rik van Riel wrote:
> > 
> > > The performance issue observed with AIM7 is still a mystery.
> > 
> > Hm.  AIM7 mystery _may_ be the same crud I see on a 4 node 40 
> > core box. Stock scheduler knobs are too preempt happy, produce 
> > unstable results. I twiddle them as below to stabilize 
> > results.
> > 
> > I'm testing a load balancing series from Alex Shi with AIM7 
> > and whatnot, added your series on top of it and retested.  
> > What I see is improvement.
> 
> Since we want both series that's good news, agreed?

Yes, both look good.

BTW, the balance and powersaving low end improvements in the Alex set
are not due to any select_idle_sibling() misbehavior as one might
suspect when looking at the set, it's innocent (this time), it's the
balancing policies themselves.  I don't see where it comes from, gotta
be some turbo thingy methinks, but who cares, better is better.

-Mike

