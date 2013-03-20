Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3CTU4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:56:17 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:50186 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3CTU4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:56:14 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyv3u4uuAamCONMBUmB+rh0JsY4HdOj+UKwtTk0Wzf7Ag@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<CA+55aFyv3u4uuAamCONMBUmB+rh0JsY4HdOj+UKwtTk0Wzf7Ag@mail.gmail.com>
Date: Wed, 20 Mar 2013 13:56:12 -0700
X-Google-Sender-Auth: tbpa4CZsOPZvLfiZiVtTZzFEnOE
Message-ID: <CA+55aFzRsjj6Tc452EcCFsNmXk+t=AkuzxKuy-AVV3RjUssB_g@mail.gmail.com>
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

On Wed, Mar 20, 2013 at 1:49 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It *would* be lovely to see this run with the actual Swingbench
> numbers. The microbenchmark always looked much nicer. Do the
> additional multi-semaphore scalability patches on top of Davidlohr's
> patches help with the swingbench issue, or are we still totally
> swamped by the ipc lock there?
>
> Maybe there were already numbers for that, but the last swingbench
> numbers I can actually recall was from before the finer-grained
> locking..

Ok, and if the spinlock is still a big deal even with the finer
granularity, it might be interesting to hear if Michel's fast locks
make a difference. I'm guessing that this series might actually make
it easier/cleaner to do the semaphore locking using another lock,
since the ipc_lock got split up and out...

I think Michel did it for some socket code too. I think that was
fairly independent and was for netperf.

            Linus
