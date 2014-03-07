Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaCGTEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:04:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60691 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaCGTEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:04:05 -0500
Date: Fri, 7 Mar 2014 13:01:14 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 6/6] documentation: bindings: document PMIC8921/8058 RTC
Message-ID: <20140307190114.GJ18529@joshc.qualcomm.com>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
 <1394047776-13827-7-git-send-email-joshc@codeaurora.org>
 <5317900F.5030803@codeaurora.org>
 <20140306000058.GE18529@joshc.qualcomm.com>
 <5317CFEF.1060003@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5317CFEF.1060003@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 05:31:27PM -0800, Stephen Boyd wrote:
> On 03/05/14 16:00, Josh Cartwright wrote:
> > On Wed, Mar 05, 2014 at 12:58:55PM -0800, Stephen Boyd wrote:
> >> On 03/05/14 11:29, Josh Cartwright wrote:
> >>> diff --git a/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> >>> new file mode 100644
> >>> index 0000000..699bd30
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> >>> @@ -0,0 +1,29 @@
> >>> +* Real-Time Clock for Qualcomm 8058/8921 PMICs
> >>> +
> >>> +Required properties:
> >>> +- compatible: should be one of the following.
> >>> +    * "qcom,pm8058-rtc"
> >>> +    * "qcom,pm8921-rtc"
> >>> +- reg: base address of the register region
> >>> +- reg-names: corresponding reg names for the regions listed in the 'reg'
> >>> +             property, must contain:
> >>> +     "rtc_base" - base of the RTC register region
> >> optional reg-names?
> >>
> >>> +- interrupts: interrupt list for the RTC, must contain a single interrupt
> >>> +              specifier for the alarm interrupt
> >>> +- interrupt-names: corresponding interrupt names for the interrupts listed in
> >>> +                   the 'interrupts' property, must contain:
> >>> +     "alarm" - summary interrupt for PMIC peripherals
> >> optional interrupt-names?
> > It isn't clear to me why these should be made optional, I hope Rob
> > provides some clarification in the sdhci-msm thread.
> 
> Looks like the driver isn't using either of these properties, so I'm not
> sure why they're needed. Maybe they should just be removed.

The driver does make use of platform_get_irq_byname(pdev, "alarm"), and
I expect to make use of platform_get_resource_byname(pdev, IORESOURCE_REG, "rtc_base")
in the near future.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
