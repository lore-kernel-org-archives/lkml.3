Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaB1TdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:33:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36997 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaB1Tc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:32:59 -0500
Message-ID: <5310E449.1050609@oracle.com>
Date: Fri, 28 Feb 2014 14:32:25 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, peterz@infradead.org,
        mingo@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: increase static allocations
References: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1389208906-24338-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 02:21 PM, Sasha Levin wrote:
> Fuzzing a recent kernel with a large configuration hits the static
> allocation limits and disables lockdep.
>
> This patch doubles the limits.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>   kernel/locking/lockdep_internals.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/locking/lockdep_internals.h b/kernel/locking/lockdep_internals.h
> index 4f560cf..51c4b24 100644
> --- a/kernel/locking/lockdep_internals.h
> +++ b/kernel/locking/lockdep_internals.h
> @@ -54,9 +54,9 @@ enum {
>    * table (if it's not there yet), and we check it for lock order
>    * conflicts and deadlocks.
>    */
> -#define MAX_LOCKDEP_ENTRIES	16384UL
> +#define MAX_LOCKDEP_ENTRIES	32768UL
>
> -#define MAX_LOCKDEP_CHAINS_BITS	15
> +#define MAX_LOCKDEP_CHAINS_BITS	16
>   #define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)
>
>   #define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
> @@ -65,7 +65,7 @@ enum {
>    * Stack-trace: tightly packed array of stack backtrace
>    * addresses. Protected by the hash_lock.
>    */
> -#define MAX_STACK_TRACE_ENTRIES	262144UL
> +#define MAX_STACK_TRACE_ENTRIES	524288UL
>
>   extern struct list_head all_lock_classes;
>   extern struct lock_chain lock_chains[];
>


Can someone pick the patch up please? PeterZ even (seemed to) acked it.


Thanks,
Sasha
