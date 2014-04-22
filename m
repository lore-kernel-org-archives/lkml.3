Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaDVKhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:37:16 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:50349 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaDVKhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <5354AD36.5090809@zytor.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<53518FAC.8020504@zytor.com>
	<201404191730.54400.arnd@arndb.de>
	<CAFiDJ5-PiUWetRMp65VTo4pvZM65r3WBjCZVWmxW0XnqAyO-GA@mail.gmail.com>
	<5354AD36.5090809@zytor.com>
Date: Tue, 22 Apr 2014 18:37:11 +0800
X-Google-Sender-Auth: GeEEtw8HwARADINclYmi5NYVqIo
Message-ID: <CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
From: Ley Foon Tan <lftan@altera.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and Peter Anvin,

Other than 64-bit time_t, clock_t and suseconds_t, can you confirm
that we don't need to have 64 bit off_t? See detail in link below.
I can submit the patches for 64-bit time changes
(include/asm-generic/posix_types.h and other archs) if everyone is
agreed on this.

Excerpt from https://lkml.org/lkml/2012/11/14/358 :
"Obviously, we want to use 64-bit off_t, but this is achieved already
through loff_t, which is used in all places in the asm-generic
ABI anyway (the syscalls using off_t are stripped out). I don't
think we want to have the other ones set to 64 bit on ARC or Meta,
although I'm not 100% sure about ino_t and nlink_t. "

Thanks.

Regards
Ley Foon

On Mon, Apr 21, 2014 at 1:31 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/20/2014 10:23 PM, Ley Foon Tan wrote:
>> On Sat, Apr 19, 2014 at 11:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Friday 18 April 2014, H. Peter Anvin wrote:
>>>> Did the generic headers ever get updated to match Linus' guidance that
>>>> any new architecture ports should use a 64-bit time_t?
>>>
>>> No, unfortunately not. With my rule that every architecture that gets
>>> added needs to clean up asm-generic some more, to make it easier to add
>>> the next one, we should probably do for nios2.
>>>
>>>         Arnd
>>
>> Can you give me the documentation on this new guidance and point me
>> any architecture have implemented this?
>> Thanks.
>>
>
> We implemented it in the x32 ABI for x86.  In generic code this is keyed
> by COMPAT_USE_64BIT_TIME, but in your case it isn't actually a matter of
> compat, so it should be easier.
>
> See this thread including the discussion about time_t:
>
> https://lkml.org/lkml/2011/8/26/415
>
>         -hpa
