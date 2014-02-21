Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaBUV37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:29:59 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58730 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaBUV36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:29:58 -0500
Message-ID: <5307C553.9040504@linaro.org>
Date: Fri, 21 Feb 2014 13:29:55 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 2/3] staging: binder: Support concurrent 32 bit and 64
 bit processes.
References: <1393015414-12499-1-git-send-email-john.stultz@linaro.org>	<1393015414-12499-3-git-send-email-john.stultz@linaro.org> <CAMP5Xgf1cMUEk5Z3KQvnUNTzvo12URYX_w4m+SyH8WEF=1kKhg@mail.gmail.com>
In-Reply-To: <CAMP5Xgf1cMUEk5Z3KQvnUNTzvo12URYX_w4m+SyH8WEF=1kKhg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 12:59 PM, Arve Hjønnevåg wrote:
> On Fri, Feb 21, 2014 at 12:43 PM, John Stultz <john.stultz@linaro.org> wrote:
>> From: Arve Hjønnevåg <arve@android.com>
>>
>> For 64bit systems we want to use the same binder interface for 32bit and
>> 64bit processes. Thus the size and the layout of the structures passed
>> between the kernel and the userspace has to be the same for both 32 and
>> 64bit processes.
>>
>> This change replaces all the uses of void* and size_t with
>> binder_uintptr_t and binder_size_t. These are then typedefed to specific
>> sizes depending on the use of the interface, as follows:
>>        * __u32 - on legacy 32bit only userspace
>>        * __u64 - on mixed 32/64bit userspace where all processes use the same
>> interface.
>>
>> This change also increments the BINDER_CURRENT_PROTOCOL_VERSION to 8 and
>> hooks the compat_ioctl entry for the mixed 32/64bit Android userspace.
>>
> It only increments the version to 8 if the old 32 bit interface is not selected.
>
>> This patch also provides a CONFIG_ANDROID_BINDER_IPC_32BIT option for
>> compatability, which if set which enables the old protocol on 32 bit
>> systems.

Ok. I thought that point was covered by the detail on
CONFIG_ANDROID_BINDER_IPC_32BIT, but maybe its not explicit enough.

Would you be ok with:

This change also increments the BINDER_CURRENT_PROTOCOL_VERSION to 8 and
hooks the compat_ioctl entry for the mixed 32/64bit Android userspace.

This patch also provides a CONFIG_ANDROID_BINDER_IPC_32BIT option for
compatability, which if set which enables the old protocol, setting
BINDER_CURRENT_PROTOCOL_VERSION to 7, on 32 bit systems.

?

thanks
-john
