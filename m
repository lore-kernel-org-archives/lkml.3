Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaJ0Vyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:54:40 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:46173 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaJ0Vyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1410272223330.5308@nanos>
References: <1414388748-3333-1-git-send-email-pang.xunlei@linaro.org>
	<alpine.DEB.2.11.1410272223330.5308@nanos>
Date: Mon, 27 Oct 2014 14:54:38 -0700
Message-ID: <CALAqxLV39LXWO6Lg+q8sU3SbrXh=8=gDqzpF1BGYckXB7Odn6g@mail.gmail.com>
Subject: Re: [PATCH RFC 01/12] time: Rename mktime() to mktime_unsafe()
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 2:38 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 27 Oct 2014, pang.xunlei wrote:
>
>> The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, thus it
>> will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.
>>
>> Currently, mktime() deals with "unsigned long" which is 2038 unsafe on 32-bit systems.
>>
>> As part of addressing 2038 saftey for in-kernel uses, this patch renames mktime() to
>> mktime_unsafe(), and changes all its calling users correspondingly. The safe version
>> of mktime() will be added in the following patch.
>
> This is a flag day change. We really want to avoid that. Can we please
> add a new interface first, then convert all the existing users and
> kill the old interface.
>
> If we really care we can rename it back to the old name once all that
> has been done, but I personally do not care whether its mktime or
> mktime64 as long as it is fixed proper.

This was my bad, as I gave him guidance here. I was hoping to avoid
doing the one-by-one function renaming dance twice, just to fix the
function.

But you're probably right, and someone will probably add a new usage
right before this gets merged and we'll have some pain there.

-john
