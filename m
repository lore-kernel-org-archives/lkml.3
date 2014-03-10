Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaCJWSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:18:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaCJWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:18:09 -0400
Date: Mon, 10 Mar 2014 15:18:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>,
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
Message-Id: <20140310151807.7274d58d3c50b884585244b6@linux-foundation.org>
In-Reply-To: <20140310221132.GN18529@joshc.qualcomm.com>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
	<1394477089-3996-7-git-send-email-joshc@codeaurora.org>
	<CAL_JsqJe7M6i0RKWVPHbvyHbHscMtZmW-xbJuaJTePqYRKWrUg@mail.gmail.com>
	<20140310221132.GN18529@joshc.qualcomm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014 17:11:32 -0500 Josh Cartwright <joshc@codeaurora.org> wrote:

> On Mon, Mar 10, 2014 at 04:22:51PM -0500, Rob Herring wrote:
> > On Mon, Mar 10, 2014 at 1:44 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> > > This RTC is found on the Qualcomm 8921 and 8058 PMICs.
> > >
> > > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > > ---
> > >  .../devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt     | 21 +++++++++++++++++++++
> > >  1 file changed, 21 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> > >
> > > diff --git a/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> > > new file mode 100644
> > > index 0000000..3eaa582
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> > > @@ -0,0 +1,21 @@
> > > +* Real-Time Clock for Qualcomm 8058/8921 PMICs
> > > +
> > > +Required properties:
> > > +- compatible: should be one of the following.
> > > +    * "qcom,pm8058-rtc"
> > > +    * "qcom,pm8921-rtc"
> > > +- reg: base address of the register region
> > 
> > Wait a second. This is all part of an MFD device. I think this whole
> > binding does not make sense on it's own. The DT should describe the
> > PMIC, not necessarily some sub-component of it. Perhaps there are sub
> > nodes of the PMIC node, but that would be all part of the PMIC
> > binding. Having sub drivers for an MFD is really a Linux problem that
> > doesn't belong in DT.
> 
> Okay, this makes sense, I can move this documentation to
> Documentation/bindings/mfd/qcom,pm8xxx.txt where the PMIC binding
> currently is.
> 
> Note that this does introduce a dependency on Lee Jones' mfd tree, where
> DT support for the parent pm8921 driver is pending for 3.15.
> 
> Andrew, how would you prefer I proceed?  Would you like me to respin
> this patch?  The whole series?  An incremental patch?

A new version of [6/6] sounds appropriate.
