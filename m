Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab3G2Vqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:46:53 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:62361 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3G2Vqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:46:51 -0400
Message-ID: <51F6E2C7.9000407@gmail.com>
Date: Mon, 29 Jul 2013 23:46:47 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: Felipe Balbi <balbi@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, devicetree@vger.kernel.org,
        Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH] usb: phy-samsung-usb: Simplify PMU register handling
References: <1375130839-5523-1-git-send-email-jwerner@chromium.org> <51F6D88B.80202@gmail.com> <CAODwPW-hxtazAO=scZR+ZWK5hwdWMQXFBeYLd1qqau+a9tMCvA@mail.gmail.com>
In-Reply-To: <CAODwPW-hxtazAO=scZR+ZWK5hwdWMQXFBeYLd1qqau+a9tMCvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 11:12 PM, Julius Werner wrote:
>>> -       if (sphy->phy_type == USB_PHY_TYPE_DEVICE) {
>>> -               reg = sphy->pmuregs + sphy->drv_data->devphy_reg_offset;
>>> -               en_mask = sphy->drv_data->devphy_en_mask;
>>> -       } else if (sphy->phy_type == USB_PHY_TYPE_HOST) {
>>> -               reg = sphy->pmuregs + sphy->drv_data->hostphy_reg_offset;
>>> -               en_mask = sphy->drv_data->hostphy_en_mask;
>>> -       }
>>
>>
>> How is en_mask supposed to get initialized, now when this code is removed ?
>> It's always 0 now, isn't it ?
>>
>
> Whoops... oh, I'm really sorry about that. I ported the patch from a
> branch with slightly different code there and overlooked this. Thanks
> for catching it, will send v2 in a minute.

v2 looks good, thanks. :) As a side note, we are working on the USB PHYs
driver using the generic PHY framework (actually Kamil is working on that).
Thus it is likely the original driver will get replaced in near future by
something else. Not sure when that happens exactly but I suspect it is
not worth to invest in the Samsung USB PHY drivers at drivers/usb/phy/
too much and introduce changes, especially in *.dts, that won't be for
long time in use. Perhaps Kamil can provide more details on which devices
are initially going to be covered by the new driver.

--
Thanks,
Sylwester
