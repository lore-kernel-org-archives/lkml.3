Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaDOPOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:14:16 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:39715 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:14:14 -0400
MIME-Version: 1.0
X-Originating-IP: [60.245.65.194]
In-Reply-To: <20140414211644.GG12304@sirena.org.uk>
References: <1394250929.3892.1.camel@phoenix>
	<20140414211644.GG12304@sirena.org.uk>
Date: Tue, 15 Apr 2014 23:14:13 +0800
Message-ID: <CAFRkauDTvEGoaWFBtPWHtw-JFmhTbdHcxoVP56fnv1YG047Knw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] regulator: pbias: Fix is_enabled callback implementation
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Chris Ball <chris@printf.net>, Liam Girdwood <lgirdwood@gmail.com>,
        Balaji T K <balajitk@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-15 5:16 GMT+08:00 Mark Brown <broonie@kernel.org>:
> On Sat, Mar 08, 2014 at 11:55:29AM +0800, Axel Lin wrote:
>> The is_enabled implementation is wrong in some cases:
>> e.g. for pbias_mmc_omap5: enable_mask is : BIT(27) | BIT(25) | BIT(26)
>> However, pbias_regulator_enable() only sets BIT(27) | BIT(26) bits.
>> So is_enabled callback will always return false in this case.
>> Fix the logic to compare the register value with info->enable rather than
>> info->enable_mask.
>
> Applied both, thanks.

Hi Mark,
Currently these 2 commits are in topic/pbias branch.

I think commit 1cb7b43f6796
"regulator: pbias: Fix is_enabled callback implementation"
is a bug fix for 3.15.

commit 60e8c1e34d3a
"regulator: pbias: Convert to use regmap helper functions"
might also required for 3.15.
The reason is this commit implements .list_voltage and the mmc core calls
regulator_list_voltage() in mmc_regulator_get_ocrmask().

Regards,
Axel
