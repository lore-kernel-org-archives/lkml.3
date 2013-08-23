Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3HWIJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:09:57 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36418 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab3HWIJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:09:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAFgQCTuZ2ojrgvW3McDtrrVu06J1d9ssdfu4fD3Pb7rCYL2MHA@mail.gmail.com>
References: <1377161197-3175-1-git-send-email-pingfank@linux.vnet.ibm.com>
	<20130823073052.GA25533@gmail.com>
	<CAFgQCTuZ2ojrgvW3McDtrrVu06J1d9ssdfu4fD3Pb7rCYL2MHA@mail.gmail.com>
Date: Fri, 23 Aug 2013 16:09:49 +0800
Message-ID: <CAFgQCTtNmL7td-yqrUMe=H-6yxdA-7WSjCxzbeTTrsphEGWNwg@mail.gmail.com>
Subject: Re: [PATCH] x86: ioapic needs check attr when programmed more than once
From: Liu ping fan <kernelfans@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Kevin Hao <haokexin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 4:04 PM, Liu ping fan <kernelfans@gmail.com> wrote:
> On Fri, Aug 23, 2013 at 3:30 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Liu Ping Fan <kernelfans@gmail.com> wrote:
>>
>>> When programming ioapic pinX more than once, current code
>>> does not check whether the later attr (trigger&polarity) is the
>>> same as the former or not. This causes a broken semantic.
>>>
>>> Fix it by reporting -EBUSY, when attr is different.
>>
>> Was this observed in real life somehow, and if yes, what is
>> the before/after behavior?
>>
> Using qemu q35 machine, I found the ioapic's ioredtbl[] will never has
> low-active, even the hpet driver registered it. After tracing, I found
> it shared a high-level active IRQ line with other device. So in fact,
> the acpi_register_gsi(, ACPI_ACTIVE_LOW) in hpet driver fail, but it
> did not detect it.
> The effect in qemu: when hpet-dev assert low-level, the kernel can not respond.
>
After changing, I can observe the low-active be set in ioredtbl[x],
and with some bug fix in qemu's hpet, the kernel can work.
>
> Thanks,
> Pingfan
