Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaCGDpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:45:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52885 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbaCGDpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:45:09 -0500
Message-ID: <53194092.7010809@ti.com>
Date: Fri, 7 Mar 2014 11:44:18 +0800
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/7] of: introduce of_dma_is_coherent() helper
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com>	<1394097598-17622-4-git-send-email-santosh.shilimkar@ti.com> <CAL_JsqJnG1c0=+UgOmNOGs7a5jv2f3O074-TsXibiHsXapXhcQ@mail.gmail.com>
In-Reply-To: <CAL_JsqJnG1c0=+UgOmNOGs7a5jv2f3O074-TsXibiHsXapXhcQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2014 11:13 AM, Rob Herring wrote:
> On Thu, Mar 6, 2014 at 3:19 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
>> The of_dma_is_coherent() helper parses the given DT device
>> node to see if the "dma-coherent" property is supported and
>> returns true or false accordingly.
>>
>> For the architectures which are fully dma coherent and don't need per device
>> property, it can enable CONFIG_ARCH_IS_DMA_COHERENT config option which
>> enables DMA coherent for all devices by default.
> 
> This worries me. I killed off arch_is_coherent() for arm. Now we're
> adding something back. Also, we already have HAVE_GENERIC_DMA_COHERENT
> which is different, but the names will be confusing. MIPS also has
> DMA_NONCOHERENT.
> 
Thanks for comments Rob. I will address them in next version.
Specifically about ARCH_IS_DMA_COHERENT, I wasn't very comfortable either
while adding it. But as Arnd mentioned, there is a need to have a way
for the arch's which are fully coherent to use coherent ops by default.

Am not sure whats the best way to have such support without imposing
any special updates on such arches.

Arnd, Any better alternative here ?

Regards,
Santosh
