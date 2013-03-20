Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab3CTUtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:49:55 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:57414 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3CTUty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:49:54 -0400
MIME-Version: 1.0
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Date: Wed, 20 Mar 2013 13:49:53 -0700
X-Google-Sender-Auth: __aN6-R8QAjAEIoZB0ysx94etDg
Message-ID: <CA+55aFyv3u4uuAamCONMBUmB+rh0JsY4HdOj+UKwtTk0Wzf7Ag@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@surriel.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 12:55 PM, Rik van Riel <riel@surriel.com> wrote:
>
> This series makes the sysv semaphore code more scalable,
> by reducing the time the semaphore lock is held, and making
> the locking more scalable for semaphore arrays with multiple
> semaphores.

The series looks sane to me, and I like how each individual step is
pretty small and makes sense.

It *would* be lovely to see this run with the actual Swingbench
numbers. The microbenchmark always looked much nicer. Do the
additional multi-semaphore scalability patches on top of Davidlohr's
patches help with the swingbench issue, or are we still totally
swamped by the ipc lock there?

Maybe there were already numbers for that, but the last swingbench
numbers I can actually recall was from before the finer-grained
locking..

And obviously, getting this tested so that there aren't any more
missed wakeups etc would be lovely. I'm assuming the plan is that this
all goes through Andrew? Do we have big semop users who could test it
on real loads? Considering that I *suspect* the main users are things
like Oracle etc, I'd assume that there's some RH lab or partner or
similar that is interested in making sure this not only helps, but
also that it doesn't break anything ;)

                 Linus
