Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaJTI1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:27:53 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:62579 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbaJTI1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:27:51 -0400
MIME-Version: 1.0
In-Reply-To: <1413722356.2991.8.camel@localhost.localdomain>
References: <1413722356.2991.8.camel@localhost.localdomain>
Date: Mon, 20 Oct 2014 10:27:50 +0200
Message-ID: <CAFLxGvzb1YWc49=dwcJQRNDpxjBSm6PNpxxt6oKi-0uuvSC+bg@mail.gmail.com>
Subject: Re: [uml-devel] [UM] Long loop in __getnsdayoftime() after resume
 from ram
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 2:39 PM, Thomas Meyer <thomas@m3y3r.de> wrote:
> Hello,
>
> in UML kernel I get a long cpu using loop in __getnstimeofday()
> (kernel/time/timekeeping.c:315) in the call of timespec_add_ns(),
> when I left the host kernel suspended to ram for a few hours and resume
> again.
> this is because it seems like the tk->xtime_sec wasn't updated yet, but
> the nsecs were. nsecs can be as high as 8111000111000111000l
>
> the function timespec_add_ns() (include/linux/time.h:266) will call
> __iter_div_u64_rem() which has an optimized loop for the case
> that the dividend is not much bigger as the divisior.
> but this isn't the case for resume from ram on the host kernel.
>
> any ideas how to fix this? is it possible to intercept the resume from
> ram and update the timekeeper->xtime_sec somehow?
> or can the um arch somehow overwrite timespec_add_ns() to always use
> div_u64_rem() instead?

Hmm, does this always happen?
At least on my notebook it did not happen. I've started an UML yesterday
suspended it and after more than 12h it worked fine today.

BTW: Do you see the issue also then freezing UML using the freezer cgroup?
Would be easier to debug. :)

-- 
Thanks,
//richard
