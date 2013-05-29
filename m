Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964899Ab3E2HWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:22:45 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:58869 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964837Ab3E2HWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:22:42 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <51A51DA4.7010805@canonical.com>
References: <20130528144420.4538.70725.stgit@patser>
	<20130528144845.4538.93485.stgit@patser>
	<20130528191847.GE15743@phenom.ffwll.local>
	<51A51DA4.7010805@canonical.com>
Date: Wed, 29 May 2013 09:22:41 +0200
Message-ID: <CAKMK7uE_-QAg6fLMeJS8v+fFjBX+Su-4p=b09bFEvooAs0SmCw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH v4 3/4] mutex: Add ww tests to
 lib/locking-selftest.c. v4
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        x86@kernel.org, dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        rob clark <robclark@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 11:12 PM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
>>> +static void ww_test_spin_nest_unlocked(void)
>>> +{
>>> +    raw_spin_lock_nest_lock(&lock_A, &o.base);
>>> +    U(A);
>>> +}
>> I don't quite see the point of this one here ...
> It's a lockdep test that was missing. o.base is not locked. So lock_A is being nested into an unlocked lock, resulting in a lockdep error.

Sounds like a different patch then ...

>>> +
>>> +static void ww_test_unneeded_slow(void)
>>> +{
>>> +    int ret;
>>> +
>>> +    WWAI(&t);
>>> +
>>> +    ww_mutex_lock_slow(&o, &t);
>>> +}
>> I think checking the _slow debug stuff would be neat, i.e.
>> - fail/success tests for properly unlocking all held locks
>> - fail/success tests for lock_slow acquiring the right lock.
>>
>> Otherwise I didn't spot anything that seems missing in these self-tests
>> here.
>>
> Yes it would be nice, doing so is left as an excercise for the reviewer, who failed to raise this point sooner. ;-)

Hm, I guess I've volunteered myself to look into this a bit ;-)
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
