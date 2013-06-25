Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab3FYPrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:47:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35008 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYPrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:47:15 -0400
MIME-Version: 1.0
In-Reply-To: <51C9B7B4.6030109@wwwdotorg.org>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
	<1371128132-18266-2-git-send-email-christian.ruppert@abilis.com>
	<51BA3BC1.3090109@wwwdotorg.org>
	<20130614091241.GA23745@ab42.lan>
	<51C1F42E.5090107@wwwdotorg.org>
	<51C1F82C.4020502@wwwdotorg.org>
	<20130620115710.GB942@ab42.lan>
	<51C4C2ED.5090505@wwwdotorg.org>
	<CACRpkdb5uVMBg96T5_CLYDMzs5KGB7a+njWd-OKewTm5D2mz1g@mail.gmail.com>
	<51C9B7B4.6030109@wwwdotorg.org>
Date: Tue, 25 Jun 2013 17:47:14 +0200
Message-ID: <CACRpkdYEiE6_EdDqUES3tOuK0vv3HPTOf14EfG_dyMATGFM-wQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 5:31 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/25/2013 08:56 AM, Linus Walleij wrote:
>> On Fri, Jun 21, 2013 at 11:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 06/20/2013 05:57 AM, Christian Ruppert wrote:
>>
>>>> Your remark seems to reflect one of the following two hardware
>>>> architectures:
>>>>
>>>>                                                      +- SPI
>>>>                  Physical pins --- GPIO --- pinctrl -+- I2C
>>>>                                                      +- mmc
>>>
>>> (that's diagram 1)
>>>
>>>>
>>>>                                 +- GPIO
>>>>                  Physical pins -+           +- SPI
>>>>                                 +- pinctrl -+- I2C
>>>>                                             +- mmc
>>>
>>> (that's diagram 2)
>>>
>>>> TB10x hardware architecture:
>>>>
>>>>                                             +- SPI
>>>>                  Physical pins --- pinctrl -+- I2C
>>>>                                             +- mmc
>>>>                                             +- GPIO
>>>
>>> (that's diagram 3)
>>>
>>> No, I was thinking of diagram 3 above. I'm not sure if diagrams (1) or
>>> (2) are common or exist?
>>
>> The U300 pin controller is obviously of type (1) as it can spy on
>> the signals.
>
> U300 HW might be diagram (1) - I can't say since I'm not familiar with
> the HW. However, the fact that GPIO can spy on signals in no way at all
> implies that the HW must conform to diagram (1).

That's true. And I don't know what it actually is in this case.
That hardware is actually weird in many ways, thanks to
helpful HW engineers modeling use cases into the HW.

>> The Nomadik pin controller is basically type (2).

This I know however to be true, as I have access to the
low-level schematics of the ASIC.

Yours,
Linus Walleij
