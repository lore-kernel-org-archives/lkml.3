Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3D2QQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:16:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43592 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab3D2QQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:16:32 -0400
Message-ID: <517E9CDB.3020906@arm.com>
Date: Mon, 29 Apr 2013 17:16:27 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "arve@android.com" <arve@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v3 0/6] Android Binder IPC Fixes
References: <1365769555-6052-1-git-send-email-serban.constantinescu@arm.com>
In-Reply-To: <1365769555-6052-1-git-send-email-serban.constantinescu@arm.com>
X-OriginalArrivalTime: 29 Apr 2013 16:16:27.0818 (UTC) FILETIME=[E6FA10A0:01CE44F4]
X-MC-Unique: 113042917163005301
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Any feedback or comments on this patch set?

Thanks,
Serban


On 12/04/13 13:25, Serban Constantinescu wrote:
> Hi all,
>
> This set of patches will clean-up and fix some of the issues that arise
> with the current binder interface when moving to a 64bit kernel. All these
> changes will not affect the existing 32bit Android interface and are meant
> to stand as the base for the 64bit binder compat layer(kernel or userpsace).
>
> The patch set has been successfully tested with a 64bit Linux userspace and
> 64bit binder unit-tests.
>
> This patch set has been successfully tested on 32bit platforms(ARMv7 VExpress)
> and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an in
> kernel binder compat layer.
>
> Changes for v3:
> 1:  Dropped the patch that was replacing uint32_t types with unsigned int
> 2:  Dropped the patch fixing the IOCTL types(since it has been added to Greg's
>      staging tree)
> 3:  Split one patch into two: 'modify binder_write_read' and '64bit changes'
> 4:  Modified BINDER_SET_MAX_THREADS ioctl definition accordint to Arve's review
> 5:  Modified the binder command IOCTL declarations according to Arve's review
>
> Changes for v2:
> 1: 1/7: Modified the commit message according to Greg's feedback;
> 2: 3/7: Merged with the patch fixing the printk format specifiers.
>
> Serban Constantinescu (6):
>    staging: android: binder: modify struct binder_write_read to use
>      size_t
>    staging: android: binder: fix binder interface for 64bit compat layer
>    staging: android: binder: fix BINDER_SET_MAX_THREADS declaration
>    staging: android: binder: fix BC_FREE_BUFFER ioctl declaration
>    staging: android: binder: fix alignment issues
>    staging: android: binder: replace types with portable ones
>
>   drivers/staging/android/binder.c |   40 ++++++++++++++++-----------------
>   drivers/staging/android/binder.h |   46 +++++++++++++++++++-------------------
>   2 files changed, 43 insertions(+), 43 deletions(-)
>

