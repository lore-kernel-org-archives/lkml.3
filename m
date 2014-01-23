Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaAWI7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:59:44 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:57043 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaAWI7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:59:43 -0500
Message-ID: <52E0DA1A.10108@prisktech.co.nz>
Date: Thu, 23 Jan 2014 22:00:10 +1300
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] vt8500: pinctrl: Change devicetree data parsing
References: <1390458701-30238-1-git-send-email-linux@prisktech.co.nz> <CACRpkdaFJphJdf6hyKoYEZ_wXikwRiwzMgtL=hY+3B8WrBnQaw@mail.gmail.com>
In-Reply-To: <CACRpkdaFJphJdf6hyKoYEZ_wXikwRiwzMgtL=hY+3B8WrBnQaw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/14 21:43, Linus Walleij wrote:
> On Thu, Jan 23, 2014 at 7:31 AM, Tony Prisk <linux@prisktech.co.nz> wrote:
>
>> Due to an assumption in the VT8500 pinctrl driver, the value passed
>> from devicetree for 'wm,pull' was not explicitly translated before
>> being passed to pinconf.
>>
>> With changes to 'enum pin_config_param', PIN_CONFIG_BIAS_PULL_(UP/DOWN)
>> no longer map 1-to-1 with the expected values in devicetree.
>>
>> This patch adds a small translation between the devicetree values (0..2)
>> and the enum pin_config_param equivalent values.
>>
>> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> Isn't this a regression fix for stable?
>
I wasn't sure how to handle this since it's been a problem since 3.10 
but no one has mentioned it (or patched it).

I assume this is because:
a) pinctrl is only used for I2C in mainline - and there is no mainline 
I2C consumer device drivers for the WonderMedia devices
b) most  users are using the non-mainline kernel which has more support 
(as nasty as some of it is).

Regards
Tony Prisk
