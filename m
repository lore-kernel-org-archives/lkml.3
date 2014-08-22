Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbaHVLXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:23:51 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44582 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaHVLXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAL1qeaH=8Fgw6Zia3DuBL8wrrYMjZ8pqC2NanYtb5-YVJwmtsg@mail.gmail.com>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
 <CAAObsKDT4BV=fGAFkMxieQnC3HX=zm8G_qJ44yay4qG8inxoPQ@mail.gmail.com> <CAL1qeaH=8Fgw6Zia3DuBL8wrrYMjZ8pqC2NanYtb5-YVJwmtsg@mail.gmail.com>
From: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Date: Fri, 22 Aug 2014 13:23:27 +0200
X-Google-Sender-Auth: pKiujFaqY7NJyxd_UgoKdxBcHXc
Message-ID: <CAAObsKCfKtZm5j9Ecze+3GwWCN3DFOjHUUACdYR4TmV+ExbC8A@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Tegra xHCI support
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 August 2014 19:26, Andrew Bresticker <abrestic@chromium.org> wrote:
> On Thu, Aug 21, 2014 at 6:34 AM, Tomeu Vizoso <tomeu@tomeuvizoso.net> wrote:
>> On 18 August 2014 19:08, Andrew Bresticker <abrestic@chromium.org> wrote:
>>>
>>> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
>>> USB3.0 memory sticks and ethernet dongles using controller firmware from
>>> the ChromiumOS tree [2].
>>
>> Hi Andrew,
>>
>> do you have any information regarding the port assignments for the
>> Blaze board? Would like to test this there.
>
> Sure:
> - USB3 port 0 (using PCIe lane 0) and UTMI port 0 are connected to the
> USB A connector on the left side,
> - UTMI port 1 is connected to an internal hub, which is in turn
> connected to the camera, the LTE modem (if present), and one of the
> USB A connectors on the right side, and
> - UTMI port 2 is connected to the other USB A connector on the right side.
> The mapping of ports on the right side varies by SKU (i.e. the one on
> the internal hub may be the front or rear USB A port).
>
> The USB3 device tree bits for Venice2 should work just fine for Blaze;
> the only real difference is that USB3 port 1/PCIe lane 1 are unused.
>
> Also, because of the board design on Blaze, the fused HS_CURR_LEVEL
> values need to be adjusted before being programmed into
> USB2_OTG_PAD*_CTL0.  This only affects UTMI ports 0 and 2, so ports
> connected to the internal hub should still work.  I'll add a pinconfig
> property to address this in the likely event I need to re-spin this
> series.  Or, if you like, I can send a follow-on patch to this set to
> add the property.

Yeah, that would be great, if it's not too much trouble for you. So
far the internal camera is working so I'm able to do some
experimenting with it already.

Thanks,

Tomeu
