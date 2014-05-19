Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaESOVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:21:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48423 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaESOVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:21:51 -0400
Message-ID: <537A1354.6010408@ti.com>
Date: Mon, 19 May 2014 19:51:08 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>, Lee Jones <lee.jones@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>
Subject: Re: [PATCH 4/4] phy: miphy365x: Provide support for the MiPHY356x
 Generic PHY
References: <1392377036-12816-1-git-send-email-lee.jones@linaro.org> <1392377036-12816-4-git-send-email-lee.jones@linaro.org> <20140305075548.GG20016@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140305075548.GG20016@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 05 March 2014 01:25 PM, Mark Rutland wrote:
> On Fri, Feb 14, 2014 at 11:23:56AM +0000, Lee Jones wrote:
>> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
>> devices. It has 2 ports which it can use for either; both SATA, both
>> PCIe or one of each in any configuration.
>>
>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  drivers/phy/Kconfig         |  10 +
>>  drivers/phy/Makefile        |   1 +
>>  drivers/phy/phy-miphy365x.c | 614 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 625 insertions(+)
>>  create mode 100644 drivers/phy/phy-miphy365x.c
> 
> [...]
> 
>> +enum miphy_sata_gen {
>> +       SATA_GEN1 = 1,
>> +       SATA_GEN2,
>> +       SATA_GEN3
>> +};
> 
> It would be nice to have a comment here that these values are ABI and
> cannot change.
> 
> [...]
> 
>> +static struct phy *miphy365x_phy_xlate(struct device *dev,
>> +                                      struct of_phandle_args *args)
>> +{
>> +       struct miphy365x_dev *state = dev_get_drvdata(dev);
>> +       u8 port = args->args[0];
>> +       u8 type = args->args[1];
> 
> In case of a bad dt, it would be nice to check args->arg_count == 2.
> 
> ALso, we throw away the top 24 bits, which may have been set
> erroneously. If we want to make use of those in future we should test
> they are clear here to force people to do the right thing.

I don't seem to have the update patch series? Can you resend please?

Thanks
Kishon
> 
> Otherwise, this looks fine to me.
> 
> With those additions:
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
> Cheers,
> Mark.
> 
