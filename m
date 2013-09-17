Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3IQAGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 20:06:15 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:60010 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3IQAGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 20:06:11 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1379346848.1934.13.camel@joe-AO722>
References: <1378960909-15773-1-git-send-email-olof@lixom.net>
	<20130916151716.GA5613@ulmo>
	<CAOesGMjUeyKDtNU+zVpPYWyQX8ESoUhqaHXLuW5jJ=u2ggEb5A@mail.gmail.com>
	<1379346848.1934.13.camel@joe-AO722>
Date: Mon, 16 Sep 2013 17:06:10 -0700
Message-ID: <CAOesGMjK47GfxQ6-xxZ36aU7k6i3s5uecNpVFsdEbfULnLxWOQ@mail.gmail.com>
Subject: Re: [PATCH] gpu: host1x: use %pa to print dma_addr_t
From: Olof Johansson <olof@lixom.net>
To: Joe Perches <joe@perches.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>,
        dri-devel@lists.freedesktop.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 8:54 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2013-09-16 at 08:46 -0700, Olof Johansson wrote:
>> On Mon, Sep 16, 2013 at 8:17 AM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>> > On Wed, Sep 11, 2013 at 09:41:49PM -0700, Olof Johansson wrote:
>> >> This removes two warnings where dma_addr_t variables were printed using
>> >> %x when built with CONFIG_ARM_LPAE=y, thus having 64-bit dma_addr_t:
>> >>
>> >>   drivers/gpu/host1x/hw/cdma_hw.c:57:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t'
>> >>   drivers/gpu/host1x/hw/debug_hw.c:175:10: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t'
>> >
>> > Hi Olof,
>> >
>> > I can't reproduce this. Does this perhaps depend on some other patch?
>> > When I enable LPAE I do see similar warnings in drivers/iommu/tegra-*.c
>> > and those can indeed be fixed using an equivalent patch.
>>
>> You need to enable LPAE on a platform that also selects
>> ARCH_DMA_ADDR_T_64BIT, I don't think tegra does. If you do it with
>> multi_v7_defconfig you'll see them.
>>
>> However, see discussion on another of the emails in the series; I'll
>> have to introduce a new format specifier instead.
>
> Or not.
>
> I don't know whether or not the dma_addr_t really needs a
> fixed 18 byte output length for 64 bit uses.
>
> I think always using a cast for dma_addr_t addresses like:
>
>         printk("dma_addr_t: %#llx\n", (u64)addr);
>
> would probably work just fine.

Sigh. Any color would do. I just want to get rid of the mostly-bogus
warnings that makes it harder to spot real problems, I really don't
care how they're resolved.

None of the affected platforms today use 64-bit DMA anyway, so casting
down to u32 is equally acceptable. I'll repost with that instead.


-Olof
