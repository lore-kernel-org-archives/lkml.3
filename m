Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaHEOHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:07:30 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:34759 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaHEOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:07:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140805132837.GA19379@twins.programming.kicks-ass.net>
References: <1406659999-13974-1-git-send-email-Waiman.Long@hp.com>
	<1406659999-13974-3-git-send-email-Waiman.Long@hp.com>
	<20140805132837.GA19379@twins.programming.kicks-ass.net>
Date: Tue, 5 Aug 2014 08:07:28 -0600
Message-ID: <CAKocOOMa89+Ej0rk-LyQLBcwDvLtsXq7x+oPwBMS1N61kKUwQg@mail.gmail.com>
Subject: Re: [PATCH 2/2 v6] locking/selftest: Support queued rwlock
From: Shuah Khan <shuahkhan@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 7:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> Maybe I wasn't clear; but I meant you should extend the lock tests to
> cover the full qrwlock semantics.
>
> That means we also need tests like:
>
>         RL(X1);
>         IRQ_ENTER();
>         RL(X2);
>         IRQ_EXIT();
>
> To fully validate that in_interrupt exception to fairness etc..

A bit off topic for this patch, however relevant for tests in general.
Is there a reason why these locking selftests need to be under lib?
Can they be consolidated under tools/testing/selftests?

-- Shuah
