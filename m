Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3DOOqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:46:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab3DOOqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:46:22 -0400
Message-ID: <516C128C.3040302@redhat.com>
Date: Mon, 15 Apr 2013 10:45:32 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/3] mutex: Make more scalable by doing less atomic
 operations
References: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com> <1366036679-9702-2-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1366036679-9702-2-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 10:37 AM, Waiman Long wrote:
> In the __mutex_lock_common() function, an initial entry into
> the lock slow path will cause two atomic_xchg instructions to be
> issued. Together with the atomic decrement in the fast path, a total
> of three atomic read-modify-write instructions will be issued in
> rapid succession. This can cause a lot of cache bouncing when many
> tasks are trying to acquire the mutex at the same time.
>
> This patch will reduce the number of atomic_xchg instructions used by
> checking the counter value first before issuing the instruction. The
> atomic_read() function is just a simple memory read. The atomic_xchg()
> function, on the other hand, can be up to 2 order of magnitude or even
> more in cost when compared with atomic_read(). By using atomic_read()
> to check the value first before calling atomic_xchg(), we can avoid a
> lot of unnecessary cache coherency traffic. The only downside with this
> change is that a task on the slow path will have a tiny bit
> less chance of getting the mutex when competing with another task
> in the fast path.
>

> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> Reviewed-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
