Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3DOQ2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab3DOQ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:28:32 -0400
Message-ID: <516C2A60.6040802@redhat.com>
Date: Mon, 15 Apr 2013 12:27:12 -0400
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
Subject: Re: [PATCH v2 2/3] mutex: Queue mutex spinners with MCS lock to reduce
 cacheline contention
References: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com> <1366036679-9702-3-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1366036679-9702-3-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 10:37 AM, Waiman Long wrote:
> The current mutex spinning code (with MUTEX_SPIN_ON_OWNER option turned
> on) allow multiple tasks to spin on a single mutex concurrently. A
> potential problem with the current approach is that when the mutex
> becomes available, all the spinning tasks will try to acquire the
> mutex more or less simultaneously. As a result, there will be a lot of
> cacheline bouncing especially on systems with a large number of CPUs.
>
> This patch tries to reduce this kind of contention by putting the
> mutex spinners into a queue so that only the first one in the queue
> will try to acquire the mutex. This will reduce contention and allow
> all the tasks to move forward faster.
>
> The queuing of mutex spinners is done using an MCS lock based
> implementation which will further reduce contention on the mutex
> cacheline than a similar ticket spinlock based implementation. This
> patch will add a new field into the mutex data structure for holding
> the MCS lock. This expands the mutex size by 8 bytes for 64-bit system
> and 4 bytes for 32-bit system. This overhead will be avoid if the
> MUTEX_SPIN_ON_OWNER option is turned off.

> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
