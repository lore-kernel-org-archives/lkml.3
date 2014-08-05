Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaHEOpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:45:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45472 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbaHEOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:45:08 -0400
Message-ID: <53E0EDD2.50600@canonical.com>
Date: Tue, 05 Aug 2014 16:44:34 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Shuah Khan <shuahkhan@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/2 v6] locking/selftest: Support queued rwlock
References: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com> <1406659999-13974-3-git-send-email-Waiman.Long@hp.com> <20140805132837.GA19379@twins.programming.kicks-ass.net> <CAKocOOMa89+Ej0rk-LyQLBcwDvLtsXq7x+oPwBMS1N61kKUwQg@mail.gmail.com> <20140805144108.GK9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140805144108.GK9918@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 05-08-14 16:41, Peter Zijlstra schreef:
> On Tue, Aug 05, 2014 at 08:07:28AM -0600, Shuah Khan wrote:
>> On Tue, Aug 5, 2014 at 7:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> Maybe I wasn't clear; but I meant you should extend the lock tests to
>>> cover the full qrwlock semantics.
>>>
>>> That means we also need tests like:
>>>
>>>         RL(X1);
>>>         IRQ_ENTER();
>>>         RL(X2);
>>>         IRQ_EXIT();
>>>
>>> To fully validate that in_interrupt exception to fairness etc..
>> A bit off topic for this patch, however relevant for tests in general.
>> Is there a reason why these locking selftests need to be under lib?
>> Can they be consolidated under tools/testing/selftests?
> tools/ seems wrong as its very much not userspace.
Could be moved to kernel/locking though now that all other locking moved there. :-)

~Maarten
