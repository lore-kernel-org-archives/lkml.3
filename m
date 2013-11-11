Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3KKRUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:20:40 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:32817 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3KKRUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:20:33 -0500
Date: Mon, 11 Nov 2013 18:20:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: Warning: NO_HZ FULL will not work with unstable sched clock
Message-ID: <20131111172028.GF26853@localhost.localdomain>
References: <CAA1sL1SNn7O5CQbJn+dC5EjJKM-kfZq+brWLotC7LCNYVNBmeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA1sL1SNn7O5CQbJn+dC5EjJKM-kfZq+brWLotC7LCNYVNBmeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 12:32:06PM +0400, Alexander Beregalov wrote:
> Hi,
> It first appeared some time after 3.9 or 3.10 and still persist.
> I guess bisect is not required?
> 
> WARNING: CPU: 1 PID: 6 at kernel/time/tick-sched.c:187
> can_stop_full_tick+0x8d/0x9a()
> NO_HZ FULL will not work with unstable sched clock

Right, it's not a bug, just a warning we've put to make sure that users of
full dynticks are aware of limitations when the sched clock is unstable.

That's something we want to fix in the long run as it seems that quite
a lot of people have unstable tsc.

Thanks.
