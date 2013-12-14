Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3LNXPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 18:15:21 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37654 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3LNXPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 18:15:18 -0500
MIME-Version: 1.0
In-Reply-To: <52ACD955.6090900@linaro.org>
References: <20131214170618.GA17461@kroah.com>
	<1387051606-10440-1-git-send-email-john.stultz@linaro.org>
	<20131214214820.GA26981@kroah.com>
	<52ACD955.6090900@linaro.org>
Date: Sat, 14 Dec 2013 15:15:17 -0800
X-Google-Sender-Auth: NSK_9aKQ8kwR_8nhP-AhEQSOy1s
Message-ID: <CAMbhsRRW+zPBSTFAWtK+9Vr=5ZJYzF7B0EVT69anurZxiDYmSg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ion: Don't allow building ION as a module.
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 2:19 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 12/14/2013 01:48 PM, Greg KH wrote:
>> On Sat, Dec 14, 2013 at 12:06:45PM -0800, John Stultz wrote:
>>> ION doesn't export the proper symbols for it to be a module. This
>>> causes build issues when ION is configured as a module.
>>>
>>> Since Andorid kernels rarely use modules (I think recent policy
>>> requires no modules?), go ahead and set the ION config to a bool
>>> from the tristate option.
>>>
>>> If folks decide ION as a module is important, we will have to go
>>> through and export the various needed symbols.
>>>
>>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>> ---
>>>  drivers/staging/android/ion/Kconfig | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
>>> index a342d96..b95281e 100644
>>> --- a/drivers/staging/android/ion/Kconfig
>>> +++ b/drivers/staging/android/ion/Kconfig
>>> @@ -1,5 +1,5 @@
>>>  menuconfig ION
>>> -    tristate "Ion Memory Manager"
>>> +    bool "Ion Memory Manager"
>> Or you can do:
>>       depends on m
>> and leave it as a "tristate", then when switching it off, I think you
>> can then be prompted as 'm' again, but I could be wrong about that.
>>
>> So should ION ever be able to be built as a module in the future?
> My understanding is that Android is moving away from using modules, but
> others could comment more authoritatively. So I don't think this is an
> issue. But as I said in the patch, if folks do want to have ION as a
> module, we'll have to export all the various symbols that ION users need.

There's no reason ION couldn't be built as a module, it just doesn't
make much sense given how central it is to the Android devices it is
used on.  It will need some TODOs fixed in the removal paths, and
probably some refcounting to prevent removing the module while buffers
are allocated.

As for modules in general on Android, they are rarely used on ARM
Android devices and were considered a security risk.  I don't think
anybody would have a problem re-enabling them if
CONFIG_MODULE_SIG_FORCE was also enabled.
