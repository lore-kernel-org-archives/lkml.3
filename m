Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab3JQR5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:57:25 -0400
Received: from 11.mo5.mail-out.ovh.net ([46.105.47.167]:43322 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758575Ab3JQR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:57:23 -0400
X-Greylist: delayed 12071 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2013 13:57:23 EDT
Date: Thu, 17 Oct 2013 16:19:57 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: srinivas kandagatla <srinivas.kandagatla@st.com>
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
Message-ID: <20131017141957.GE14104@ns203013.ovh.net>
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>
 <1381754813-4679-2-git-send-email-maxime.coquelin@st.com>
 <20131016151419.GA14104@ns203013.ovh.net>
 <525F915D.9020501@st.com>
 <525FAEED.7030207@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525FAEED.7030207@st.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 17412886485272669146
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrfedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrfedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:33 Thu 17 Oct     , srinivas kandagatla wrote:
> On 17/10/13 08:27, Maxime COQUELIN wrote:
> > ...
> >>> >> +
> >>> >> +static struct of_device_id st_i2c_match[] = {
> >>> >> +     { .compatible = "st,comms-ssc-i2c", },
> >> > the rules is to put the first soc that use the ip in the compatible
> >> > as st,sti7100-scc-i2c
> > Ok. There are no plans to upstream the SH4 platforms, it will only 
> > remains in stlinux.com.
> > Maybe I can set the first ARM platform (STiH415)?
> > That would give st,stih415-ssc-i2c.
> NAK, for st,stih415-ssc-i2c naming.
> 
> IMO, this makes sense when the same IP integration done on different SOC
> changes slightly/very differently.
> 
> But in this case the "comms" IP remains unchanged across all the SOCs.
> 
> I would still prefer "st,comms-ssc-i2c", allowing a single device driver
> to match against several SoCs. ST "comms" IP it is integrated across all
> the STi series of SoCs, so we don't want to add new entry in compatible
> for every new SOC.

you never need this you always the first SoC that's all

see other bindings on at91 as example sorry NACK

Best Regards,
J.
> 
> 
> Thanks,
> srini
> 
> > 
> > Thanks for the review,
> > Maxime
> > 
> >> >
> 
