Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaCJVWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:22:55 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:33026 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaCJVWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:22:52 -0400
MIME-Version: 1.0
In-Reply-To: <1394477089-3996-7-git-send-email-joshc@codeaurora.org>
References: <1394477089-3996-1-git-send-email-joshc@codeaurora.org>
	<1394477089-3996-7-git-send-email-joshc@codeaurora.org>
Date: Mon, 10 Mar 2014 16:22:51 -0500
Message-ID: <CAL_JsqJe7M6i0RKWVPHbvyHbHscMtZmW-xbJuaJTePqYRKWrUg@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] documentation: bindings: document PMIC8921/8058 RTC
From: Rob Herring <robherring2@gmail.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        rtc-linux@googlegroups.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 1:44 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> This RTC is found on the Qualcomm 8921 and 8058 PMICs.
>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  .../devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt     | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
>
> diff --git a/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> new file mode 100644
> index 0000000..3eaa582
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/qcom,pm8xxx-rtc.txt
> @@ -0,0 +1,21 @@
> +* Real-Time Clock for Qualcomm 8058/8921 PMICs
> +
> +Required properties:
> +- compatible: should be one of the following.
> +    * "qcom,pm8058-rtc"
> +    * "qcom,pm8921-rtc"
> +- reg: base address of the register region

Wait a second. This is all part of an MFD device. I think this whole
binding does not make sense on it's own. The DT should describe the
PMIC, not necessarily some sub-component of it. Perhaps there are sub
nodes of the PMIC node, but that would be all part of the PMIC
binding. Having sub drivers for an MFD is really a Linux problem that
doesn't belong in DT.

Rob
