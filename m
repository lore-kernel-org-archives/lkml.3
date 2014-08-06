Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675AbaHFRYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:24:40 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:32663 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbaHFRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:24:38 -0400
Message-ID: <53E264D4.5090800@hp.com>
Date: Wed, 06 Aug 2014 13:24:36 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v6] locking/selftest: Support queued rwlock
References: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com> <1406659999-13974-3-git-send-email-Waiman.Long@hp.com> <20140805132837.GA19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140805132837.GA19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 09:28 AM, Peter Zijlstra wrote:
> On Tue, Jul 29, 2014 at 02:53:19PM -0400, Waiman Long wrote:
>> The queued rwlock does not support the use of recursive read-lock in
>> the process context. With changes in the lockdep code to check and
>> disallow recursive read-lock, it is also necessary for the locking
>> selftest to be updated to change the process context recursive read
>> locking results from SUCCESS to FAILURE for rwlock.
>>
> Maybe I wasn't clear; but I meant you should extend the lock tests to
> cover the full qrwlock semantics.
>
> That means we also need tests like:
>
> 	RL(X1);
> 	IRQ_ENTER();
> 	RL(X2);
> 	IRQ_EXIT();
>
> To fully validate that in_interrupt exception to fairness etc..

Sorry for misinterpretation. I have just sent out an updated patch with 
additional self tests to verify that recursive read-lock is allowed 
under interrupt context.

-Longman
