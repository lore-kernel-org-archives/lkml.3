Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbbAGVW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:22:58 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56250 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbbAGVW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:22:57 -0500
MIME-Version: 1.0
In-Reply-To: <2142273.XSm0MMUjAB@wuerfel>
References: <1420663910-6406-1-git-send-email-john.stultz@linaro.org>
	<1420663910-6406-2-git-send-email-john.stultz@linaro.org>
	<2142273.XSm0MMUjAB@wuerfel>
Date: Wed, 7 Jan 2015 13:22:56 -0800
Message-ID: <CALAqxLUKxP98bc0w_15_CLhGkmFsT-3d++3U6r_+fpuKTBpfSA@mail.gmail.com>
Subject: Re: [PATCH 2/2][RFC] ipmi: Update timespec usage to timespec64
From: John Stultz <john.stultz@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Corey Minyard <minyard@acm.org>,
        openipmi-developer <openipmi-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 1:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 07 January 2015 12:51:50 John Stultz wrote:
>> As part of the internal y2038 cleanup, this patch removes
>> timespec usage in the ipmi driver, replacing it timespec64
>>
>> Cc: Corey Minyard <minyard@acm.org>
>> Cc: openipmi-developer@lists.sourceforge.net
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>
>
> In other drivers, we tended to use ktime_t and monotonic time,
> but your approach is definitely simpler because it doesn't have
> to rework the ipmi_si_is_busy logic and just do a
> s/timespec/timespec64/ conversion.
>
> Do you think it makes sense to use ktime_get_ts64 instead of
> getnstimeofday64 to get a monotonic time? The advantage would
> be to have the code work slightly better when racing against
> settimeofday, the downside would be that the debug printk
> shows the changed time base, but that would hopefully be
> irrelevant to someone debugging the code.

So here they were explicitly printing wall-time in sec/usec, so I was
somewhat hoping not to create any major behavioral changes.

But looking at this again, I see I sent a stale patch which has a
build bug (using tv_usec w/ a timespec64)... so let me redo this
anyway.

thanks
-john
