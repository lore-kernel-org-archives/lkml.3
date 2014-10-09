Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbaJIQHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:07:51 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45753 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaJIQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:07:43 -0400
Date: Thu, 9 Oct 2014 09:07:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, torvalds@linuxfoundation.org,
        Josh Cartwright <joshc@codeaurora.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: pinctrl-msm build error on Linus' tree
Message-ID: <20141009160737.GE31987@roeck-us.net>
References: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>
 <20141008231208.GB25134@roeck-us.net>
 <CACRpkdZHHPvJiYmAvYdGb01sKsSmkfuV+d4-skSePbFFEjYs2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZHHPvJiYmAvYdGb01sKsSmkfuV+d4-skSePbFFEjYs2g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 09:34:03AM +0200, Linus Walleij wrote:
> On Thu, Oct 9, 2014 at 1:12 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On Wed, Oct 08, 2014 at 06:42:55PM -0400, Josh Boyer wrote:
> 
> >> However, there is literally nothing else in the tree that calls or
> >> provides those functions:
> >>
> >> [jwboyer@vader linux]$ git grep unregister_restart_handler
> >> drivers/pinctrl/qcom/pinctrl-msm.c:     unregister_restart_handler(&pctrl->resta
> >> [jwboyer@vader linux]$
> >>
> >>
> >> I'm rather confused.  How was this commit built and tested?
> 
> I guess the dependent tree was being pulled into linux-next before
> the pinctrl tree, and so the end result was working?
> 
> > Looks like the pinctrl tree did not include the merge with the immutable
> > branch with the necessary infrastructure in its pull request to Linus :-(.
> 
> Yeah maybe I missed some pull request for that, such things happen.
> 
> > As for how it was tested in the pinctrl tree, no idea. Maybe pinctrl-msm has
> > some dependency which was missing in the pinctrl tree and came in through
> > a different pull request.
> 
> See above.
> 
> Anyway, it is a minor platform, not x86_64. So don't exaggerate
> this thing, and besides the restart notifiers are great.
> 
> If we go down the route of trying to always avoid all trouble in the
> world by adding more procedure I guess we shouldn't shoehorn

Not a matter of procedure, but it would have been easy to avoid.
I take at least part of the blame here because I did not follow up
with you to make sure that you merge the infrastructure into your tree.

> too much into the same merge window and should have this
> postponed to v3.19. But I don't know if it buys us so much.
> 
That was the original idea, but the restart handler was way more successful
that I thought it would or could be, so things got pulled in a bit.

Anyway, I tend to agree - there are now several other build failures in
Linus' tree which it inherited from linux-next. I consider those worse,
especially since the majority if not all of those problems were known
from -next but ignored. Wonder what the value of -next is if people
don't care if it builds or not :-(.

But then Linus ignored my pull request (so far), so maybe I did manage to
upset him ;-).

Guenter
