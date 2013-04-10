Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936877Ab3DJVue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:50:34 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54711 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762364Ab3DJVud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:50:33 -0400
MIME-Version: 1.0
In-Reply-To: <51655D16.1020908@arm.com>
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com>
	<1365501657-4213-5-git-send-email-serban.constantinescu@arm.com>
	<CAMP5Xgfb2NYN8j16XKx3hrvk1gnRCX+yx2Uk_fxSE=OM74y5fQ@mail.gmail.com>
	<51655D16.1020908@arm.com>
Date: Wed, 10 Apr 2013 14:50:32 -0700
Message-ID: <CAMP5Xgdd_o3G-bTjeGPaX9o6+6z26DnBuvkNO_mRbkOiL5P2ZA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] staging: android: binder: fix BINDER_SET_MAX_THREADS
 declaration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 5:37 AM, Serban Constantinescu
<Serban.Constantinescu@arm.com> wrote:
> On 10/04/13 00:53, Arve Hjønnevåg wrote:
>>
>> On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
>> <serban.constantinescu@arm.com> wrote:
>>>
>>> This change will fix the BINDER_SET_MAX_THREADS ioctl to use __s32
>>> instead of size_t for setting the max threads. Thus using the same
>>> handler for 32 and 64bit kernels.
>>>
>>> This value is stored internally in struct binder_proc as an int and
>>> is set to 15 on open_binder() in the libbinder API (thus no need for
>>> a 64bit size_t on 64bit platforms).
>>>
>>
>> Why switch to a signed type?
>
>
> The value passed through BINDER_SET_MAX_THREADS ioctl is stored in a
> binder_proc structure as an int.It also mimics the use of pid_t(typedef int
> __kernel_pid_t).
>

This is a thread count not a pid.

> However using __s32 or __u32 here would have the same effect since the ioctl
> macro will compute both as sizeof(32bit).
>
> Let me know if you would like this changed to __u32.
>

The user-space api uses a size_t, so __u32 would be a closer match.
Keeping it a size_t would also work since this value is not shared
between processes.

--
Arve Hjønnevåg
