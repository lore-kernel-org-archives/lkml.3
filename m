Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbaFZCvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:51:31 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:37683 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbaFZCva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:51:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140625201416.GH19569@lukather>
References: <1403603980-31101-1-git-send-email-wens@csie.org> <20140625201416.GH19569@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 26 Jun 2014 10:51:08 +0800
X-Google-Sender-Auth: TpXFgfO1_QatxZyVWn4efoXWSWU
Message-ID: <CAGb2v65RZfdFKRGdWTph=W6jyccNo420ZSfdeFmWGpwnbHdYZQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] clk: sunxi: fixes, cleanups and A23 basic clocks
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 4:14 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Tue, Jun 24, 2014 at 05:59:34PM +0800, Chen-Yu Tsai wrote:
>> Hi everyone,
>>
>> This is a followup series to my A23 bare-minimum bringup series [1],
>> which adds basic clock support for the A23 SoC. It is one of many
>> split up from the original A23 series [2]. Yet to come are more
>> clocks, reset controllers, pinctrl, prcm, and mmc.
>>
>> The first patch fixes the reworked clock protection code merged in
>> 3.16-rc1, which unintentionally made clock gates unprotectable.
>>
>> The second patch moves the remaining "ahb_sdram" clock to the
>> protected clock list, now that it works.
>>
>> The third patch adds support for factor clocks that have an N factor
>> not starting from 0. This is found on some PLLs in A31/A23.
>>
>> The fourth patch adds table-based dividers for div clocks, as some
>> clocks, such as apb0 divider on sun4/5/7i, apb1 on sun6/8i and axi
>> on sun8i.
>>
>> The fifth patch adds support for the basic clocks in the A23, just
>> PLL1 for cpus, and the system bus clocks and gates.
>>
>> The last patch adds the DT nodes for the newly added clocks.
>>
>> Patch 1 should be merged for 3.16, while the rest should go in 3.17.
>
> Why should it go in for 3.16? Is there any user for it yet?

Yes. Your patch

   efb3184 clk: sun6i: Protect SDRAM gating bit

from the series that added the new clock protection code.
This adds "ahb1_sdram" to the list.

Now, on my sun8i tablet, disabling "ahb1_sdram" doesn't seem to
affect the system. So I'm not sure what this clock actually does.


ChenYu
