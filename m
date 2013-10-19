Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3JSAQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 20:16:06 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45478 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3JSAQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 20:16:04 -0400
Message-ID: <5261CF41.6050300@linaro.org>
Date: Fri, 18 Oct 2013 17:16:01 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Patrick Palka <patrick@parcs.ath.cx>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: Fix signedness bug in sysfs_get_uname() and its
 callers
References: <1381511515-2577-1-git-send-email-patrick@parcs.ath.cx>
In-Reply-To: <1381511515-2577-1-git-send-email-patrick@parcs.ath.cx>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 10:11 AM, Patrick Palka wrote:
> sysfs_get_uname() is erroneously declared as returning size_t even
> though it may return a negative value, specifically -EINVAL.  Its
> callers then check whether its return value is less than zero and indeed
> that is never the case for size_t.
>
> This patch changes sysfs_get_uname() to return ssize_t and makes sure
> its callers use ssize_t accordingly.

So a similar fix has already been queued in tip/timers/core, but this
seems more complete, so I've resolved the collisions with the earlier
fix and queued it for 3.13.

Would you please take a look at the resulting commit and double check I
didn't flub the conflict resolution?

https://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commitdiff;h=891292a767c2453af0e5be9465e95b06b4b29ebe;hp=b7bc50e45111e59419474154736f419a555158d9

thanks
-john


