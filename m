Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3BMFhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 00:37:23 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34504 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3BMFhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 00:37:22 -0500
Date: Tue, 12 Feb 2013 21:37:27 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
In-Reply-To: <20130213041629.GA28622@redhat.com>
Message-ID: <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils> <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils> <20130213041629.GA28622@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013, Dave Jones wrote:
> On Tue, Feb 12, 2013 at 04:56:55PM -0800, Hugh Dickins wrote:
>  
>  > > so I can hit this pretty quickly with this..
>  > > 
>  > > while [ 1 ];
>  > > do
>  > >  rtcwake -s 5 -m no ; pm-suspend
>  > > done
>  > > 
>  > > Which should make it bisectable at least..
>  > 
>  > Thanks, I'll give that a try this evening.
>  
> So uh, put a 'sleep 5' in that loop.

I had already put exactly that, to help break out when I got bored.

I'm afraid it just confirms that we have different problems: that
script gives me no trouble.  Perhaps it would give me trouble if the
timeout went up from 5 seconds to 10 hours (it does not at 10 minutes),
but that doesn't feel like a very useful line of enquiry.

I think for the moment I'm going to hope that under the surface our
problems are related, and when your bisection points a finger, look
around to see if it suggests anything for my case.  Lazy, but...

Hugh

> 
> Turns out that the firmware on my Thinkpad craps itself when it tries to suspend while
> the cpu fan is still spinning back up, and eventually it gets in a state (on a 'good' boot)
> where the fan is stuck in the 'off' state.
> 
> Result: hot laptop, machine check exceptions, and then a nice
> "CPU FAN ERROR" message from the BIOS on next reboot.
> 
> Full marks Lenovo.
> 
> 	Dave
