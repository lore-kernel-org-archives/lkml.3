Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab3AWNPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:15:13 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:50095 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3AWNPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:15:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iHd66_dvj_M5zOpJZ7sEy-pYa-CdWKUZBYc3Dfn3JHtfg@mail.gmail.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
	<1358257112-19595-4-git-send-email-gautam.vivek@samsung.com>
	<3963234.Gb249i4a6U@flatron>
	<CAFp+6iHd66_dvj_M5zOpJZ7sEy-pYa-CdWKUZBYc3Dfn3JHtfg@mail.gmail.com>
Date: Wed, 23 Jan 2013 18:45:09 +0530
Message-ID: <CAFp+6iE+WvQz_rbKY2L4N2KoUeTTZYhwc3v3wU5iua_bEPN1ng@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] ARM: Exynos5250: Add clock information for dwc3-exynos
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, jg1.han@samsung.com,
        kgene.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,


On Wed, Jan 16, 2013 at 8:35 PM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
> Hi Tomasz,
>
>
> On Wed, Jan 16, 2013 at 1:19 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> Hi Vivek,
>>
>> Don't you need also some clkdev lookup entry to make the clock available
>> in the driver?
>>
>
> This clock source we added with a motive of completion, however it's
> not being used as of now.
> As far as i could see the lookup structure contains clocks for devices
> having multiple instances.
> Do you feel that i should be adding an entry in clk_lookup structure ?
> May be i am missing here something. Can you please elaborate on the
> use-case of clk_lookup
> entries.
>

Any suggestions on this please ?

>>
>> On Tuesday 15 of January 2013 19:08:31 Vivek Gautam wrote:
>>> Adding necessary device clock to exynos5 needed for
>>> the DWC3 controller.
>>>
>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>> ---
>>>  arch/arm/mach-exynos/clock-exynos5.c |   24 ++++++++++++++++++++++++
>>>  1 files changed, 24 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-exynos/clock-exynos5.c
>>> b/arch/arm/mach-exynos/clock-exynos5.c index 0208c3a..13af020 100644
>>> --- a/arch/arm/mach-exynos/clock-exynos5.c
>>> +++ b/arch/arm/mach-exynos/clock-exynos5.c
>>> @@ -757,6 +757,11 @@ static struct clk exynos5_init_clocks_off[] = {
>>>               .enable         = exynos5_clk_ip_fsys_ctrl ,
>>>               .ctrlbit        = (1 << 18),
>>>       }, {
>>> +             .name           = "usbdrd30",
>>> +             .parent         = &exynos5_clk_aclk_200.clk,
>>> +             .enable         = exynos5_clk_ip_fsys_ctrl,
>>> +             .ctrlbit        = (1 << 19),
>>> +     }, {
>>>               .name           = "usbotg",
>>>               .enable         = exynos5_clk_ip_fsys_ctrl,
>>>               .ctrlbit        = (1 << 7),
>>> @@ -1035,6 +1040,16 @@ static struct clksrc_sources exynos5_clkset_group
>>> = { .nr_sources       = ARRAY_SIZE(exynos5_clkset_group_list),
>>>  };
>>>
>>> +struct clk *exynos5_clkset_usbdrd30_list[] = {
>>> +     [0] = &exynos5_clk_mout_mpll.clk,
>>> +     [1] = &exynos5_clk_mout_cpll.clk,
>>> +};
>>> +
>>> +struct clksrc_sources exynos5_clkset_usbdrd30 = {
>>> +     .sources        = exynos5_clkset_usbdrd30_list,
>>> +     .nr_sources     = ARRAY_SIZE(exynos5_clkset_usbdrd30_list),
>>> +};
>>> +
>>>  /* Possible clock sources for aclk_266_gscl_sub Mux */
>>>  static struct clk *clk_src_gscl_266_list[] = {
>>>       [0] = &clk_ext_xtal_mux,
>>> @@ -1329,6 +1344,15 @@ static struct clksrc_clk exynos5_clksrcs[] = {
>>>                       .parent         = &exynos5_clk_mout_cpll.clk,
>>>               },
>>>               .reg_div = { .reg = EXYNOS5_CLKDIV_GEN, .shift = 4, .size = 3
>> },
>>> +     }, {
>>> +             .clk    = {
>>> +                     .name           = "sclk_usbdrd30",
>>> +                     .enable         = exynos5_clksrc_mask_fsys_ctrl,
>>> +                     .ctrlbit        = (1 << 28),
>>> +             },
>>> +             .sources = &exynos5_clkset_usbdrd30,
>>> +             .reg_src = { .reg = EXYNOS5_CLKSRC_FSYS, .shift = 28, .size =
>> 1 },
>>> +             .reg_div = { .reg = EXYNOS5_CLKDIV_FSYS0, .shift = 24, .size =
>> 4 },
>>>       },
>>>  };
>
>



-- 
Thanks & Regards
Vivek
