Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab3IPPqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:46:25 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:52029 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3IPPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:46:23 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20130916151716.GA5613@ulmo>
References: <1378960909-15773-1-git-send-email-olof@lixom.net>
	<20130916151716.GA5613@ulmo>
Date: Mon, 16 Sep 2013 08:46:22 -0700
Message-ID: <CAOesGMjUeyKDtNU+zVpPYWyQX8ESoUhqaHXLuW5jJ=u2ggEb5A@mail.gmail.com>
Subject: Re: [PATCH] gpu: host1x: use %pa to print dma_addr_t
From: Olof Johansson <olof@lixom.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>,
        dri-devel@lists.freedesktop.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 8:17 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Wed, Sep 11, 2013 at 09:41:49PM -0700, Olof Johansson wrote:
>> This removes two warnings where dma_addr_t variables were printed using
>> %x when built with CONFIG_ARM_LPAE=y, thus having 64-bit dma_addr_t:
>>
>>   drivers/gpu/host1x/hw/cdma_hw.c:57:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t'
>>   drivers/gpu/host1x/hw/debug_hw.c:175:10: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t'
>
> Hi Olof,
>
> I can't reproduce this. Does this perhaps depend on some other patch?
> When I enable LPAE I do see similar warnings in drivers/iommu/tegra-*.c
> and those can indeed be fixed using an equivalent patch.

You need to enable LPAE on a platform that also selects
ARCH_DMA_ADDR_T_64BIT, I don't think tegra does. If you do it with
multi_v7_defconfig you'll see them.

However, see discussion on another of the emails in the series; I'll
have to introduce a new format specifier instead.


-Olof
