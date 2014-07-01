Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaGAMLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:11:43 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:53312 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaGAMLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:11:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140630093028.GS7262@leverpostej>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
	<1403875511-7710-11-git-send-email-gabriel.fernandez@linaro.org>
	<20140630093028.GS7262@leverpostej>
Date: Tue, 1 Jul 2014 14:11:39 +0200
Message-ID: <CAG374jCyzTZ8tA4NYU+yqM77-_4GTr5=biFRcWqx4fTUaRspSA@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] drivers: clk: st: STiH407: Support for clockgenC0
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>,
        Olivier Bideau <olivier.bideau@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2014 11:30, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Jun 27, 2014 at 02:25:07PM +0100, Gabriel FERNANDEZ wrote:
>> The patch added support for DT registration of ClockGenC0
>> It includes 2 c32 type PLL and a 660 Quadfs.
>>
>> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> Signed-off-by: Olivier Bideau <olivier.bideau@st.com>
>> Acked-by: Peter Griffin <peter.griffin@linaro.org>
>> ---
>>  drivers/clk/st/clkgen-fsyn.c | 47 ++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/clk/st/clkgen-pll.c  | 32 ++++++++++++++++++++++++++++++
>>  2 files changed, 79 insertions(+)
>>
>> diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
>> index b2b73f4..0e0d5f9 100644
>> --- a/drivers/clk/st/clkgen-fsyn.c
>> +++ b/drivers/clk/st/clkgen-fsyn.c
>> @@ -255,6 +255,49 @@ static const struct clkgen_quadfs_data st_fs660c32_F_416 = {
>>       .get_rate       = clk_fs660c32_dig_get_rate,
>>  };
>>
>> +static const struct clkgen_quadfs_data st_fs660c32_C_407 = {
>> +     .nrst_present = true,
>> +     .nrst   = { CLKGEN_FIELD(0x2f0, 0x1, 0),
>> +                 CLKGEN_FIELD(0x2f0, 0x1, 1),
>> +                 CLKGEN_FIELD(0x2f0, 0x1, 2),
>> +                 CLKGEN_FIELD(0x2f0, 0x1, 3) },
>> +     .npda   = CLKGEN_FIELD(0x2f0, 0x1, 12),
>> +     .nsb    = { CLKGEN_FIELD(0x2f0, 0x1, 8),
>> +                 CLKGEN_FIELD(0x2f0, 0x1, 9),
>> +                 CLKGEN_FIELD(0x2f0, 0x1, 10),
>> +                 CLKGEN_FIELD(0x2f0, 0x1, 11) },
>> +     .nsdiv_present = true,
>> +     .nsdiv  = { CLKGEN_FIELD(0x304, 0x1, 24),
>> +                 CLKGEN_FIELD(0x308, 0x1, 24),
>> +                 CLKGEN_FIELD(0x30c, 0x1, 24),
>> +                 CLKGEN_FIELD(0x310, 0x1, 24) },
>> +     .mdiv   = { CLKGEN_FIELD(0x304, 0x1f, 15),
>> +                 CLKGEN_FIELD(0x308, 0x1f, 15),
>> +                 CLKGEN_FIELD(0x30c, 0x1f, 15),
>> +                 CLKGEN_FIELD(0x310, 0x1f, 15) },
>> +     .en     = { CLKGEN_FIELD(0x2fc, 0x1, 0),
>> +                 CLKGEN_FIELD(0x2fc, 0x1, 1),
>> +                 CLKGEN_FIELD(0x2fc, 0x1, 2),
>> +                 CLKGEN_FIELD(0x2fc, 0x1, 3) },
>> +     .ndiv   = CLKGEN_FIELD(0x2f4, 0x7, 16),
>> +     .pe     = { CLKGEN_FIELD(0x304, 0x7fff, 0),
>> +                 CLKGEN_FIELD(0x308, 0x7fff, 0),
>> +                 CLKGEN_FIELD(0x30c, 0x7fff, 0),
>> +                 CLKGEN_FIELD(0x310, 0x7fff, 0) },
>> +     .sdiv   = { CLKGEN_FIELD(0x304, 0xf, 20),
>> +                 CLKGEN_FIELD(0x308, 0xf, 20),
>> +                 CLKGEN_FIELD(0x30c, 0xf, 20),
>> +                 CLKGEN_FIELD(0x310, 0xf, 20) },
>> +     .lockstatus_present = true,
>> +     .lock_status = CLKGEN_FIELD(0x2A0, 0x1, 24),
>> +     .powerup_polarity = 1,
>> +     .standby_polarity = 1,
>> +     .pll_ops        = &st_quadfs_pll_c32_ops,
>> +     .rtbl           = fs660c32_rtbl,
>> +     .rtbl_cnt       = ARRAY_SIZE(fs660c32_rtbl),
>> +     .get_rate       = clk_fs660c32_dig_get_rate,
>> +};
>> +
>>  /**
>>   * DOC: A Frequency Synthesizer that multiples its input clock by a fixed factor
>>   *
>> @@ -938,6 +981,10 @@ static struct of_device_id quadfs_of_match[] = {
>>               .compatible = "st,stih416-quadfs660-F",
>>               .data = (void *)&st_fs660c32_F_416
>>       },
>> +     {
>> +             .compatible = "st,stih407-quadfs660-C",
>> +             .data = (void *)&st_fs660c32_C_407
>
> Surely a (void*) cast isn't necessary?

Ok

Thanks Mark

Gabriel
>
> Mark.
