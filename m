Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825AbaLKGab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 01:30:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41182 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933440AbaLKGaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 01:30:30 -0500
Message-ID: <54893963.7060304@ti.com>
Date: Thu, 11 Dec 2014 11:57:47 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Yunzhi Li <lyz@rock-chips.com>, <heiko@sntech.de>, <jwerner@chromium.org>,
        <dianders@chromium.org>, <olof@lixom.net>, <huangtao@rock-chips.com>,
        <zyw@rock-chips.com>, <cf@rock-chips.com>,
        <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418208371-18851-1-git-send-email-lyz@rock-chips.com>	 <1418208371-18851-2-git-send-email-lyz@rock-chips.com>	 <5489338C.1030109@ti.com> <1418278322.18092.30.camel@perches.com>
In-Reply-To: <1418278322.18092.30.camel@perches.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 11 December 2014 11:42 AM, Joe Perches wrote:
> On Thu, 2014-12-11 at 11:32 +0530, Kishon Vijay Abraham I wrote:
>> On Wednesday 10 December 2014 04:16 PM, Yunzhi Li wrote:
>>> diff --git a/drivers/phy/phy-rockchip-usb.c b/drivers/phy/phy-rockchip-usb.c
> []
>>> +/*
>>> + * The higher 16-bit of this register is used for write protection
>>> + * only if BIT(13 + 16) set to 1 the BIT(13) can be written.
>>> + */
>>> +#define SIDDQ_MSK		BIT(13 + 16)
> 
> huh?
> 
> This #define looks _very_ odd.
> 
> Is this supposed to be a single bit 29 or
> some range?

>From what I understood, the most significant 16 bits are write locks to the
least significant 16 bits.

So If I have to write something on bit 0, I have to set bit 16.
If I have to write something on bit 1, I have to set bit 17.
If I have to write something on bit 2, I have to set bit 18.
and so on.

Thanks
Kishon
