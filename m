Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3HBK5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:57:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33281 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab3HBK5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:57:30 -0400
Message-ID: <51FB9095.8030200@ti.com>
Date: Fri, 2 Aug 2013 13:57:25 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: Nishanth Menon <nm@ti.com>, <tony@atomide.com>, <rnayak@ti.com>,
        <benoit.cousson@linaro.org>, <balbi@ti.com>, <george.cherian@ti.com>,
        <kishon@ti.com>, <dmurphy@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] CLK: ti: dra7: Initialize USB_DPLL
References: <1375369134-26398-1-git-send-email-rogerq@ti.com> <1375369134-26398-2-git-send-email-rogerq@ti.com> <51FA7976.8020707@ti.com> <51FB6027.6080808@ti.com>
In-Reply-To: <51FB6027.6080808@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 10:30 AM, Roger Quadros wrote:
> Hi Nishant,
>
> On 08/01/2013 06:06 PM, Nishanth Menon wrote:
>> On 08/01/2013 09:58 AM, Roger Quadros wrote:
>>> USB_DPLL must be initialized and locked at boot so that
>>> USB modules can work.
>>>
>>> Also program USB_DLL_M2 output to half rate.
>>>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>> ---
>>>    drivers/clk/omap/clk-7xx.c |   11 +++++++++++
>>>    1 files changed, 11 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/clk/omap/clk-7xx.c b/drivers/clk/omap/clk-7xx.c
>>> index ddb39dd..f444513 100644
>>> --- a/drivers/clk/omap/clk-7xx.c
>>> +++ b/drivers/clk/omap/clk-7xx.c
>>> @@ -19,6 +19,7 @@
>>>
>>>    #define DRA7_DPLL_ABE_DEFFREQ                361267200
>>>    #define DRA7_DPLL_GMAC_DEFFREQ                1000000000
>>> +#define DRA7_DPLL_USB_DEFFREQ                960000000
>>>
>>>
>>>    static struct omap_dt_clk dra7xx_clks[] = {
>>> @@ -63,5 +64,15 @@ int __init dra7xx_clk_init(void)
>>>        if (rc)
>>>            pr_err("%s: failed to configure GMAC DPLL!\n", __func__);
>>>
>>> +    dpll_ck = clk_get_sys(NULL, "dpll_usb_ck");
>>> +    rc = clk_set_rate(dpll_ck, DRA7_DPLL_USB_DEFFREQ);
>>> +    if (rc)
>>> +        pr_err("%s: failed to configure USB DPLL!\n", __func__);
>>> +
>>> +    dpll_ck = clk_get_sys(NULL, "dpll_usb_m2_ck");
>>> +    rc = clk_set_rate(dpll_ck, DRA7_DPLL_USB_DEFFREQ/2);
>>> +    if (rc)
>>> +        pr_err("%s: failed to set USB_DPLL M2 OUT\n", __func__);
>>> +
>>>        return rc;
>>>    }
>>>
>> As I had mentioned on [1] - we are going to see similar needs keep popping up. there is no need to hack this up for even more peripherals :(
>>
>> http://marc.info/?l=linux-omap&m=137536803106017&w=2
>>
> The DPLLs need to be initialized irrespective of whether peripheral drivers are present or not.
> We have seen cases where the SoC fails to enter RETention if the DPLLS are not correctly
> configured.
>
> But I agree with you that we should be able to initialize it by specifying the initial rate via Clock Data.
>
> This patch can be removed when the appropriate feature is added in OMAP clock core.

... not OMAP clock core, I would say clock core. This is again a feature 
we can work with once we have initial support in place.

-Tero
