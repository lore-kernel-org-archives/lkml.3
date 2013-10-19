Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3JSAvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:51:55 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52679 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3JSAvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:51:54 -0400
MIME-Version: 1.0
X-Originating-IP: [67.83.170.180]
In-Reply-To: <5261CF41.6050300@linaro.org>
References: <1381511515-2577-1-git-send-email-patrick@parcs.ath.cx>
	<5261CF41.6050300@linaro.org>
Date: Fri, 18 Oct 2013 20:51:53 -0400
Message-ID: <CA+C-WL-Rma1ZcuFfaECvzhiRvYBJjktJQT1i82__mk+rU2K+iw@mail.gmail.com>
Subject: Re: [PATCH] time: Fix signedness bug in sysfs_get_uname() and its callers
From: Patrick Palka <patrick@parcs.ath.cx>
To: John Stultz <john.stultz@linaro.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 8:16 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 10/11/2013 10:11 AM, Patrick Palka wrote:
>> sysfs_get_uname() is erroneously declared as returning size_t even
>> though it may return a negative value, specifically -EINVAL.  Its
>> callers then check whether its return value is less than zero and indeed
>> that is never the case for size_t.
>>
>> This patch changes sysfs_get_uname() to return ssize_t and makes sure
>> its callers use ssize_t accordingly.
>
> So a similar fix has already been queued in tip/timers/core, but this
> seems more complete, so I've resolved the collisions with the earlier
> fix and queued it for 3.13.
>
> Would you please take a look at the resulting commit and double check I
> didn't flub the conflict resolution?
>
> https://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commitdiff;h=891292a767c2453af0e5be9465e95b06b4b29ebe;hp=b7bc50e45111e59419474154736f419a555158d9

Looks good.
