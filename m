Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3DVDK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 23:10:58 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:62229 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3DVDK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 23:10:57 -0400
MIME-Version: 1.0
In-Reply-To: <87ehe3bbsm.fsf@rustcorp.com.au>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
	<87wqs02uws.fsf@rustcorp.com.au>
	<CAAHg+HiHKV+8hBT1QWe4hSxocCX6wpRd3bCPWB7zU8jVFmPuAA@mail.gmail.com>
	<87ehe3bbsm.fsf@rustcorp.com.au>
Date: Mon, 22 Apr 2013 08:40:56 +0530
Message-ID: <CALrVBkub+TABrrBwh4+P6S5TGL1qSmnZrd1cbGgj6JiRpY=rOA@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
From: Anup Patel <anup.patel@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 April 2013 06:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
> > On 18 April 2013 12:21, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >>
> >> PranavkumarSawargaonkar <pranavkumar@linaro.org> writes:
> >> > From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
> >> >
> >> > This patch implements early printk support for virtio-mmio console
> >> > devices without using any hypercalls.
> >>
> >> This makes some sense, though not sure that early console *read* makes
> >> much sense.  I can see the PCI version of this being useful as well.
> >
> > Read can be useful for "mach-virt" which will have only virtio console
> > as a console device. Then if someone wants to have UEFI or any other
> > boot-loader emulation, which expects user to input few things, in that
> > case read might become handy.
>
> But implementing virtio inside a bootloader has already been done for
> coreboot, for example.  A bootloader probably wants a virtio block
> device, so a console is trivial.
>
> A single writable field for debugging makes sense.  Anything more is far
> less certain.

The early read can be handy for bootloader who don't want to implement
complete VirtIO programming.

IMHO, early read would be totally optional for host and will not
introduce any new config register so it is good to have in VirtIO
console spec. Also, without early read the read behavior of early_rw
field would be undefined in VirtIO console spec.

>
> Thanks,
> Rusty.

Best Regards,
Anup
