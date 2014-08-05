Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaHEBgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:36:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43947 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbaHEBgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:36:19 -0400
Message-ID: <53E0350C.4020003@codeaurora.org>
Date: Mon, 04 Aug 2014 18:36:12 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: David Collins <collinsd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] pinctrl: qpnp: Qualcomm PMIC pin controller driver
References: <1405610748-7583-1-git-send-email-iivanov@mm-sol.com>  <1405610748-7583-3-git-send-email-iivanov@mm-sol.com>  <53D307BB.1020208@codeaurora.org> <1406536774.2475.36.camel@iivanov-dev>
In-Reply-To: <1406536774.2475.36.camel@iivanov-dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/14 01:39, Ivan T. Ivanov wrote:
> I am working on proposal from Stephen Boyd to encode GPIO/MPP mode and 
> source select into combined function. Something like this one:
>
> #define PM8XXX_DIGITAL_IN		0
> #define PM8XXX_DIGITAL_OUT		1
> #define PM8XXX_DIGITAL_IN_OUT		2
>
> ...
>
> /* mode and source select */
> #define PM8XXX_FUNCTION(m,s)		((m) << 16 | (s))
>
> #define PM8921_GPIO1_14_KYPD_SNS	PM8XXX_FUNCTION(PM8XXX_DIGITAL_IN, 1)
> #define PM8921_GPIO9_14_KYPD_DRV	PM8XXX_FUNCTION(PM8XXX_DIGITAL_OUT, 1)
> #define PM8921_GPIO33_35_PWM		PM8XXX_FUNCTION(PM8XXX_DIGITAL_OUT, 3)
>
> ..
>
>

This isn't what I was suggesting at all. The function should be
something like KYPD, PWM and those should just be defined to be 1 or 3.
The mode should be some other property like input or output, and the
driver should or the two together and put it into the register.
Basically we shouldn't see any shifts or ors in the #defines, just
convenient numbers that correspond to the value of the field in the
register.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

