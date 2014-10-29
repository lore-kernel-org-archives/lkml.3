Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaJ2CYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:24:36 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:32852 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaJ2CYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:24:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141028214756.GF9255@lukather>
References: <cover.1414444953.git.rbyshko@gmail.com> <668c1b5541fc0175957573bd5f8d40dd2eaccae1.1414444953.git.rbyshko@gmail.com>
 <20141028214756.GF9255@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Wed, 29 Oct 2014 10:24:12 +0800
X-Google-Sender-Auth: 4HWE-tNoasnjKjlEVe1ZPLzfBSU
Message-ID: <CAGb2v65gSq+kMnVZMAvXkF6+ARiFE1qRpQ9SFDThfXCg_kERsQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] phy: sun4i: add support for USB phy0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Roman Byshko <rbyshko@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 5:47 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi Roman,
>
> Thanks for your patches
>
> On Mon, Oct 27, 2014 at 10:43:01PM +0100, Roman Byshko wrote:
>> The driver for sun4i USB phys currently supports
>> only phy1 and phy2 which are used for USB host
>> controllers. This patch adds support for USB phy0,
>> which is used by the musb hdrc USB controller.
>
> Like Andreas already pointed out, your signed-off-by is missing from
> all your patches.
>
>> ---
>>  drivers/phy/phy-sun4i-usb.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
>> index 0baf5ef..a24728b 100644
>> --- a/drivers/phy/phy-sun4i-usb.c
>> +++ b/drivers/phy/phy-sun4i-usb.c
>> @@ -157,6 +157,10 @@ static int sun4i_usb_phy_init(struct phy *_phy)
>>               return ret;
>>       }
>>
>> +     /* Regulation 45 ohms */
>> +     if (phy->index == 0)
>> +             sun4i_usb_phy_write(phy, PHY_RES45_CAL_EN, 0x01, 1);
>
> What is this code supposed to do?
>
> Some define for this bit and/or a better comment would be nice.

>From Allwinner's sources: "Enable/Disable USB res45 Calibration"

which I think refers to the internal 45 ohm termination resistors
for the USB data lines. But I'm not an expert on USB hardware.
