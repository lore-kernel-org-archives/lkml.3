Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbaHNWhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 18:37:54 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:45686 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbaHNWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 18:37:52 -0400
MIME-Version: 1.0
In-Reply-To: <1408000853-2764-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1408000853-2764-1-git-send-email-kiran.padwal@smartplayin.com>
Date: Thu, 14 Aug 2014 15:37:51 -0700
Message-ID: <CAJAp7OiXaumG1Bke2_uuCYX=KvEdckLCct56H4U+rttWhE2P5w@mail.gmail.com>
Subject: Re: [PATCH] ARM: apq8064: Add pinmux and i2c pinctrl nodes
From: Bjorn Andersson <bjorn@kryo.se>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 12:20 AM, Kiran Padwal
<kiran.padwal@smartplayin.com> wrote:
> diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
> index 92bf793..fbebf5c 100644
> --- a/arch/arm/boot/dts/qcom-apq8064.dtsi
> +++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
> @@ -70,6 +70,17 @@
>                 ranges;
>                 compatible = "simple-bus";
>
> +               qcom_pinmux: pinmux@800000 {

There are (at least) three different pinmuxes in these platforms: TLMM, PMIC
GPIO, PMIC MPP. Also this is the phandle that is used to reference the gpio
chip throughout the board.

So I would like to suggest that we name it "tlmm" or like in the downstream
kernel "msmgpio".

> +                       compatible = "qcom,apq8064-pinctrl";
> +                       reg = <0x800000 0x4000>;
> +
> +                       gpio-controller;
> +                       #gpio-cells = <2>;
> +                       interrupt-controller;
> +                       #interrupt-cells = <2>;
> +                       interrupts = <0 32 0x4>;

I must have gotten this wrong in the dt binding example, sorry about that.
interrupts should be <0 16 0x4>.

> +               };

Regards,
Bjorn
