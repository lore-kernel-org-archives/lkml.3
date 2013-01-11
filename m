Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3AKWDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:03:14 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:61950 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab3AKWDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:03:13 -0500
MIME-Version: 1.0
In-Reply-To: <1357940918-14941-1-git-send-email-john.stultz@linaro.org>
References: <1357940918-14941-1-git-send-email-john.stultz@linaro.org>
Date: Fri, 11 Jan 2013 14:03:12 -0800
Message-ID: <CAMbhsRQaniTFN+HF0Tyjn57Sjq=rh5MQRTBg1RZyGcU1FV7ySQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] staging: alarm-dev: compat_ioctl support
From: Colin Cross <ccross@google.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 1:48 PM, John Stultz <john.stultz@linaro.org> wrote:
> This is a first-pass at implementing compat_ioctl support for
> Android's alarm-dev driver in staging.
>
> The first patch is some refactoring to cleanup and separate the
> copying of user data from the logic, and the second patch adds
> the compat_ioctl support.
>
> As noted in the patch, the only really squirly bit is the handling
> of ANDROID_ALARM_SET_OLD and ANDROID_ALARM_SET_AND_WAIT_OLD. These
> are present to support existing older Android applications.
> Unfortunately these cause ioctl number aliasing issues with
> the compat ioctls, so on 64bit they are only supported in the
> compat patch (since any existing android app old enough to use
> them are likely 32bit).
>
> I'd appreciate feedback from the Android devs on if this is
> an ok assumption and if it might be reasonable to establish
> some sort of a phase-out timeline for the _OLD ioctl support.

The "support old userspace code" comment for those two ioctls has been
there since pre-Android 1.0.  Those apis are not exposed to Android
apps, I don't see any problem deleting them.
