Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaCFTiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:38:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaCFTiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:38:16 -0500
Message-ID: <5318CE31.7000806@redhat.com>
Date: Thu, 06 Mar 2014 14:36:17 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/6] cputime: Fix jiffies based cputime assumption on
 steal accounting
References: <1394128601-26034-1-git-send-email-fweisbec@gmail.com> <1394128601-26034-5-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1394128601-26034-5-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 12:56 PM, Frederic Weisbecker wrote:
> The steal guest time accounting code assumes that cputime_t is based on
> jiffies. So when CONFIG_NO_HZ_FULL=y, which implies that cputime_t
> is based on nsecs, steal_account_process_tick() passes the delta in
> jiffies to account_steal_time() which then accounts it as if it's a
> value in nsecs.
>
> As a result, accounting 1 second of steal time (with HZ=100 that would
> be 100 jiffies) is spuriously accounted as 100 nsecs.
>
> As such /proc/stat may report 0 values of steal time even when two
> guests have run concurrently for a few seconds on the same host and
> same CPU.
>
> In order to fix this, lets convert the nsecs based steal delta to
> cputime instead of jiffies by using the right conversion API.
>
> Given that the steal time is stored in cputime_t and this type can have
> a smaller granularity than nsecs, we only account the rounded converted
> value and leave the remaining nsecs for the next deltas.
>
> Reported-by: Huiqingding <huding@redhat.com>
> Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>

