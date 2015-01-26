Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbbAZINi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 03:13:38 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62610 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbAZINf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 03:13:35 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1501260205090.5450@utopia.booyaka.com>
References: <1422217915-24231-1-git-send-email-prabhakar.csengg@gmail.com> <alpine.DEB.2.02.1501260205090.5450@utopia.booyaka.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 26 Jan 2015 08:13:01 +0000
Message-ID: <CA+V-a8urS2C20FDcfsGa+Gg+7wmbbQQw3U7BfXf6GBKoBGMc9w@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: AM43xx: hwmod: add VPFE hwmod entries
To: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>,
        Darren Etheridge <detheridge@ti.com>, Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thanks for the review.

On Mon, Jan 26, 2015 at 2:15 AM, Paul Walmsley <paul@pwsan.com> wrote:
> Hi
>
> On Sun, 25 Jan 2015, Lad, Prabhakar wrote:
>
>> From: Benoit Parrot <bparrot@ti.com>
>>
>> this patch adds VPFE HWMOD data for AM43xx.
>>
>> Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> Signed-off-by: Darren Etheridge <detheridge@ti.com>
>> Signed-off-by: Felipe Balbi <balbi@ti.com>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  Hi Paul,
>>
>>  You were right, the hardware team has confirmed that, the VPFE master port is
>>  connected to L3 and the VPFE slave port is connected to L4. The L3 port cannot
>>  serve as a register target because it is initiator only.
>
> OK makes sense to me.,
>
>>
>>  I have created links referring to dss l3/l4 hwmod and tested it, lemme know
>>  if I have missed something.
>
> A few minor comments below
>
>>
[Snip]
>>  /* Interfaces */
>>  static struct omap_hwmod_ocp_if am43xx_l3_main__l4_hs = {
>>       .master         = &am33xx_l3_main_hwmod,
>> @@ -788,6 +826,36 @@ static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_rfbi = {
>>       .user           = OCP_USER_MPU | OCP_USER_SDMA,
>>  };
>>
>> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe0 = {
>> +     .master         = &am43xx_vpfe0_hwmod,
>> +     .slave          = &am33xx_l3_main_hwmod,
>> +     .clk            = "l3_gclk",
>> +     .flags          = OCPIF_SWSUP_IDLE,
>
> OCPIF_SWSUP_IDLE probably isn't needed here.  Could you please try without
> it?
>
>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe1 = {
>> +     .master         = &am43xx_vpfe1_hwmod,
>> +     .slave          = &am33xx_l3_main_hwmod,
>> +     .clk            = "l3_gclk",
>> +     .flags          = OCPIF_SWSUP_IDLE,
>
> Same point as the above.
>
Dropped and tested works! posting a v3.

Cheers,
--Prabhakar Lad
