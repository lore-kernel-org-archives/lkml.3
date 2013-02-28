Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3B1XC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:02:28 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58759 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab3B1XC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:02:26 -0500
MIME-Version: 1.0
In-Reply-To: <512FC82B.40909@zytor.com>
References: <20130228205206.GC3438@sgi.com>
	<512FC697.3090608@zytor.com>
	<20130228210910.GD3438@sgi.com>
	<512FC82B.40909@zytor.com>
Date: Thu, 28 Feb 2013 15:02:25 -0800
X-Google-Sender-Auth: 373WHXMO-45uskoEDTN6-0Zm8kM
Message-ID: <CAE9FiQU3FBwEiC86N1RC8=aMdN09EbUmRcsWP0yof7bmxBhPew@mail.gmail.com>
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11 elilo.efi
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, hpa@sgi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/28/2013 01:09 PM, Robin Holt wrote:
>>>
>>> Sounds like ELILO needs to be fixed to pass the boot_params correctly.
>>>
>>> To support existing ELILO, it would be good to know exactly *which*
>>> fields ELILO pass in as garbage (because it does, that is why ->sentinel
>>> is nonzero) and use its bootloader ID to apply the proper brainwhack for
>>> the legacy versions.
>>
>> Any idea how I can dump that information?
>>
>
> Look at the source code and look at what fields it actually initializes.
>  Give us that list, and then we can work around elilo braindamage in the
> kernel.
>
> Then make it follow the boot spec:
>
>> In 32-bit boot protocol, the first step in loading a Linux kernel
>> should be to setup the boot parameters (struct boot_params,
>> traditionally known as "zero page"). The memory for struct boot_params
>> should be allocated and initialized to all zero. Then the setup header
>> from offset 0x01f1 of kernel image on should be loaded into struct
>> boot_params and examined. The end of setup header can be calculated as
>> follow:
>>
>>         0x0202 + byte value at offset 0x0201
>
> ... so we don't have to.

Good, kexec is not only one.

ELILO has one.
        5  ELILO

We need switch/case to have different fields set for it.

Thanks

Yinghai
