Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaHINEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 09:04:22 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38310 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaHINES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 09:04:18 -0400
Message-ID: <1407589454.5156.308.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Date: Sat, 09 Aug 2014 15:04:14 +0200
In-Reply-To: <CA+80gGZWSeoHFM-_uoGFCw4nJAkQGfTjEKfSyAaqTw6xmUVMvA@mail.gmail.com>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
	 <8738dm9t4z.fsf@tassilo.jf.intel.com>
	 <1406532289.5133.223.camel@marge.simpson.net>
	 <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	 <1407059776.5156.108.camel@marge.simpson.net>
	 <CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
	 <1407303693.5090.171.camel@marge.simpson.net>
	 <CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
	 <1407402199.5141.283.camel@marge.simpson.net>
	 <CA+80gGZWSeoHFM-_uoGFCw4nJAkQGfTjEKfSyAaqTw6xmUVMvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-08 at 13:11 -0700, Sergey Oboguev wrote: 
> On Thu, Aug 7, 2014 at 2:03 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
> 
> > task priority cannot be used by any task to describe a critical section.
> > I assert that is that there is _zero_ critical section information present.
> 
> This appears to be the crux of our disagreement.
> 
> This assertion is incorrect. The use of RT to bracket a critical section
> obviously _does_ provide the following information:

You sure don't give up easy.

> 1) designation of entry point for the start of critical activity

Yup, a task can elevate its priority upon entering scram_reactor(), iff
it gets there, scram might still be considered a critical activity.

> 2) designation of exit point, albeit with timing not known in advance at entry
> time

Yeah, exit works ok if enter happens.

You are not going to convince me that it is cool to assign an imaginary
priority to a SCHED_FIFO class task, and still call the resulting mutant
a SCHED_FIFO class task.  Those things have defines semantics.  It is
not ok for a SCHED_FIFO task of a lower priority to completely ignore a
SCHED_FIFO task of a higher priority because it's part of an application
which has one or more wild cards, or maybe even a get out of jail free
card it can pull out of its butt.

NAK.  There it is, my imaginary NAK to imaginary realtime priorities :)

-Mike


