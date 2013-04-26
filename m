Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3DZWEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:04:35 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:49357 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3DZWEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:04:33 -0400
Date: Fri, 26 Apr 2013 15:04:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: Tree for Apr 26 [ bluetooth on suspend/resume ]
Message-ID: <20130426220427.GE1433@mtj.dyndns.org>
References: <CA+icZUVCmFeh3Xna37VJDDzvZ34sYJ_Dser7i5rRzGLhMTi5-Q@mail.gmail.com>
 <CA+icZUXeDT8x60iUtjJV2GO5KkDnm8CJsz8mntz5hREoOD+YJw@mail.gmail.com>
 <CA+icZUWkyP9TE0eeqstyvVNP++MtN8rYfGcPBT6NuMOHEHm7dw@mail.gmail.com>
 <20130426182239.GA25767@mtj.dyndns.org>
 <CA+icZUVWRkP_fxTH22ywx9Ntnnp1xW_2dVRjwTvBfs0eJBcEVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVWRkP_fxTH22ywx9Ntnnp1xW_2dVRjwTvBfs0eJBcEVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:07:44PM +0200, Sedat Dilek wrote:
> > The second argument %rsi is zero, which got transferred to %r13 and
> > then offset deref on it trapped.
> >
> > The second argument is @wq and the oopsing code is the wq->flags deref
> > in the following if condition.
> >
> >         /* if dying, only works from the same workqueue are allowed */
> >         if (unlikely(wq->flags & __WQ_DRAINING) &&
> >                 WARN_ON_ONCE(!is_chained_work(wq)))
> >                 return;
> >
> > So, umm, don't pass in NULL as @wq. :)
> >
> 
> Do you have a patch for this?

Heh, I haven't even looked at the caller.  It's a bug on the workqueue
user side.

Thanks.

-- 
tejun
