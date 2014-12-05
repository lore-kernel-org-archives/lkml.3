Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbaLEDzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:55:07 -0500
Received: from lucky1.263xmail.com ([211.157.147.130]:43392 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933269AbaLEDzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:55:05 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <a54e8a4fe7a3cecfd0dd9647eac1576c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54812C86.6080307@rock-chips.com>
Date: Fri, 05 Dec 2014 11:54:46 +0800
From: Yunzhi Li <lyz@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        dianders <dianders@chromium.org>, ulrich.prinz@googlemail.com,
        zyw@rock-chips.com, linux-kernel@vger.kernel.org, kishon@ti.com,
        linux-usb@vger.kernel.org, kever.yang@rock-chips.com,
        wulf <wulf@rock-chips.com>, huangtao <huangtao@rock-chips.com>
Subject: Re: Re: [PATCH] phy: add Rockchip RK3288 USB2 PHY driver.
References: <54812B65.5000408@rock-chips.com>
In-Reply-To: <54812B65.5000408@rock-chips.com>
X-Forwarded-Message-Id: <54812B65.5000408@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Heiko

> Am Mittwoch, 3. Dezember 2014, 21:46:50 schrieb LiYunzhi:
>> +
>> +};
>> +
>> +static int rockchip_usb_phy_power(struct rockchip_usb_phy *phy,
>> +					   bool siddq)
>> +{
>> +	return regmap_write(phy->reg_base, phy->reg_offset,
>> +			    SIDDQ_MSK | (siddq ? SIDDQ_ON : SIDDQ_OFF));
> just for my understanding:
>
> You're using the SIDDQ bit, which supposedly "powers down all analog blocks"
> for IDDQ testing to control the phy power.
>
> What is the difference to usbotg_disable (bit 4 of uoc_con0) that is supposed
> to "power down the USB OTG/HOST block"?
>
> Similarly, where is the difference to usbotg_sleepm [uoc_con2 bit 10] combined
> with usbotg_common_on_n [uoc_con0 bit 0]?

SIDDQ: is used to power down the USB block analog function.
usbotg_disable: is used to diable USB digital interface, and USB analog
part is still alive.
The power consuming is total different.  Power(SIDDQ) <
Power(usbotg_disable).

usbotg_sleepm is defined in USB Low power mode - L1, this signal could
be used for USB 2.0 Link Power Management (LPM) addendum to the USB 2.0
specification, but our controller doesn't support. So we do not use
sleepm, this bit here just for debug force the transmitter enter the LPM
specific sleep mode.

usbotg_common_on_n: is used to control USB PHY internal PLL. When active
Low, the PLL is still alive in suspend mode, which could output 480M
clock for other IP use.

--------
Roy Li @ Rockchip



