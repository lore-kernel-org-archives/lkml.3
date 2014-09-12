Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaILSFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:05:54 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:32822 "EHLO
	homiemail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbaILSDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:03:45 -0400
Message-ID: <1410544947.12906.6.camel@linux-t7sj.site>
Subject: Re: [PATCH 7/9] locktorture: Add infrastructure for torturing read
 locks
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 11:02:27 -0700
In-Reply-To: <20140912160643.GB4775@linux.vnet.ibm.com>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
	 <1410496841.2166.10.camel@linux-t7sj.site>
	 <20140912160643.GB4775@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 09:06 -0700, Paul E. McKenney wrote:
> On Thu, Sep 11, 2014 at 09:40:41PM -0700, Davidlohr Bueso wrote:
> > In addition, introduce a new nreaders_stress module parameter. The
> > default number of readers will be the same number of writers threads.
> > Writer threads are interleaved with readers. Documentation is updated,
> > respectively.
> 
> Nice!!!
> 
> Conditional fairness checks in the future?  (As in verifying that if
> the rwlock in question claims some degree of fairness, trying to break
> that guarantee, and contrariwise, if the lock is unfair, making sure
> to avoid starvation during the test?)

Yep, there are all sorts of interesting things we can measure in rw
runs. In this set I'm only trying to establish a minimum infrastructure.
Future work will be pretty trivial (at least code wise) to implement
once this sort of thing is in. 

> And one nit below.
[...]
> C initialization does this already, no need to add the NULL initializers.

Sure, I always tend to be explicit when initializing. I guess you won't
like the context initialization in patch 9/9.

Thanks,
Davidlohr

