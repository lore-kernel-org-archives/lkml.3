Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab3FLXuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:50:32 -0400
Received: from ozlabs.org ([203.10.76.45]:35799 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787Ab3FLXub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:50:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Thomas Meyer <thomas@m3y3r.de>, mst@redhat.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [RFC] PTR_ERR: return 0 if ptr isn't an error value.
In-Reply-To: <20130603071526.GA5483@pengutronix.de>
References: <1370080565.29224.29.camel@localhost.localdomain> <87mwr8sz9g.fsf@rustcorp.com.au> <20130603071526.GA5483@pengutronix.de>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sun, 09 Jun 2013 15:25:11 +0930
Message-ID: <87y5ajq14w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König <u.kleine-koenig@pengutronix.de> writes:
> Hello Rusty,
>
> [added akpm to Cc: who took the patch back then and Julia for the
> coccinelle part below]
>
> On Mon, Jun 03, 2013 at 11:59:15AM +0930, Rusty Russell wrote:
>> 
>> Back in 2011, Uwe Kleine-König added the nonsensically-named
>> PTR_RET(), providing a means to avoid if() statements in code (commit 
>> fa9ee9c4b9).
>> 
>> Instead, just make PTR_ERR() return 0 if the pointer isn't an error
>> value.  This is harmless, since PTR_ERR() should have never been
>> passed a non-error value.  And GCC is usually smart enough to remove
>> the extra test if IS_ERR() has already been called.
> I wonder in which situations gcc fails to be smart enough. Did you check
> this?

Good q.  I just wrote a simple test to confirm that GCC usually did,
then compared the text sizes.  Since it was bigger, I assume GCC isn't
doing it all the time.

Hmm, first change is in do_debug.  Ah, no surprise here:

	if (notify_die(DIE_DEBUG, "debug", regs, PTR_ERR(&dr6), error_code,
							SIGTRAP) == NOTIFY_STOP)
		goto exit;

Huh?  dr6 is on the stack?  Ancient, fixed.

I'll wade through the other differences after the weekend...

Cheers,
Rusty.
