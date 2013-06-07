Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3FGNgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:36:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50661 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab3FGNgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:36:41 -0400
Message-ID: <51B1E1C7.7050407@ti.com>
Date: Fri, 7 Jun 2013 19:06:07 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Hebbar Gururaja <gururaja.hebbar@ti.com>, <khilman@linaro.org>,
        <linus.walleij@linaro.org>, <sudhakar.raj@ti.com>,
        <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <vaibhav.bedia@ti.com>, <linux-omap@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/11] mmc: omap_hsmmc: enhance pinctrl support
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com> <1369995191-20855-10-git-send-email-gururaja.hebbar@ti.com> <20130604144632.GI3331@atomide.com>
In-Reply-To: <20130604144632.GI3331@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 08:16 PM, Tony Lindgren wrote:
> * Hebbar Gururaja <gururaja.hebbar@ti.com> [130531 03:19]:
>> Amend the hsmmc controller to optionally take a pin control handle and
>> set the state of the pins to:
>>
>> - "default" on boot, resume and before performing a mmc transfer
>> - "idle" after initial default, after resume default, and after each
>> mmc/sd card access
>> - "sleep" on suspend()
>>
>> By optionally putting the pins into sleep state in the suspend callback
>> we can accomplish two things.
>> - One is to minimize current leakage from pins and thus save power,
>> - second, we can prevent the IP from driving pins output in an
>> uncontrolled manner, which may happen if the power domain drops the
>> domain regulator.
>>
>> If any of the above pin states are missing in dt, a warning message
>> about the missing state is displayed.
>> If certain pin-states are not available, to remove this warning message
>> pass respective state name with null phandler.
>
> There's a similar patch in the "[RESEND PATCH v2 1/3] mmc: omap_hsmmc:
> Enable SDIO IRQ using a GPIO in idle mode" thread. It also makes the
> SDIO interrupts to work, so we need to consider that too.
>

Hi Tony,

I will try to combine both of these and make use of
pinctrl_pm_select_[*]_state helper functions.


> We can merge the dynamic pinmuxing parts separately, but they should
> be in a separate function like I posted later on in the thread above.
>
> Regards,
>
> Tony
>
