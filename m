Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3IRNSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:18:30 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:44641 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623Ab3IRNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:18:27 -0400
Message-ID: <5239A322.5010004@st.com>
Date: Wed, 18 Sep 2013 13:57:06 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
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
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com> <1379498483-4236-3-git-send-email-maxime.coquelin@st.com> <20130918120340.GF16984@lee--X1> <84625B87D65BCF478CC1E9C886A4C314DEF1BD9578@SAFEX1MAIL4.st.com>
In-Reply-To: <84625B87D65BCF478CC1E9C886A4C314DEF1BD9578@SAFEX1MAIL4.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/13 13:46, Maxime COQUELIN wrote:
> On 09/18/2013 02:03 PM, Lee Jones wrote:
>>> >> This patch supplies I2C configuration to STiH416 SoC.
>>> >>
>>> >> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>> >> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>>> >> ---
>>> >>  arch/arm/boot/dts/stih416-pinctrl.dtsi |   35 ++++++++++++++++++++
>>> >>  arch/arm/boot/dts/stih416.dtsi         |   57 ++++++++++++++++++++++++++++++++
>>> >>  2 files changed, 92 insertions(+)
>>> >>
>>> >> diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
>> > I genuinely don't know the answer to this question, but are these
>> > nodes identical to the ones you've just put in the stih415 DTSI file?
>> > If so, I think it will be worth creating a stih41x DTSI rather than
>> > duplicating lots of stuff unnecessarily.
> There are close to be identical indeed.
> For the clocks and pinctrl, the references names are the same, but they are
> pointing on different nodes, as STiH415 and STiH416 have their own
> clocks and pinctrl dtsi files.
> 
> Srini, what is opinion about this?

There is already a stih41x.dtsi file, but I don't think it is the right
place for the pinctrl nodes there.

Am not OK with the idea of common pinctrl nodes for STiH415 and STiH416
for two reasons.

1> If we common up the pinctrl nodes, it will be very difficult to
accommodate new pinctrls layout which is not guaranteed to be in same
layout in future SOCs.

2> The retiming values in the pinctrl nodes tend to change as per SOC,
so it will be difficult to manage it if we common it up.

Am sure we can come up with a dt layout which can reduce duplication,
but we have to be careful here not to lose the flexiblity to accommodate
new picntrl layouts, new retimings values based on SOC.


thanks,
srini

>> >

