Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551Ab3LIVhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:37:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54404 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab3LIVhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:37:47 -0500
Message-ID: <52A63829.10509@codeaurora.org>
Date: Mon, 09 Dec 2013 13:37:45 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] pinctrl: Add msm8x74 configuration
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>	<1386295805-13708-3-git-send-email-bjorn.andersson@sonymobile.com>	<52A24E08.706@codeaurora.org> <CACRpkdb+9DE6WNfBSp9Y8ErhHjaE-PdezJbYvsLLhiCjXfmA-A@mail.gmail.com>
In-Reply-To: <CACRpkdb+9DE6WNfBSp9Y8ErhHjaE-PdezJbYvsLLhiCjXfmA-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/13 00:18, Linus Walleij wrote:
> On Fri, Dec 6, 2013 at 11:22 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 12/05/13 18:10, Bjorn Andersson wrote:
> As the driver is merged I expect fixes to come in as additional patches.
>
>>> Add initial definition of parameters for pinctrl-msm for the msm8x74
>>> platform.
>> Hmm. We've tried to remove 'x' from our code because it isn't really
>> accurate and leads to more confusion.
> So does this pin controller have a real name in the data sheet?

We call it TLMM (top-level mode mux). So far there have been three major
revisions of the hardware and 8974 uses the latest version.

>
> I usually prefer to name the drivers after the name of the IP
> block rather than the SoC if possible.
>
> Or should it just be named pinctrl-msm.c?

Leaving the pinctrl-msm.c file as in these patches is fine. For the SoC
specific data files we should use the base chip name which in this case
is 8974. I suppose the goal of pinctrl-msm8x74.c is to support 8974 and
8074 SoCs in the same file because they're almost exactly the same minus
some pins losing their "modem" functions. Given that, the file names are
fine but the binding and the data structures should be specific about
which SoC we're talking about.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

