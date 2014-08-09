Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaHIONS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:13:18 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38490 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaHIONQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:13:16 -0400
Message-ID: <1407593592.5156.330.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Date: Sat, 09 Aug 2014 16:13:12 +0200
In-Reply-To: <CA+80gGbcjHHWLW-ALaguc+HwhcK1H5NDC+OeiOk-MLEofe52VQ@mail.gmail.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	 <8738dm9t4z.fsf@tassilo.jf.intel.com>
	 <1406532289.5133.223.camel@marge.simpson.net>
	 <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	 <1407059776.5156.108.camel@marge.simpson.net>
	 <CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
	 <1407303693.5090.171.camel@marge.simpson.net>
	 <CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
	 <1407402199.5141.283.camel@marge.simpson.net>
	 <CA+80gGbcjHHWLW-ALaguc+HwhcK1H5NDC+OeiOk-MLEofe52VQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-08-09 at 01:38 -0700, Sergey Oboguev wrote: 
> On Thu, Aug 7, 2014 at 2:03 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> 
> > I see subversion of a perfectly functional and specified mechanism
> 
> Just wondering if the following line of thinking would sound just as much an
> anathema from your perspective or perhaps a bit less terrible...
> 
> Proceeding from the observations (e.g. https://lkml.org/lkml/2014/8/8/492) that
> representative critical section information is not pragmatically expressible at
> development time or dynamically collectable by the application at run time, the
> option still remains to put the weight of managing such information on the
> shoulders of the final link in the chain, the system administrator, providing
> him with application-specific guidelines and also with monitoring tools.
> 
> It might look approximately like this.
> 
> It might be possible to define the scheduling class or some other kind of
> scheduling data entity for the tasks utilizing preemption control. The tasks
> belonging to this class and having critical section currently active are
> preemptible by RT or DL tasks just like normal threads, however they are
> granted a limited and controlled degree of protection against preemption by
> normal threads, and also limited ability to urgently preempt normal threads on
> a wakeup.

Sure, a completely different scheduling class can implement whatever
semantics it wants, just has to be useful and not break the world. 

(spins lots of complexity)

> This is not suggest any particular interface of course, but just a crude sketch
> of a basic approach. I am wondering if you would find it more agreeable within
> your perspective than the use of RT priorities, or still fundamentally
> disagreeable.

Yes, the crux of my objection is the subversion in my view of RT.

> (Personally I am not particularly thrilled by the complexity that would have
> to be added and managed.)

(yeah, you described lots of that)

-Mike

