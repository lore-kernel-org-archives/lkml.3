Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbaICTNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:13:13 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:56921 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbaICTNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140903190234.GH11766@atomide.com>
References: <FAC7D7E5-1D05-4D63-821F-C56D3AAA8FF9@goldelico.com>
	<20140825212652.GR17254@atomide.com>
	<EBD1E2E6-E596-4B3D-B093-144ABDD7DEDE@goldelico.com>
	<20140903184527.GG11766@atomide.com>
	<54076311.2030306@ti.com>
	<20140903190234.GH11766@atomide.com>
Date: Wed, 3 Sep 2014 14:13:10 -0500
X-Google-Sender-Auth: frY2KQLU5Te6_SIF_AauIcMeDIg
Message-ID: <CAGo_u6r1UvbUMf2WC8=-CudXDCZ69KSUbBSOAiPWWLehotj36Q@mail.gmail.com>
Subject: Re: PROBLEM: bindings for drivers/mfd/twl4030-power.c
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 2:02 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Nishanth Menon <nm@ti.com> [140903 11:51]:
>> On 09/03/2014 01:45 PM, Tony Lindgren wrote:
>> > * Dr. H. Nikolaus Schaller <hns@goldelico.com> [140901 09:54]:
>> >> Hi,
>> >>
>> >> Am 25.08.2014 um 23:26 schrieb Tony Lindgren:
>> >>
>> >>> * Dr. H. Nikolaus Schaller <hns@goldelico.com> [140817 08:46]:
>> >>>> I am trying to make ti,use_poweroff work on 3.17-rc1 for the GTA04 board.
>> >>>> Poweroff was broken for a while and I found that the driver isn't loaded at all.
>> >>>>
>> >>>> It appears to me that commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
>> >>>> did rename the compatible entry from "ti,twl4030-power" to "ti,twl4030-power-reset"
>> >>>> but this was not documented in the bindings and of course our DT does not
>> >>>> match.
>> >>>>
>> >>>> Even your commit message talks about "ti,twl4030-power" although I can't find it
>> >>>> in the code.
>> >>>
>> >>> Hmm sorry did I accidentally remove ti,twl4030-power? If so, that should
>> >>> be added back for sure. Do you have a patch for that already?
>> >>
>> >> No, I have only updated our device tree because I don't know if it really should
>> >> be added back or not.
>> >>
>> >> As you say the "ti,twl4030-power" does not configure anything. So what
>> >> is it good for?
>> >
>> > Only for the poweroff if "ti,use_poweroff" is set. Care to do a patch
>> > as you clearly have a use case to test it with?
>>
>> Tony, we were talking about supporting ti,system-power-controller as
>> the standard way of stating poweroff control is by the PMIC. this
>> seems to be standard in various SoCs. use_poweroff seems to predate
>> that standardization. Should'nt we start using
>> ti,system-power-controller instead?
>
> Sure we can add that. But need to keep also parsing "ti,use_poweroff"
> as it's already in use.
>

Yep.
https://patchwork.kernel.org/patch/4836381/
https://patchwork.kernel.org/patch/4836371/

Split documentation out (based on discussion in
https://patchwork.kernel.org/patch/4743321/).

-- 
---
Regards,
Nishanth Menon
