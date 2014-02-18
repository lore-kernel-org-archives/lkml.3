Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaBRTnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:43:18 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:65119 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaBRTnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:43:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140218191043.GC10376@kroah.com>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
	<1392674322-9036-14-git-send-email-john.stultz@linaro.org>
	<20140218191043.GC10376@kroah.com>
Date: Tue, 18 Feb 2014 11:43:15 -0800
Message-ID: <CALAqxLVdViWuRbFy=HzwfkTQaj9X3OKbELx8TqakWN9B2na5mw@mail.gmail.com>
Subject: Re: [PATCH 13/14] staging: binder: Support concurrent 32 bit and 64
 bit processes.
From: John Stultz <john.stultz@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:10 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Feb 17, 2014 at 01:58:41PM -0800, John Stultz wrote:
>> From: Arve Hjønnevåg <arve@android.com>
>>
>> Add binder_size_t and binder_uintptr_t that is used instead of size_t and
>> void __user * in the user-space interface.
>>
>> Use 64 bit pointers on all systems unless CONFIG_ANDROID_BINDER_IPC_32BIT
>> is set (which enables the old protocol on 32 bit systems).
>>
>> Change BINDER_CURRENT_PROTOCOL_VERSION to 8 if
>> CONFIG_ANDROID_BINDER_IPC_32BIT is not set.
>>
>> Add compat ioctl.
>>
>> Cc: Colin Cross <ccross@android.com>
>> Cc: Arve Hjønnevåg <arve@android.com>
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Signed-off-by: Arve Hjønnevåg <arve@android.com>
>> [jstultz: Merged with upstream type changes. Tweaked commit message.
>> Various whitespace fixes and longer Kconfig description for checkpatch]
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>
> Ok, I see that Arve has signed off on this, why the Cc: above to confuse
> me?  :)

Apologies for the confusion. These are definitely big changes that
landed recently.

> Anyway, what about the ARM patches that this was based on?  And why the
> previous patch that breaks things on its own?

So, the previous change was making the now-old 32bit binder api
consistent on 64bit, and then this change converts binder api to the
new 64bit API, which will break existing 32bit binder users. Because
of this, they provide a CONFIG_ANDROID_BINDER_IPC_32BIT option which
switches back to the old ABI for current userspace users.

But yea, I'm fine resubmitting these independently. I'll also work
with Serban to see if we can expand the commit message to be more
clear.

thanks
-john
