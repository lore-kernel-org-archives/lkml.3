Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3KBBEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 21:04:21 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:34064 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3KBBEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 21:04:20 -0400
MIME-Version: 1.0
In-Reply-To: <1383343739-23080-3-git-send-email-sboyd@codeaurora.org>
References: <1383343739-23080-1-git-send-email-sboyd@codeaurora.org>
	<1383343739-23080-3-git-send-email-sboyd@codeaurora.org>
Date: Fri, 1 Nov 2013 20:04:19 -0500
Message-ID: <CAL_JsqLObXEWJJ=SuifTjpPz9qTW0n43fyQNA-vjLNeLy-7-XA@mail.gmail.com>
Subject: Re: [PATCH 02/11] devicetree: bindings: Document Qualcomm cpus and enable-method
From: Rob Herring <robherring2@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 5:08 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> From: Rohit Vaswani <rvaswani@codeaurora.org>
>
> Scorpion and Krait are Qualcomm cpus. These cpus don't use the
> spin-table enable-method. Instead they rely on mmio register
> accesses to enable power and clocks to bring CPUs out of reset.
>
> Cc: <devicetree@vger.kernel.org>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> [sboyd: Split off into separate patch, renamed method to
> qcom,mmio]
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> This slightly conflicts with my krait EDAC series.
>
>  Documentation/devicetree/bindings/arm/cpus.txt | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 37258f9..e2969fa2 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -44,6 +44,8 @@ For the ARM architecture every CPU node must contain the following properties:
>                 "marvell,mohawk"
>                 "marvell,xsc3"
>                 "marvell,xscale"
> +               "qcom,scorpion"
> +               "qcom,krait"
>
>  And the following optional properties:
>
> @@ -52,6 +54,7 @@ And the following optional properties:
>                  different types of cpus.
>                  This should be one of:
>                  "spin-table"
> +                "qcom,mmio"

Not exactly specific. How would you handle variations in the enable
method? The mmio method to enable is tied to the core type or SOC
type?

Rob
