Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaEHQNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:13:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45059 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaEHQM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:12:58 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
X-AuditID: cbfec7f5-b7fae6d000004d6d-73-536bad074192
Content-transfer-encoding: 8BIT
Message-id: <536BAD05.9070401@samsung.com>
Date: Thu, 08 May 2014 18:12:53 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH 1/2] ARM: dts: Enable USB 3503 hub on exynos5250-snow
References: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
 <536BA9E8.2030306@suse.de>
In-reply-to: <536BA9E8.2030306@suse.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7rsa7ODDZ7f0LRo3lRs8WLjLXaL
	+UfOsVq0XTnIbtG74CqbxabH11gtLu+aw2Yx4/w+JotFy1qZHTg9ds66y+6xeUm9R9+WVYwe
	m09Xe3zeJBfAGsVlk5Kak1mWWqRvl8CVsW1SRMFkrorJX/4xNzD2cXQxcnJICJhInDq7iAnC
	FpO4cG89WxcjF4eQwFJGicVzG9lBErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoCvxrmUzK0T9
	Z0aJYwuXsUHUa0nMP9jNCFLPIqAqsXmRIUiYTUBN4nPDI7ASfqCSNU3XWUBsUYEIiXuNh8Hm
	iAi0M0rc+PKJGcRhFtjEKLHgzU5WkCphAU+JzrcfwA4SEkiVuHz9ENgkTgF1iS0TH7JPYBSc
	heTWWQi3zkJy6wJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIZHwdQfj0mNWhxgFOBiV
	eHgXyGQEC7EmlhVX5h5ilOBgVhLhfbEsO1iINyWxsiq1KD++qDQntfgQIxMHp1QDo1cTu+ZM
	rYXXDbRvlGgIHQtv0BZurxYKXPm4K/D7xBOH77vEZtZyzed8ucN2UVRp8u+tkzTmKp7PqDxj
	rv76yeq8Iw+b1hzl+cf2/l++xfzo2JNsrhMmz5I+9utsmbSmm9+Ss2f/3ckWy1nMo25m3G9w
	WDrAwPhZuZC0dcbBuOluaXGd/+valFiKMxINtZiLihMBSP7Y4mICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.2014 17:59, Andreas Färber wrote:
> Hello,
> 
> Am 05.05.2014 14:30, schrieb Vivek Gautam:
>> The exynos5250-snow has a SMSC USB3503 connected in
>> hardware only mode like a PHY. Enable support for it,
>> and add necessary 'reset-gpio' for it.
>>
>> This is in correspondance to similar patch by Mark Brown
>> 7c1b0ec ARM: dts: Enable USB hub on Arndale
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>
>> Based on 'for-next' branch of kgene's linux-samsung tree.
>>
>>  arch/arm/boot/dts/exynos5250-pinctrl.dtsi |    7 +++++++
>>  arch/arm/boot/dts/exynos5250-snow.dts     |   14 ++++++++++++++
>>  2 files changed, 21 insertions(+)
> 
> The same snippet as for snow also fixed my USB issues on spring.
> Should it go into exynos5250-cros-common.dtsi instead?

The GPIO pins used are different, so I don't think the hub node added by
these patches could be shared.

Also, I believe all you need to add is a simple node as follows

usb_hub {
	compatible = "smsc,usb3503a";
	reset-gpios = <&gpe1 0 1>;
};

at root level (see my comments to this patch in another reply), which is
affordable to be duplicated for every platform that requires it,
especially if the reset-gpios property differs between boards.

Best regards,
Tomasz
