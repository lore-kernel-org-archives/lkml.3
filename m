Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936145Ab3DJMhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:37:47 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43312 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab3DJMhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:37:46 -0400
Message-ID: <51655D16.1020908@arm.com>
Date: Wed, 10 Apr 2013 13:37:42 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v2 4/7] staging: android: binder: fix BINDER_SET_MAX_THREADS
 declaration
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com> <1365501657-4213-5-git-send-email-serban.constantinescu@arm.com> <CAMP5Xgfb2NYN8j16XKx3hrvk1gnRCX+yx2Uk_fxSE=OM74y5fQ@mail.gmail.com>
In-Reply-To: <CAMP5Xgfb2NYN8j16XKx3hrvk1gnRCX+yx2Uk_fxSE=OM74y5fQ@mail.gmail.com>
X-OriginalArrivalTime: 10 Apr 2013 12:37:41.0049 (UTC) FILETIME=[30F6D290:01CE35E8]
X-MC-Unique: 113041013374406901
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 00:53, Arve Hjønnevåg wrote:
> On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
> <serban.constantinescu@arm.com> wrote:
>> This change will fix the BINDER_SET_MAX_THREADS ioctl to use __s32
>> instead of size_t for setting the max threads. Thus using the same
>> handler for 32 and 64bit kernels.
>>
>> This value is stored internally in struct binder_proc as an int and
>> is set to 15 on open_binder() in the libbinder API (thus no need for
>> a 64bit size_t on 64bit platforms).
>>
>
> Why switch to a signed type?

The value passed through BINDER_SET_MAX_THREADS ioctl is stored in a 
binder_proc structure as an int.It also mimics the use of pid_t(typedef 
int __kernel_pid_t).

However using __s32 or __u32 here would have the same effect since the 
ioctl macro will compute both as sizeof(32bit).

Let me know if you would like this changed to __u32.

Thanks,
Serban

