Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaG3R6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:58:22 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:42651 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbaG3R6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:58:20 -0400
MIME-Version: 1.0
In-Reply-To: <1405041854-17902-1-git-send-email-hyogi.gim@lge.com>
References: <1405041854-17902-1-git-send-email-hyogi.gim@lge.com>
Date: Wed, 30 Jul 2014 10:58:17 -0700
Message-ID: <CALAqxLWcX9DV=1W7D9GNLz2UHvy7neFywuzpc32UfXTnNfvMmg@mail.gmail.com>
Subject: Re: [PATCH] alarmtimer: Add the verification code for rtc device error.
From: John Stultz <john.stultz@linaro.org>
To: Hyogi Gim <hyogi.gim@lge.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 6:24 PM, Hyogi Gim <hyogi.gim@lge.com> wrote:
> In alarmtimer_suspend(), the error after rtc_read_time() is not checked.
> If rtc device fail to read rtc time, we cannot ensure the following process.
>
> Furthermore, the return value of rtc_timer_start() needs to distinguish
> -ETIME and other rtc device error. If the error is relevant to rtc device,
> suspend is failed unintentionally. In this case, it just returns zero for
> a stable suspend. Otherwise, in the worst case, suspend will fail continually.


Hey! Sorry for the late response here.

So this seems reasonable as always failing suspend is problematic, but
I worry that for the case where we do have a failure to read or set
the RTC, we'd suspend and not wake up as specified, which is an issue
as well. Absorbing the error silently in these cases would make it
difficult to debug. Should we at least print some output out to help
folks hunt down this sort of issue?

thanks
-john
