Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbaCFADt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:03:49 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53215 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820AbaCFADq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:03:46 -0500
Date: Wed, 5 Mar 2014 18:00:58 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 6/6] documentation: bindings: document PMIC8921/8058 RTC
Message-ID: <20140306000058.GE18529@joshc.qualcomm.com>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
 <1394047776-13827-7-git-send-email-joshc@codeaurora.org>
 <5317900F.5030803@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5317900F.5030803@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 12:58:55PM -0800, Stephen Boyd wrote:
> On 03/05/14 11:29, Josh Cartwright wrote:
> > diff --git a/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> > new file mode 100644
> > index 0000000..699bd30
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> > @@ -0,0 +1,29 @@
> > +* Real-Time Clock for Qualcomm 8058/8921 PMICs
> > +
> > +Required properties:
> > +- compatible: should be one of the following.
> > +    * "qcom,pm8058-rtc"
> > +    * "qcom,pm8921-rtc"
> > +- reg: base address of the register region
> > +- reg-names: corresponding reg names for the regions listed in the 'reg'
> > +             property, must contain:
> > +     "rtc_base" - base of the RTC register region
> 
> optional reg-names?
> 
> > +- interrupts: interrupt list for the RTC, must contain a single interrupt
> > +              specifier for the alarm interrupt
> > +- interrupt-names: corresponding interrupt names for the interrupts listed in
> > +                   the 'interrupts' property, must contain:
> > +     "alarm" - summary interrupt for PMIC peripherals
> 
> optional interrupt-names?

It isn't clear to me why these should be made optional, I hope Rob
provides some clarification in the sdhci-msm thread.

> > +
> > +Option properties:

Woops, this should be "Optional" :).

> > +- linux,allow-set-time: indicates that the setting of RTC time is allowed by
> > +                        the host CPU
> 
> Is this a "linux" property? It seems like something that other OSes
> would want to know about and doesn't require any explicit knowledge
> about operating  system things (like keymaps for example).

Yeah, I wasn't quite sure how to name this property.  It's
Linux-specific in the sense that the underlying operation method is
"set_time", but I agree this should be named something else...

How do you feel about simply "allow-set-time"?

> 
> > +
> > +Example:
> > +
> > +	rtc {
> 
> rtc@11d

Yep, thanks.

> > +		compatible = "qcom,pm8921-rtc";
> > +		reg = <0x11D>;
> > +		reg-names = "rtc_base";
> > +		interrupts = <0x27 0>;
> > +		interrupt-names = "alarm";
> > +	};
> >

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
