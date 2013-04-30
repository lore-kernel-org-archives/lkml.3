Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab3D3Igs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:36:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37544 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab3D3Igq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:36:46 -0400
Message-ID: <517F829B.3080602@arm.com>
Date: Tue, 30 Apr 2013 09:36:43 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v3 0/6] Android Binder IPC Fixes
References: <1365769555-6052-1-git-send-email-serban.constantinescu@arm.com> <517E9CDB.3020906@arm.com> <CAMP5XgfRkG2Q74=e6p1ieHh3M6Nr67ykOBY234gZ_nUJ07U48A@mail.gmail.com>
In-Reply-To: <CAMP5XgfRkG2Q74=e6p1ieHh3M6Nr67ykOBY234gZ_nUJ07U48A@mail.gmail.com>
X-OriginalArrivalTime: 30 Apr 2013 08:36:42.0293 (UTC) FILETIME=[D722BE50:01CE457D]
X-MC-Unique: 113043009364401301
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arve,

On 30/04/13 00:13, Arve Hjønnevåg wrote:
> On Mon, Apr 29, 2013 at 9:16 AM, Serban Constantinescu
> <Serban.Constantinescu@arm.com> wrote:
>> Hi all,
>>
>> Any feedback or comments on this patch set?
>>
>
> You don't seem to have addressed my feedback on the previous patch set.

For v3 I have modified the following according to your review:

> Changes for v3:
> 1:  Dropped the patch that was replacing uint32_t types with unsigned int
> 2:  Dropped the patch fixing the IOCTL types(since it has been added to Greg's
>     staging tree)
> 3:  Split one patch into two: 'modify binder_write_read' and '64bit changes'
> 4:  Modified BINDER_SET_MAX_THREADS ioctl definition accordint to Arve's review
> 5:  Modified the binder command IOCTL declarations according to Arve's review

The following were left out:

> On 11/04/13 22:40, Arve Hjønnevåg wrote:
> OK, relaxing the alignment requirement for *offp to what the hardware
>> requires makes sense. Is there any macros in the kernel to help with
>> this, instead of hard-coding it to 4 bytes?

There is no kernel macro that I know which will help here(one that 
springs to mind is PTR_ALIGN but it aligns to (unsigned long) - we need 
one that aligns to (u32)). Any ideas?

> On 11/04/13 21:38, Arve Hjønnevåg wrote:
> OK, but if you are using this change let a 64 bit user-space know that
>> the driver has been fixed, then this patch needs to go after the
>> patches that change the structures on 64 bit systems.

For 32bit systems nothing has changed so they will continue to work as 
before. For 64bit systems the size of binder_version was signed long 
before the patch and __s32 after the patch is applied. Thus a 64bit 
system using the old interface will fail immediately after opening the 
binder driver, while cheeking the binder version (since the 
BINDER_VERSION ioctl will be different pre/post patch - size of 
binder_version differs).

For 64/32 systems once I will have the userspace wrapper ready I will 
add another ioctl(as discussed) that will check if the driver is 64bit 
ready(among the first things to do on binder_open).

Please let me know if there is anything that skipped my review and you 
would like to integrate in this patch set.

Thanks for your feedback and help,
Serban

