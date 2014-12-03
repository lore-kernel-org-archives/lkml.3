Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaLCUjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:39:00 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:62741 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaLCUi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:38:59 -0500
MIME-Version: 1.0
In-Reply-To: <20141203201947.GA4931@redhat.com>
References: <20141203181922.GA26916@redhat.com> <20141203192919.GP25340@linux.vnet.ibm.com>
 <547F6D60.5050007@amacapital.net> <20141203201947.GA4931@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Dec 2014 12:38:36 -0800
Message-ID: <CALCETrVtKcwWsN4q7kp-K7kEfQyebKfSbBQy4iAhfP0WPVZNpQ@mail.gmail.com>
Subject: Re: audit: rcu_read_lock() used illegally while idle
To: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 12:19 PM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Dec 03, 2014 at 12:06:56PM -0800, Andy Lutomirski wrote:
>
>  > >> Did something in RCU change recently ?
>  > >
>  > > Not since -rc1, as far as I know, anyway.
>  >
>  > I have patches to delete this whole fscking sysret fast but not really
>  > fast path.  I'll resend them for 3.19.  In the mean time, can you test
>  > this patch by itself:
>  >
>  > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=1072a16a8d4ad1b11b8062f76e3236b9771b0fb6
>
> With that applied, I no longer see the trace.
>

Thanks.

The bug is that SCHEDULE_USER in sysret_schedule is wrong.  I'd
suggest adding a warning to schedule_user that fires if context
tracking thinks we're already in the kernel.

FWIW, I think that the rest of the SCHEDULE_USER calls may be wrong,
too.  In particular, the one in int_careful looks wrong as well, so I
don't see why my patch made a difference if I'm right.

Frédéric, any ideas here?  As a stopgap measure, making SCHEDULE_USER
restore the previous state might make sense for 3.18.

--Andy

> thanks,
>
>         Dave
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
