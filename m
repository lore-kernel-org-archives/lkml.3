Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbaBUWf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:35:29 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63007 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaBUWf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:35:28 -0500
Message-ID: <5307D4AC.9090405@linaro.org>
Date: Fri, 21 Feb 2014 14:35:24 -0800
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
References: <1393015414-12499-1-git-send-email-john.stultz@linaro.org>	<1393015414-12499-3-git-send-email-john.stultz@linaro.org>	<CAMP5Xgf1cMUEk5Z3KQvnUNTzvo12URYX_w4m+SyH8WEF=1kKhg@mail.gmail.com>	<5307C553.9040504@linaro.org>	<CAMP5XgciqfYJEML8Rhb0w2pk6gboOciK2rczEc4ZdDC_-pgkNQ@mail.gmail.com>	<5307CD6B.4090702@linaro.org> <CAMP5XgdYF-zHmoXN1LMrRDzcacv2UAXiVxYc7AoA+BrURSDk+A@mail.gmail.com>
In-Reply-To: <CAMP5XgdYF-zHmoXN1LMrRDzcacv2UAXiVxYc7AoA+BrURSDk+A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 02:10 PM, Arve Hjønnevåg wrote:
> On Fri, Feb 21, 2014 at 2:04 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On 02/21/2014 01:56 PM, Arve Hjønnevåg wrote:
>>> On Fri, Feb 21, 2014 at 1:29 PM, John Stultz <john.stultz@linaro.org> wrote:
>>>> On 02/21/2014 12:59 PM, Arve Hjønnevåg wrote:
>>>>> On Fri, Feb 21, 2014 at 12:43 PM, John Stultz <john.stultz@linaro.org> wrote:
>>>>>> From: Arve Hjønnevåg <arve@android.com>
>>>>>>
>>>>>> For 64bit systems we want to use the same binder interface for 32bit and
>>>>>> 64bit processes. Thus the size and the layout of the structures passed
>>>>>> between the kernel and the userspace has to be the same for both 32 and
>>>>>> 64bit processes.
>>>>>>
>>>>>> This change replaces all the uses of void* and size_t with
>>>>>> binder_uintptr_t and binder_size_t. These are then typedefed to specific
>>>>>> sizes depending on the use of the interface, as follows:
>>>>>>        * __u32 - on legacy 32bit only userspace
>>>>>>        * __u64 - on mixed 32/64bit userspace where all processes use the same
>>>>>> interface.
>>>>>>
>>>>>> This change also increments the BINDER_CURRENT_PROTOCOL_VERSION to 8 and
>>>>>> hooks the compat_ioctl entry for the mixed 32/64bit Android userspace.
>>>>>>
>>>>> It only increments the version to 8 if the old 32 bit interface is not selected.
>>>>>
>>>>>> This patch also provides a CONFIG_ANDROID_BINDER_IPC_32BIT option for
>>>>>> compatability, which if set which enables the old protocol on 32 bit
>>>>>> systems.
>>>> Ok. I thought that point was covered by the detail on
>>>> CONFIG_ANDROID_BINDER_IPC_32BIT, but maybe its not explicit enough.
>>>>
>>>> Would you be ok with:
>>>>
>>>> This change also increments the BINDER_CURRENT_PROTOCOL_VERSION to 8 and
>>>> hooks the compat_ioctl entry for the mixed 32/64bit Android userspace.
>>>>
>>>> This patch also provides a CONFIG_ANDROID_BINDER_IPC_32BIT option for
>>>> compatability, which if set which enables the old protocol, setting
>>>> BINDER_CURRENT_PROTOCOL_VERSION to 7, on 32 bit systems.
>>>>
>>>> ?
>>>>
>>> Yes, but replacing "This change" with "Selecting the 64 bit interface"
>>> would also work.
>> Ok.. I might stick to my wording above since with this patch, the 64bit
>> interface is now the unconditional case, with the 32bit interface having
>> the config option. So it might be more clear as there is no 64bit
>> interface option to select.
>>
>> I'll add that bit and resend. Everything else in the patch series ok by you?
>>
> Assuming you did not change the code, yes.

Nothing but whitespace formatting for checkpatch as noted in the commit log.

After these three patches, the binder diff from android-3.10 is only
whitespace and the SELinux "Add security hooks to binder" patch which
makes changes out of the staging directory.

thanks
-john

