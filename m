Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496AbaLAVth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:49:37 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37465 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbaLAVtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:49:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141201213417.GA5842@redhat.com>
References: <20141201213357.GA5834@redhat.com>
	<20141201213417.GA5842@redhat.com>
Date: Mon, 1 Dec 2014 13:49:35 -0800
X-Google-Sender-Auth: jy5IlbuqcoVztk5ztbnjxAHoYvc
Message-ID: <CA+55aFz6a99n_bGGi0CrOeWA3KRVdAJtPiF_3iP1aVx_wE+mMA@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86, ticketlock: spin_unlock_wait() can livelock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Waiman Long <Waiman.Long@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 1:34 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> But we do not need to wait for arch_spin_is_locked() == F. If it is
> locked we only need to wait until the current owner drops this lock.
> So we could simply spin until old_head != lock->tickets.head in this
> case, but .head can overflow and thus we can't check "unlocked" only
> once before the main loop.

Ack. Looks like a good idea. Can you point to the report that you
think this might be the cause of?

                    Linus
