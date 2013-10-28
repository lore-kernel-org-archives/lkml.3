Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3J1PXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:23:11 -0400
Received: from beta.dmz-eu.st.com ([164.129.1.35]:53451 "EHLO
	beta.dmz-eu.st.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab3J1PXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:23:08 -0400
X-Greylist: delayed 1135 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Oct 2013 11:23:08 EDT
Message-ID: <526E7C8C.8080603@st.com>
Date: Mon, 28 Oct 2013 16:02:36 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Lucas Stach <l.stach@pengutronix.de>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>  <1381754813-4679-2-git-send-email-maxime.coquelin@st.com>  <20131016151419.GA14104@ns203013.ovh.net> <525F915D.9020501@st.com>  <525FAEED.7030207@st.com> <20131017141957.GE14104@ns203013.ovh.net>  <525FF498.3060202@st.com> <1382021369.4093.44.camel@weser.hi.pengutronix.de> <5260EFDC.804@st.com>
In-Reply-To: <5260EFDC.804@st.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/18/2013 10:22 AM, Srinivas KANDAGATLA wrote:
> On 17/10/13 15:49, Lucas Stach wrote:
>> Am Donnerstag, den 17.10.2013, 15:30 +0100 schrieb srinivas kandagatla:
>> [...]
>>> Sorry to ask this but, Where is this requirement coming from?
>>> I have not spotted any thing as such in ePAPR specs.
>>>
>>>
>>> All the spec says is.
>>> ===
>>> The compatible property value consists of one or more strings that
>>> define the specific programming model for the device. This list of
>>> strings should be used by a client program for device driver selection.
>>> The property value consists of a concatenated list of null terminated
>>> strings, *from most specific to most general.* They allow a device to
>>> express its compatibility with a family of similar devices, potentially
>>> allowing a single device driver to match against several devices.
>>> The recommended format is “manufacturer,model”, where manufacturer is a
>>> string describing the name of the manufacturer (such as an OUI), and
>>> model specifies the model number.
>>>
>>> Example:
>>> compatible = “fsl,mpc8641-uart”, “ns16550";
>>> In this example, an operating system would first try to locate a device
>>> driver that supported fsl,mpc8641-uart. If a driver was not found, it
>>> would then try to locate a driver that supported the more general
>>> ns16550 device type.
>>> ===
>>>
>>> The more general compatible string in this case is "st,comms-ssc-i2c",
>>> rather than the first soc name.
>>> How can a first SOC name be more general?
>>>
>>> As this driver is not very specific to StiH415, it is generic driver for
>>> ST comms-ssc-i2c block.
>>>
>> You just can't know if someone in the future decides to subtly change
>> the register layout or make some other incompatible change to the
>> comms-ssc-i2c block.
>>
> This is not the case for comms-ssc-i2c block, This IP is kind of reused
> from past 10+ years(I think!!). Am not predicting the future here, but I
> am making a informed guess from past experience that this IP would not
> change in future.
Having discussed with HW design team in charge of this IP,
I also bet that this IP won't change in the future.

>
> Am still not happy with the idea of using first SoC for the compatible
> for following reasons:
>
> 1> Generic IPs can be integrated into various vendor SoCs. For example
> synopsis IP can be integrated by ST parts and other non-ST parts. What
> would be the first SoC name in this case?
>
> 2> Looking at example like "arm,pl310-cache", "arm,l220-cache"... or any
> other generic ips, why are these IPs not encoding the first SoC name in
> there compatible string? I think the answer is generic IP.
>
> 3> IMHO, the idea of first SoC might solve the problem you described,
> but why would some one know about the first SoC when this was available.
> In this case this IP was available may be 10+ years back on an ST40
> platform. Having such old SoC names in compatible strings in the device
> trees for a modern chip looks bit confusing.
>
> 4> ST generic drivers which are in kernel still use st,<IP> name, so I
> would like this consistency across all the st drivers (at least the ones
> which are going to be used by mach-sti platforms).
>
> 5> ePAPR spec clearly says that compatible string should contain "most
> specific to most general" names. In this case using more generic name
> makes more sense than having a specific name because its generic IP.
> Allowing a single device driver to match against several devices.
>
> 6> IMHO, the compatible string should be "vendor,<IP-name>-<IP-version>"
> rather than first SoC.
I agree.
In this case, we add support to revision 4 of SSC IP.

Is "st,comms-ssc-v4" okay?


Thanks,
Maxime
