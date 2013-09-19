Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3ISHS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:18:28 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:45345 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784Ab3ISHS0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:18:26 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
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
Date: Thu, 19 Sep 2013 09:16:27 +0200
Subject: Re: [PATCH 2/4] ARM: STi: Supply I2C configuration to STiH416 SoC
Thread-Topic: [PATCH 2/4] ARM: STi: Supply I2C configuration to STiH416 SoC
Thread-Index: AQHOtQgo5KmvX3sF7Eefywdx+54/jg==
Message-ID: <84625B87D65BCF478CC1E9C886A4C314DEF1BD9579@SAFEX1MAIL4.st.com>
References: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com>
 <1379498483-4236-3-git-send-email-maxime.coquelin@st.com>
 <20130918120340.GF16984@lee--X1>
 <84625B87D65BCF478CC1E9C886A4C314DEF1BD9578@SAFEX1MAIL4.st.com>
 <5239A322.5010004@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srini,

On 09/18/2013 03:17 PM, Srinivas KANDAGATLA wrote:
> On 18/09/13 13:46, Maxime COQUELIN wrote:
>> On 09/18/2013 02:03 PM, Lee Jones wrote:
>>>>>> This patch supplies I2C configuration to STiH416 SoC.
>>>>>>
>>>>>> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>>>>>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>>>>>> ---
>>>>>>  arch/arm/boot/dts/stih416-pinctrl.dtsi |   35 ++++++++++++++++++++
>>>>>>  arch/arm/boot/dts/stih416.dtsi         |   57 ++++++++++++++++++++++++++++++++
>>>>>>  2 files changed, 92 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
>>>> I genuinely don't know the answer to this question, but are these
>>>> nodes identical to the ones you've just put in the stih415 DTSI file?
>>>> If so, I think it will be worth creating a stih41x DTSI rather than
>>>> duplicating lots of stuff unnecessarily.
>> There are close to be identical indeed.
>> For the clocks and pinctrl, the references names are the same, but they are
>> pointing on different nodes, as STiH415 and STiH416 have their own
>> clocks and pinctrl dtsi files.
>>
>> Srini, what is opinion about this?
> There is already a stih41x.dtsi file, but I don't think it is the right
> place for the pinctrl nodes there.
>
> Am not OK with the idea of common pinctrl nodes for STiH415 and STiH416
> for two reasons.
>
> 1> If we common up the pinctrl nodes, it will be very difficult to
> accommodate new pinctrls layout which is not guaranteed to be in same
> layout in future SOCs.
>
> 2> The retiming values in the pinctrl nodes tend to change as per SOC,
> so it will be difficult to manage it if we common it up.
>
> Am sure we can come up with a dt layout which can reduce duplication,
> but we have to be careful here not to lose the flexiblity to accommodate
> new picntrl layouts, new retimings values based on SOC.
Ok. What do you think of declaring the i2c nodes inside the stih41x.dtsi
file,
and overload them with the pinctrl and clock properties in the stih416
and stih415 dtsi files?

Regards,
Maxime
>
>
> thanks,
> srini
>
>

