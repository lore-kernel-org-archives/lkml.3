Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3JQOiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:38:15 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:49131 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756782Ab3JQOiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:38:02 -0400
Message-ID: <525FF498.3060202@st.com>
Date: Thu, 17 Oct 2013 15:30:48 +0100
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Maxime COQUELIN <maxime.coquelin@st.com>, Wolfram Sang <wsa@the-dreams.de>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Stuart MENEFY <stuart.menefy@st.com>, Lee Jones <lee.jones@linaro.org>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Subject: Re: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com> <1381754813-4679-2-git-send-email-maxime.coquelin@st.com> <20131016151419.GA14104@ns203013.ovh.net> <525F915D.9020501@st.com> <525FAEED.7030207@st.com> <20131017141957.GE14104@ns203013.ovh.net>
In-Reply-To: <20131017141957.GE14104@ns203013.ovh.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/13 15:19, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 10:33 Thu 17 Oct     , srinivas kandagatla wrote:
>> On 17/10/13 08:27, Maxime COQUELIN wrote:
>>> ...
>>>>>>> +
>>>>>>> +static struct of_device_id st_i2c_match[] = {
>>>>>>> +     { .compatible = "st,comms-ssc-i2c", },
>>>>> the rules is to put the first soc that use the ip in the compatible
>>>>> as st,sti7100-scc-i2c
>>> Ok. There are no plans to upstream the SH4 platforms, it will only 
>>> remains in stlinux.com.
>>> Maybe I can set the first ARM platform (STiH415)?
>>> That would give st,stih415-ssc-i2c.
>> NAK, for st,stih415-ssc-i2c naming.
>>
>> IMO, this makes sense when the same IP integration done on different SOC
>> changes slightly/very differently.
>>
>> But in this case the "comms" IP remains unchanged across all the SOCs.
>>
>> I would still prefer "st,comms-ssc-i2c", allowing a single device driver
>> to match against several SoCs. ST "comms" IP it is integrated across all
>> the STi series of SoCs, so we don't want to add new entry in compatible
>> for every new SOC.
> 
> you never need this you always the first SoC that's all

Sorry to ask this but, Where is this requirement coming from?
I have not spotted any thing as such in ePAPR specs.


All the spec says is.
===
The compatible property value consists of one or more strings that
define the specific programming model for the device. This list of
strings should be used by a client program for device driver selection.
The property value consists of a concatenated list of null terminated
strings, *from most specific to most general.* They allow a device to
express its compatibility with a family of similar devices, potentially
allowing a single device driver to match against several devices.
The recommended format is “manufacturer,model”, where manufacturer is a
string describing the name of the manufacturer (such as an OUI), and
model specifies the model number.

Example:
compatible = “fsl,mpc8641-uart”, “ns16550";
In this example, an operating system would first try to locate a device
driver that supported fsl,mpc8641-uart. If a driver was not found, it
would then try to locate a driver that supported the more general
ns16550 device type.
===

The more general compatible string in this case is "st,comms-ssc-i2c",
rather than the first soc name.
How can a first SOC name be more general?

As this driver is not very specific to StiH415, it is generic driver for
ST comms-ssc-i2c block.

Thanks,
srini




> 
> see other bindings on at91 as example sorry NACK
> 
> Best Regards,
> J.
>>
>>
>> Thanks,
>> srini
>>
>>>
>>> Thanks for the review,
>>> Maxime
>>>
>>>>>
>>
> 
> 

