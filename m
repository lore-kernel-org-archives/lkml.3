Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3JQJl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:41:58 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:52613 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753583Ab3JQJly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:41:54 -0400
Message-ID: <525FAEED.7030207@st.com>
Date: Thu, 17 Oct 2013 10:33:33 +0100
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Wolfram Sang <wsa@the-dreams.de>,
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
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com> <1381754813-4679-2-git-send-email-maxime.coquelin@st.com> <20131016151419.GA14104@ns203013.ovh.net> <525F915D.9020501@st.com>
In-Reply-To: <525F915D.9020501@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/13 08:27, Maxime COQUELIN wrote:
> ...
>>> >> +
>>> >> +static struct of_device_id st_i2c_match[] = {
>>> >> +     { .compatible = "st,comms-ssc-i2c", },
>> > the rules is to put the first soc that use the ip in the compatible
>> > as st,sti7100-scc-i2c
> Ok. There are no plans to upstream the SH4 platforms, it will only 
> remains in stlinux.com.
> Maybe I can set the first ARM platform (STiH415)?
> That would give st,stih415-ssc-i2c.
NAK, for st,stih415-ssc-i2c naming.

IMO, this makes sense when the same IP integration done on different SOC
changes slightly/very differently.

But in this case the "comms" IP remains unchanged across all the SOCs.

I would still prefer "st,comms-ssc-i2c", allowing a single device driver
to match against several SoCs. ST "comms" IP it is integrated across all
the STi series of SoCs, so we don't want to add new entry in compatible
for every new SOC.


Thanks,
srini

> 
> Thanks for the review,
> Maxime
> 
>> >

