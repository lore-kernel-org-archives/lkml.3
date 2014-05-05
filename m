Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbaEEWGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:06:13 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:53442 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692AbaEEWGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:06:11 -0400
MIME-Version: 1.0
In-Reply-To: <5368068C.3090403@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<1398353407-2345-4-git-send-email-santosh.shilimkar@ti.com>
	<CAL_JsqKmf-OCf_-J06ztHWS0iRaMHAVxV0bOFGnY4Ci3fPgLow@mail.gmail.com>
	<5368068C.3090403@ti.com>
Date: Mon, 5 May 2014 17:06:10 -0500
Message-ID: <CAL_JsqLdScT5SzHKB_XoDm7o0pZ5WJFAk4hG0yzmET68yjnmzA@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] of: introduce of_dma_is_coherent() helper
From: Rob Herring <robherring2@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 4:45 PM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> On Thursday 01 May 2014 08:56 PM, Rob Herring wrote:
>> On Thu, Apr 24, 2014 at 10:30 AM, Santosh Shilimkar
>> <santosh.shilimkar@ti.com> wrote:

>>>  drivers/of/platform.c       |   23 +++++++++++++++++++++++
>>>  include/linux/of_platform.h |    6 ++++++
>>
>> I thought I said this already, but this does not belong in these files
>> as the function does not deal with platform devices. Probably
>> address.c/of_address.h would be the best place.
>>
> Updated patch with functions now moved to of_address.h/address.c
>
> From 08fb70715afe4adf203d24f1737dba7123c6713b Mon Sep 17 00:00:00 2001
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date: Thu, 24 Apr 2014 11:30:03 -0400
> Subject: [PATCH v3 3/7] of: introduce of_dma_is_coherent() helper
>
> The of_dma_is_coherent() helper parses the given DT device
> node to see if the "dma-coherent" property is supported and
> returns true or false accordingly.
>
> If the arch is always coherent or always noncoherent, then the default
> DMA ops has to be specified accordingly.
>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/of/address.c       |   23 +++++++++++++++++++++++
>  include/linux/of_address.h |    6 ++++++
>  2 files changed, 29 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
