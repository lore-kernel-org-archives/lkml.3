Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbbAFFBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 00:01:13 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:45115 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbbAFFBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 00:01:12 -0500
MIME-Version: 1.0
In-Reply-To: <20150105161412.44f53313e1d771dc9f968264@linux-foundation.org>
References: <1419338309-16729-1-git-send-email-kiran.kumar@linaro.org>
	<20150105161412.44f53313e1d771dc9f968264@linux-foundation.org>
Date: Tue, 6 Jan 2015 10:31:11 +0530
Message-ID: <CA+RfmHax1j3oFUWzNNqBmQqkZA9xGT0u0+azc0PAqNuzhJqSuA@mail.gmail.com>
Subject: Re: [RFC v4] debug: prevent entering debug mode on panic/exception.
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 6 January 2015 at 05:44, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 23 Dec 2014 18:08:29 +0530 Kiran Raparthy <kiran.kumar@linaro.org> wrote:
>
>> From: Colin Cross <ccross@android.com>
>>
>> debug: prevent entering debug mode on panic/exception.
>>
>> On non-developer devices, kgdb prevents the device from rebooting
>> after a panic.
>>
>> Incase of panics and exceptions, to allow the device to reboot, prevent
>> entering debug mode to avoid getting stuck waiting for the user to interact
>> with debugger.
>>
>> To avoid entering the debugger on panic/exception without any extra
>> configuration, panic_timeout is being used which can be set via
>> /proc/sys/kernel/panic at run time and CONFIG_PANIC_TIMEOUT sets the default
>> value.
>>
>> ...
>>
>
> hm.  Why overload the meaning of panic_timeout in this fashion?  If
> someone is using kgdb and has panic_timeout set, they'll get quiet a
> surprise.
We are just using already exported kernel symbol to avoid extra configuration.
So we have chosen panic_timeout to allow kgdb to honor CONFIG_PANIC_TIMEOUT.
I can modify the commit text if you feel the above commit text
overloading the meaning of panic_timeout.

To give you a better idea about why we have used panic_timeout,
sharing Daniel's previous review comment:

"It ought to be possible for kgdb/kdb to honour CONFIG_PANIC_TIMEOUT by
tracking how long it takes for the user to attach a debugger (or to run
the first kdb command after the panic). As it happens the timeout value
is already an exported kernel symbol so all the info is there for us to
use.Doing so would save us imposing further configuration burden on the user"

>
> Would it be cleaner/clearer to add some new standalone control for
> this?  One which is only present if CONFIG_KGDB.

Original Android patch uses separate configuration but since we can
achieve the same with
already existing kernel symbol,we have used panic_timeout.
>
>
> We appear to have forgotten to document panic_timeout.  Sigh.
Regards,
Kiran
