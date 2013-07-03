Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab3GCWdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 18:33:00 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35652 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab3GCWc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 18:32:59 -0400
MIME-Version: 1.0
In-Reply-To: <51D452BC.8060905@arm.com>
References: <1371661956-10894-1-git-send-email-serban.constantinescu@arm.com>
	<51D452BC.8060905@arm.com>
Date: Wed, 3 Jul 2013 15:32:58 -0700
Message-ID: <CAMP5Xgcyov5OUgcGq9AmFvtdRMJ8+fJ1a6Dna-zeDLSZexk=_A@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Android Binder IPC Fixes
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 9:35 AM, Serban Constantinescu
<Serban.Constantinescu@arm.com> wrote:
> Hi all,
>
> Any feedback or comments on this patch set?
>
> Thanks,
> Serban
>

The new patches look OK, but I would like to also see the patches that
add support for 32 bit user-space on a 64 bit kernel.


>
> On 19/06/13 18:12, Serban Constantinescu wrote:
>>
>> Hi all,
>>
>> This set of patches will clean-up and fix some of the issues that arise
>> with the current binder interface when moving to a 64bit kernel. All these
>> changes will not affect the existing 32bit Android interface and are meant
>> to stand as the base for the 64bit binder compat layer(kernel or
>> userpsace).
>>
>> The patch set has been successfully tested with a 64bit Linux userspace
>> and
>> 64bit binder unit-tests.
>>
>> This patch set has been successfully tested on 32bit platforms(ARMv7
>> VExpress)
>> and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an
>> in
>> kernel binder compat layer.
>>
>> Changes for v5:
>> 1 6/6: Moved patch to the end of the series; changed handle to use __u32
>> type
>> 2 4/6: Removed some of the alignment/buffer changes introduced in previous
>>         versions of the patch.
>>
>> Changes for v4:
>> 1: 5/6: Fix the offset buffer alignment such that it will work for cases
>> where
>> buffer start + buffer size are not aligned to (void *)
>>
>> Changes for v3:
>> 1:  Dropped the patch that was replacing uint32_t types with unsigned int
>> 2:  Dropped the patch fixing the IOCTL types(since it has been added to
>> Greg's
>>      staging tree)
>> 3:  Split one patch into two: 'modify binder_write_read' and '64bit
>> changes'
>> 4:  Modified BINDER_SET_MAX_THREADS ioctl definition accordint to Arve's
>> review
>> 5:  Modified the binder command IOCTL declarations according to Arve's
>> review
>>
>> Changes for v2:
>> 1: 1/7: Modified the commit message according to Greg's feedback;
>> 2: 3/7: Merged with the patch fixing the printk format specifiers.
>>
>> Serban Constantinescu (6):
>>    staging: android: binder: modify struct binder_write_read to use
>>      size_t
>>    staging: android: binder: fix BINDER_SET_MAX_THREADS declaration
>>    staging: android: binder: fix BC_FREE_BUFFER ioctl declaration
>>    staging: android: binder: fix alignment issues
>>    staging: android: binder: replace types with portable ones
>>    staging: android: binder: fix binder interface for 64bit compat layer
>>
>>   drivers/staging/android/binder.c |   32 ++++++++++++-------------
>>   drivers/staging/android/binder.h |   48
>> +++++++++++++++++++-------------------
>>   2 files changed, 40 insertions(+), 40 deletions(-)
>>
>
>
> --
> Best Regards,
>
> Serban Constantinescu
> PDSW Engineer ARM Ltd.
>



--
Arve Hjønnevåg
