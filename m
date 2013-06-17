Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3FQWUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:20:18 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60448 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3FQWUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:20:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130617084033.GC2718@n2100.arm.linux.org.uk>
References: <1371429799-7128-1-git-send-email-grant.likely@linaro.org> <20130617084033.GC2718@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 17 Jun 2013 23:19:53 +0100
X-Google-Sender-Auth: e_MVSTXm3TFarsF8RfCVnJJIpz8
Message-ID: <CACxGe6sdW6O7WpE3p2GAfVHqnBKaazwCFd-HV2L3gm1q6bv9Xw@mail.gmail.com>
Subject: Re: [RFC] arm: Remove sa1111 special case from arm_mm_memblock_reserve()
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 9:40 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jun 17, 2013 at 01:43:19AM +0100, Grant Likely wrote:
>> The machine desc structure has a hook for doing machine-specific
>> memblock code, but the SA1111 still has a platform-specific hook in the
>> generic code. This patch merely moves the needed memblock_reserve()
>> into a callback.
>
> And... the reason I left this in generic code was to avoid the problem
> which you've created by doing this change - there is at least one PXA
> platform which also can have SA1111 enabled, and by omitting this
> reservation, you will make that platform blow up at boot time because
> we will try and free the same region of RAM twice into the buddy
> allocator.
>
> It was left there because one of these currently has to stay in generic
> code, so they both need to in order to ensure that both are properly
> paired.
>
> What problem, other than a distaste for having such things in generic
> code, are you having with this?

Merely trying to clean up generic code. That's all. It was something I
noticed that would be nice to clean up. I could remove it I suppose by
adding a new machine_desc hook, but it's not worth adding another
callback for exactly one user. I'm not going to bother spending any
more time on this.

g.
