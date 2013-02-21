Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3BUDTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 22:19:11 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:44047 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3BUDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 22:19:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130220164257.0905dc45.akpm@linux-foundation.org>
References: <20130220223013.GA15760@redhat.com>
	<1361402236-28644-1-git-send-email-msb@chromium.org>
	<20130220152446.a65ff84f.akpm@linux-foundation.org>
	<CACBanvr+1VEM6UqfNVx+KiuehZejwqpGp6djPN5kTgYD-umP2g@mail.gmail.com>
	<20130220162015.545ebb6b.akpm@linux-foundation.org>
	<CACBanvrdvTW+C2d2-+bC++mJOb8+3qNs2GgY3gf_9EfY+kNPvA@mail.gmail.com>
	<20130220164257.0905dc45.akpm@linux-foundation.org>
Date: Wed, 20 Feb 2013 19:19:08 -0800
X-Google-Sender-Auth: j_djMRUGsuB8IqcCDxju68GAS_s
Message-ID: <CACBanvpa9tg9pTAaTqSkN35-=6EQ53HGumNFM9S9fmcmPGcMjw@mail.gmail.com>
Subject: Re: [PATCH v4] lockdep: check that no locks held at freeze time
From: Mandeep Singh Baines <msb@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 4:42 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 20 Feb 2013 16:28:07 -0800
> Mandeep Singh Baines <msb@chromium.org> wrote:
>
>> > Backtraces aren't *that* bad.  We'll easily be able to tell which of
>> > the two callsites triggered the trace.
>> >
>>
>> Let's say there was a try_to_freeze() that got inlined indirectly
>> (multiple levels of inline) into do_exit. Wouldn't the backtraces for
>> the regular exit check and the try_to_freeze check be identical except
>> for the offset (do_exit+0x45 versus do_exit+0x88)? So unless you had
>> an object file you wouldn't know which check you hit.
>
> Mutter.  Spose so.  Vaguely possible.  Yes, if we want to avoid a
> wont-happen, use __FILE__ and __LINE__.  Or, probably more sanely,
> __func__.
>

Fair enough. I'll avoid using a macro unless/until its actually needed.

Regards,
Mandeep

> Or uninline try_to_freeze().  If anything's calling that at high
> frequency, we have a problem.  And given the number of callsites,
> getting it into icache might result in a faster kernel...
>
> (Someone needs to teach __might_sleep() about __ratelimit())
