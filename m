Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaFDLGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:06:11 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:42299 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaFDLGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:06:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140604084831.GB23469@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
	<1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
	<CAPDyKFpanhYbf89tEKru=_oOfBGZZxs0=eqr_5MvU9v_bGULjQ@mail.gmail.com>
	<20140604084831.GB23469@griffinp-ThinkPad-X1-Carbon-2nd>
Date: Wed, 4 Jun 2014 13:06:07 +0200
Message-ID: <CAPDyKFqvQca9RfsVVyfeC9r=pEDM2mBkfS7SzpYZHHXMnHfyUQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] mmc: sdhci-st: Intial support for ST SDHCI controller
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        kernel@stlinux.com, linux-mmc <linux-mmc@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2014 10:48, Peter Griffin <peter.griffin@linaro.org> wrote:
> Hi Ulf,
>
> Thanks for reviewing, see my comments below: -
>
> On Fri, 23 May 2014, Ulf Hansson wrote:
>> > +static unsigned int sdhci_st_get_max_clk(struct sdhci_host *host)
>> > +{
>> > +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>> > +
>> > +       return clk_get_rate(pltfm_host->clk);
>> > +}
>>
>> There are sdhci library function for the above:
>> sdhci_pltfm_clk_get_max_clock()
>
> I've fixed in v2 to use the library function
>
>> > +       host->mmc->caps |= MMC_CAP_8_BIT_DATA | MMC_CAP_BUS_WIDTH_TEST
>> > +                       | MMC_CAP_1_8V_DDR;
>>
>> Comment below.
>>
>> > +
>> > +       if (of_property_read_bool(np, "non-removable"))
>> > +               host->mmc->caps |= MMC_CAP_NONREMOVABLE;
>>
>> MMC_CAP_1_8V_DDR, MMC_CAP_8_BIT_DATA, MMC_CAP_NONREMOVABLE aren’t
>> those board specific capabilities?
>
> Yep
>>
>> Unless there are something that prevents you from using the common mmc
>> DT parser, I would suggest you to use it. mmc_of_parse(). Thus you can
>> provide these capabilities through DT instead.
>
> Thanks for pointing that out, I've switched over to using mmc_of_parse,
> and everything works as expected.
>
> Also as an added bonus this will simplify support for the next SoC which
> needs access to the high speed ddr / sdr bindings which
> mmc_of_parse already supports :-)
>
> In v2 I've also removed the reset controller code from this platform driver
> with the intention of adding it back in, in the generic code. The idea
> would be that an additional 'reset' binding could be provided, which if
> present would be used to deassert the IP reset line of the controller at
> probe / resume, and assert reset at remove / sleep.
>
> Is this something you view as useful, if so I will prepare some RFC patches?

Sounds useful. Please go ahead and send patches! :-)

Kind regards
Uffe
