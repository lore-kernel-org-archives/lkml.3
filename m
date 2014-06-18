Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaFRQDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:03:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55459 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaFRQDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:03:52 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <7hzjha8b97.fsf@paris.lan>
Date: Wed, 18 Jun 2014 11:03:44 -0500
Cc: Bjorn Andersson <bjorn@kryo.se>, Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <842A7147-A2CC-42BD-9947-CBADF738DC92@codeaurora.org>
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com> <7hvbrzbh1u.fsf@paris.lan> <CAJAp7OhHr4Cgcp9pvQ3=MAie_zSnFJxG28Vf37qJ98BK7P1jaQ@mail.gmail.com> <7hzjha8b97.fsf@paris.lan>
To: Kevin Hilman <khilman@linaro.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 18, 2014, at 10:53 AM, Kevin Hilman <khilman@linaro.org> wrote:

> Bjorn Andersson <bjorn@kryo.se> writes:
> 
>> On Tue, Jun 17, 2014 at 10:07 AM, Kevin Hilman <khilman@linaro.org> wrote:
>>> +Paul Walmsley
>>> 
>>> Bjorn Andersson <bjorn.andersson@sonymobile.com> writes:
>>> 
>>>> This series adds a regulator driver for the Resource Power Manager found in
>>>> Qualcomm 8660, 8960 and 8064 based devices.
>>>> 
>>>> The RPM driver exposes resources to its child devices, that can be accessed to
>>>> implement drivers for the regulators, clocks and bus frequency control that's
>>>> owned by the RPM in these devices.
>>>> 
>>>> Changes since v2:
>>>>  - Fix copy-paste error in dt binding
>>>>  - Correct incomplete move from mfd to soc
>>>>  - Correct const mistake in regulator driver
>>>> 
>>>> Changes since v1:
>>>>  - Moved rpm driver to drivers/soc
>>> 
>>> I'm not sure I follow the motivation for having this under drivers/soc?
>>> 
>> Hi Kevin,
>> 
>> I've made the argument that to me this is conceptually a black box
>> handling regulators, clocks and other stuff; hence similar to a PMIC,
>> which would fit nicely into drivers/mfd.
>> 
>> I still think this is the case and now that I look back I didn't get
>> any pushback from Lee Jones so maybe the move was premature?
> 
> Yes, IMO, the move was premature, but hopefully the drivers/soc folks
> can chime in an clarify the criteria for inclusion there.
> 
> Kevin

I dont agree, I think having this in drivers/soc means that we can clearly go through drivers/soc in the future and look for patterns across SoCs that should be re-factored.  Where MFD seems like its become the new drivers misc.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

