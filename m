Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbbA0JYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:24:23 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:65516 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbbA0JYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:24:20 -0500
Message-ID: <1422350658.14015.9.camel@x220>
Subject: Re: [PATCH 1/2][RFC] staging: Remove the Android alarm-dev driver
From: Paul Bolle <pebolle@tiscali.nl>
To: John Stultz <john.stultz@linaro.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-kernel@vger.kernel.org, Greg Hackmann <ghackmann@google.com>,
        Elliott Hughes <enh@google.com>, Todd Poynor <toddpoynor@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 27 Jan 2015 10:24:18 +0100
In-Reply-To: <1421790155-3309-1-git-send-email-john.stultz@linaro.org>
References: <1421790155-3309-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2015 09:24:18.0415 (UTC) FILETIME=[06A71FF0:01D03A13]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 13:42 -0800, John Stultz wrote:
> The functionality provided by the Android alarm-dev driver
> should now be present in the timerfd interface (thanks to
> Greg Hackmann and Todd Poynor).
> 
> As of Lollipop, AOSP can make use of the timerfd if
> alarm-dev is not present (though a fixup for setting the
> rtc time if rtc0 isn't the backing for _ALARM clockids has
> been applied post-Lollipop).
> 
> Thus, we should be able to remove alarm-dev from staging.
> 
> Cc: Greg Hackmann <ghackmann@google.com>
> Cc: Elliott Hughes <enh@google.com>
> Cc: Todd Poynor <toddpoynor@google.com>
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

This became commit 5da41e925656 ("staging: Remove the Android alarm-dev
driver") in today's linux-next (ie, next-20150127). I noticed because a
script I use to check linux-next spotted a minor problem with it.

>  drivers/staging/android/Kconfig              |   9 -

Here there should have been a line reading
   drivers/staging/android/Makefile             |   1 -  

>  drivers/staging/android/alarm-dev.c          | 446 ---------------------------
>  drivers/staging/android/android_alarm.h      |  41 ---
>  drivers/staging/android/uapi/android_alarm.h |  62 ----
>  4 files changed, 558 deletions(-)
>  delete mode 100644 drivers/staging/android/alarm-dev.c
>  delete mode 100644 drivers/staging/android/android_alarm.h
>  delete mode 100644 drivers/staging/android/uapi/android_alarm.h

Is a trivial patch to remove that Makefile line, the one that references
CONFIG_ANDROID_INTF_ALARM_DEV and alarm-dev.o, queued already?

Thanks,


Paul Bolle

