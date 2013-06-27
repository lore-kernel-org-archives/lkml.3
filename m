Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3F0M2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:28:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3F0M2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:28:30 -0400
Message-ID: <1372336081.5871.168.camel@marge.simpson.net>
Subject: Re: deadlock in scheduler enabling HRTICK feature
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Date: Thu, 27 Jun 2013 14:28:01 +0200
In-Reply-To: <20130627105303.GD27378@dyad.programming.kicks-ass.net>
References: <51CA0622.8010105@gmail.com>
	 <20130625211713.GA18796@laptop.programming.kicks-ass.net>
	 <51CA0980.8010409@gmail.com>
	 <20130626070533.GA3601@dyad.programming.kicks-ass.net>
	 <51CB1AE9.5090709@gmail.com>
	 <20130627104309.GQ28407@twins.programming.kicks-ass.net>
	 <20130627105303.GD27378@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:/+wJpMFhpTDBQiTMH353HefAmH6G2cYMghjcXXzzVUD
 ZjX/yPxC5iOvF1rs5W3axhI+R6KwuXClZlf8xi5/N0zNzWnCZt
 UR1DLiyEQzAiypipY57fcxWL7N9ynrg8BUzPSrjQLPuXyVlJy1
 hXW1fncDyzkM8JKpRh2mfE7KRA/yVM2TKwm8Kr70sEkbNg7lBz
 qTOVG3GVnO5vM0M/YIGAvtEDMsclP1EGOWzNCfn3F4HHnHjLPU
 znloNWyaodUhQiI4dddUht8EIPp51nXVQ1YKs0Nvq8cY9UqkDd
 oUdESoC3pgCOKNude9oR4VfEkcwrUwkYU6mvMpKw5j1yfSw7GL
 9NN9QdmJ4fqU0PVAxP34HE5xCecWTzjJDUDjb0ZnFdYuVB1TnS
 7fuHoQRGb4mKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 12:53 +0200, Peter Zijlstra wrote: 
> On Thu, Jun 27, 2013 at 12:43:09PM +0200, Peter Zijlstra wrote:
> > On Wed, Jun 26, 2013 at 10:46:33AM -0600, David Ahern wrote:
> > > On 6/26/13 1:05 AM, Peter Zijlstra wrote:
> > > >>What is the expectation that the feature provides? not a whole lot of
> > > >>documentation on it. I walked down the path wondering if it solved an odd
> > > >>problem we are seeing with the CFS in 2.6.27 kernel.
> > > >
> > > >Its supposed to use hrtimers for slice expiry instead of the regular tick.
> > > 
> > > So theoretically CPU bound tasks would get preempted sooner? That was my
> > > guess/hope anyways.
> > 
> > Doth the below worketh?
> > 
> 
> Related to all this; the reason its not enabled by default is that mucking
> about with hrtimers all the while is god awful expensive.

That cost sprang to mind when you mentioned that deadline needs hrtick.

> I've had ideas about making this a special purpose 'hard-coded' timer in the
> hrtimer guts that's only ever re-programmed when the new value is sooner.
> 
> By making it a 'special' timer we can avoid the whole rb-tree song and dance;
> and by taking 'spurious' short interrupts we can avoid prodding the hardware
> too often.
> 
> Then again; Thomas will likely throw frozen seafood my way for even proposing
> stuff like this and I'm not even sure that's going to be enough to make the
> cost acceptable.

Could be worse, flaming marshmallows stick.

-Mike

