Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3ISPcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 11:32:54 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:47146 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3ISPcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 11:32:52 -0400
Date: Thu, 19 Sep 2013 16:32:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
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
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Olivier CLERGEAUD <olivier.clergeaud@st.com>
Subject: Re: [PATCH 2/4] ARM: STi: Supply I2C configuration to STiH416 SoC
Message-ID: <20130919153237.GA7071@lee--X1>
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com>
 <1379498483-4236-3-git-send-email-maxime.coquelin@st.com>
 <20130918120340.GF16984@lee--X1>
 <84625B87D65BCF478CC1E9C886A4C314DEF1BD9578@SAFEX1MAIL4.st.com>
 <5239A322.5010004@st.com>
 <84625B87D65BCF478CC1E9C886A4C314DEF1BD9579@SAFEX1MAIL4.st.com>
 <523AF548.30400@st.com>
 <84625B87D65BCF478CC1E9C886A4C314DEF1BD957D@SAFEX1MAIL4.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84625B87D65BCF478CC1E9C886A4C314DEF1BD957D@SAFEX1MAIL4.st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Am not very comfortable with this idea.
> >
> > As there is no guarantee that the interrupt number/memory map and the
> > i2c numbering will be same in future SOCs or other IPs.
> >
> > You might be already aware that the number of i2cs on each SOC are
> > different as example on STiH415 we have 10 SSCs and on STiH416 we have
> > 11 SSCs. So, At what point you decide that which devices/IPs should be
> > in stih41x and which should in stih415/Stih416?
> Yes, I know there is one more SSC on STiH416.
> 
> On one hand, this could add some confusion. But on the other hand,
> someone who will need to activate a SSP will know which one he has
> to activate.
> 
> > Each i2c node will save around 5 lines if we common it up, but if the
> > interrupt number or map changes this difference will be negligible.
> >
> > Common up at this level and mixing un-common ones in stih415.dtsi or
> > stih416.dtsi will add confusion to readers as the information is split
> > at multiple places.
> I agree it will be messy if one part of the node declared at one place,
> and the rest at another place.
> >
> > IMO the common up idea sounds good but reduces the readability and has
> > no effect on final dtb size.
> 
> Fair enough. Lee, are you ok with keeping it as is?

To be honest I haven't taken a look at the layout of the dts[i] files
yet, so I can't really comment. Srini knows then better than anyone,
so if he says it doesn't make sense, then I'm happy to take his word
for it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
