Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab3DVOvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:51:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037Ab3DVOvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:51:01 -0400
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <CALrVBkub+TABrrBwh4+P6S5TGL1qSmnZrd1cbGgj6JiRpY=rOA@mail.gmail.com>
Date: Mon, 22 Apr 2013 16:50:58 +0200
Cc: Rusty Russell <rusty@rustcorp.com.au>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <88344511-0EFA-4EA1-9793-5D25E8DA8239@suse.de>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org> <87wqs02uws.fsf@rustcorp.com.au> <CAAHg+HiHKV+8hBT1QWe4hSxocCX6wpRd3bCPWB7zU8jVFmPuAA@mail.gmail.com> <87ehe3bbsm.fsf@rustcorp.com.au> <CALrVBkub+TABrrBwh4+P6S5TGL1qSmnZrd1cbGgj6JiRpY=rOA@mail.gmail.com>
To: Anup Patel <anup.patel@linaro.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.04.2013, at 05:10, Anup Patel wrote:

> On 22 April 2013 06:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> 
>> Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
>>> On 18 April 2013 12:21, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>> 
>>>> PranavkumarSawargaonkar <pranavkumar@linaro.org> writes:
>>>>> From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>>>> 
>>>>> This patch implements early printk support for virtio-mmio console
>>>>> devices without using any hypercalls.
>>>> 
>>>> This makes some sense, though not sure that early console *read* makes
>>>> much sense.  I can see the PCI version of this being useful as well.
>>> 
>>> Read can be useful for "mach-virt" which will have only virtio console
>>> as a console device. Then if someone wants to have UEFI or any other
>>> boot-loader emulation, which expects user to input few things, in that
>>> case read might become handy.
>> 
>> But implementing virtio inside a bootloader has already been done for
>> coreboot, for example.  A bootloader probably wants a virtio block
>> device, so a console is trivial.
>> 
>> A single writable field for debugging makes sense.  Anything more is far
>> less certain.
> 
> The early read can be handy for bootloader who don't want to implement
> complete VirtIO programming.

Virtio is trivial. Seriously. Don't invent new secondary interfaces to the same thing just because you're afraid to write 5 lines of code instead of 2.


Alex

> 
> IMHO, early read would be totally optional for host and will not
> introduce any new config register so it is good to have in VirtIO
> console spec. Also, without early read the read behavior of early_rw
> field would be undefined in VirtIO console spec.
> 
>> 
>> Thanks,
>> Rusty.
> 
> Best Regards,
> Anup
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/cucslists/listinfo/kvmarm

