Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbaIUNiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:38:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60691 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaIUNiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:38:14 -0400
Message-ID: <541ED4C2.2050009@colorfullife.com>
Date: Sun, 21 Sep 2014 15:38:10 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dbueso@suse.de
Subject: Re: [PATCH] V1 1/2] ipc: let message queues use SIGEV_THREAD_ID with
 mq_notify
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

You wrote:
> Currently the only thread-safe way of using mq_notify with message 
> queues is to use the SIGEV_THREAD option.
Could you explain what you mean with "only thread-safe way"?
I'm a bit relunctant to extend mq_notify() without understanding the reason.

What about:
- use sigprocmask()
- create one worker thread
- then in a loop in that worker thread: use sigwaitinfo() or signalfd() 
to collect the signals.


And one point I don't like: Within timer_create():
>  SIGEV_THREAD_ID (Linux-specific)
>  [...]
> The sigev_notify_thread_id field specifies a kernel thread ID, that 
> is, the value returned by clone(2) or gettid(2).
Does that mean that SIGEV_THREAD_ID is guaranteed to remain 
Linux-specific, it's implicitely linked to the Linux clone()/gettid() 
threading model?

> This flag is intended only for use by threading libraries.


--
     Manfred
