Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3DVB71 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 21:59:27 -0400
Received: from ozlabs.org ([203.10.76.45]:51939 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab3DVB70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 21:59:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
In-Reply-To: <CAAHg+HiHKV+8hBT1QWe4hSxocCX6wpRd3bCPWB7zU8jVFmPuAA@mail.gmail.com>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org> <87wqs02uws.fsf@rustcorp.com.au> <CAAHg+HiHKV+8hBT1QWe4hSxocCX6wpRd3bCPWB7zU8jVFmPuAA@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Apr 2013 10:51:13 +0930
Message-ID: <87ehe3bbsm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
> On 18 April 2013 12:21, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> PranavkumarSawargaonkar <pranavkumar@linaro.org> writes:
>> > From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>> >
>> > This patch implements early printk support for virtio-mmio console devices without using any hypercalls.
>>
>> This makes some sense, though not sure that early console *read* makes
>> much sense.  I can see the PCI version of this being useful as well.
>
> Read can be useful for "mach-virt" which will have only virtio console
> as a console device. Then if someone wants to have UEFI or any other
> boot-loader emulation, which expects user to input few things, in that
> case read might become handy.

But implementing virtio inside a bootloader has already been done for
coreboot, for example.  A bootloader probably wants a virtio block
device, so a console is trivial.

A single writable field for debugging makes sense.  Anything more is far
less certain.

Thanks,
Rusty.
