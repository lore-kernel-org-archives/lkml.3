Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaCJPf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:35:29 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:35533 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaCJPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:35:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140306000058.GE18529@joshc.qualcomm.com>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
	<1394047776-13827-7-git-send-email-joshc@codeaurora.org>
	<5317900F.5030803@codeaurora.org>
	<20140306000058.GE18529@joshc.qualcomm.com>
Date: Mon, 10 Mar 2014 10:35:25 -0500
Message-ID: <CAL_JsqJU-vb8CAat+X-WtW9rDPzqj9oDfpXf8pEwuwLVtOskPA@mail.gmail.com>
Subject: Re: [PATCH 6/6] documentation: bindings: document PMIC8921/8058 RTC
From: Rob Herring <robherring2@gmail.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 6:00 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> On Wed, Mar 05, 2014 at 12:58:55PM -0800, Stephen Boyd wrote:
>> On 03/05/14 11:29, Josh Cartwright wrote:
>> > diff --git a/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
>> > new file mode 100644
>> > index 0000000..699bd30
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
>> > @@ -0,0 +1,29 @@
>> > +* Real-Time Clock for Qualcomm 8058/8921 PMICs
>> > +
>> > +Required properties:
>> > +- compatible: should be one of the following.
>> > +    * "qcom,pm8058-rtc"
>> > +    * "qcom,pm8921-rtc"
>> > +- reg: base address of the register region
>> > +- reg-names: corresponding reg names for the regions listed in the 'reg'
>> > +             property, must contain:
>> > +     "rtc_base" - base of the RTC register region
>>
>> optional reg-names?
>>
>> > +- interrupts: interrupt list for the RTC, must contain a single interrupt
>> > +              specifier for the alarm interrupt
>> > +- interrupt-names: corresponding interrupt names for the interrupts listed in
>> > +                   the 'interrupts' property, must contain:
>> > +     "alarm" - summary interrupt for PMIC peripherals
>>
>> optional interrupt-names?
>
> It isn't clear to me why these should be made optional, I hope Rob
> provides some clarification in the sdhci-msm thread.

Because reg and interrupt names are relatively new and reluctantly
added by DT maintainers. Personally, I think it was a mistake and it
is simply Linux specific information leaking into the DT, but it did
make transition to DT easier. The requirement is still the ordering of
reg and interrupts fields must be defined and you cannot rely on the
names to define the order. It is quite pointless here since you only
have 1 field.

Rob
