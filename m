Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab3D2DSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 23:18:23 -0400
Received: from ozlabs.org ([203.10.76.45]:36450 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960Ab3D2DSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 23:18:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexander Graf <agraf@suse.de>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org,
        "linux-kernel\@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvmarm@lists.cs.columbia.edu, Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 0/2] Early printk support for virtio console devices.
In-Reply-To: <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de>
References: <1366974299-17877-1-git-send-email-pranavkumar@linaro.org> <BA2076A6-0688-4E5C-85F9-A9CA8FD75782@suse.de>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 29 Apr 2013 12:39:34 +0930
Message-ID: <87obcyc9sh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Graf <agraf@suse.de> writes:
> On 26.04.2013, at 13:04, Pranavkumar Sawargaonkar wrote:
>
>> This patch-set implements early printk support for virtio console devices without using any hypercalls.
>> 
>> The current virtio early printk code in kernel expects that hypervisor will provide some mechanism generally a hypercall to support early printk. This patch-set does not break existing hypercall based early print support.
>> 
>> This implementation adds:
>> 1. Early writeonly register named early_wr in virtio console's config space.
>> 2. Host feature flags namely VIRTIO_CONSOLE_F_EARLY_WRITE for telling guest about early-write capability in console device.
>> 
>> Early write mechanism:
>> 1. When a guest wants to out some character, it has to simply write the character to early_wr register in config space of virtio console device.
>
> I won't nack this patch set, but I'll definitely express that I'm not happy with it.
>
> MMIO registers are handled by a different layer than the virtio console itself. After the virtio refactoring in QEMU, they will be completely separate drivers. So we'll be in a similar mess with early printk as we are on the s390-virtio machine, where early printk is done through hypercalls and thus we can't directly link it to the console output.
>
> I still don't see what the issue is with just implementing a small irq-less virtio driver for early printk.

Well, this shouldn't be mmio-specific, but I kind of get what you mean.

I consider this misnamed: it's an emergency write facility.  Linux may
use it for an early console, but it's also useful for bringup and to
give a method of emitting errors like "the console ring is corrupt".

A valid implementation may well be to only offer it with some magic
qemu developer-only commandline and dump it to stdout.

So I think it has use, but less so if QEMU isn't ever going to implement
it.

Cheers,
Rusty.

