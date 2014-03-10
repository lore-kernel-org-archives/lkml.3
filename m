Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaCJWOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:14:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55285 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaCJWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:14:29 -0400
Date: Mon, 10 Mar 2014 17:11:32 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        rtc-linux@googlegroups.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2 6/6] documentation: bindings: document PMIC8921/8058
 RTC
Message-ID: <20140310221132.GN18529@joshc.qualcomm.com>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
 <1394477089-3996-7-git-send-email-joshc@codeaurora.org>
 <CAL_JsqJe7M6i0RKWVPHbvyHbHscMtZmW-xbJuaJTePqYRKWrUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJe7M6i0RKWVPHbvyHbHscMtZmW-xbJuaJTePqYRKWrUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:22:51PM -0500, Rob Herring wrote:
> On Mon, Mar 10, 2014 at 1:44 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> > This RTC is found on the Qualcomm 8921 and 8058 PMICs.
> >
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > ---
> >  .../devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt     | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> >
> > diff --git a/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> > new file mode 100644
> > index 0000000..3eaa582
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> > @@ -0,0 +1,21 @@
> > +* Real-Time Clock for Qualcomm 8058/8921 PMICs
> > +
> > +Required properties:
> > +- compatible: should be one of the following.
> > +    * "qcom,pm8058-rtc"
> > +    * "qcom,pm8921-rtc"
> > +- reg: base address of the register region
> 
> Wait a second. This is all part of an MFD device. I think this whole
> binding does not make sense on it's own. The DT should describe the
> PMIC, not necessarily some sub-component of it. Perhaps there are sub
> nodes of the PMIC node, but that would be all part of the PMIC
> binding. Having sub drivers for an MFD is really a Linux problem that
> doesn't belong in DT.

Okay, this makes sense, I can move this documentation to
Documentation/bindings/mfd/qcom,pm8xxx.txt where the PMIC binding
currently is.

Note that this does introduce a dependency on Lee Jones' mfd tree, where
DT support for the parent pm8921 driver is pending for 3.15.

Andrew, how would you prefer I proceed?  Would you like me to respin
this patch?  The whole series?  An incremental patch?

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
