Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3K2THO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 14:07:14 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45270 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3K2THM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 14:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <1385727565-25794-15-git-send-email-lee.jones@linaro.org>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
	<1385727565-25794-15-git-send-email-lee.jones@linaro.org>
Date: Fri, 29 Nov 2013 20:07:11 +0100
Message-ID: <CACRpkdaWXBchz78Yby11VpveBDtn6FrmupS=cnNYhvHgFJsBUw@mail.gmail.com>
Subject: Re: [PATCH v3 14/36] mtd: st_spi_fsm: Add device-tree binding documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 1:19 PM, Lee Jones <lee.jones@linaro.org> wrote:

Re this:

> +Optional properties:
> +  - st,syscfg          : Phandle to boot-device system configuration registers
> +  - st,boot-device-reg : Address of the aforementioned boot-device register(s)
> +  - st,boot-device-spi : Expected boot-device value if booted via this device
> +
> +Example:
> +       spifsm: spifsm@fe902000{
> +               compatible         = "st,spi-fsm";
> +               reg                =  <0xfe902000 0x1000>;
> +               reg-names          = "spi-fsm";
> +               pinctrl-0          = <&pinctrl_fsm>;
> +               st,syscfg          = <&syscfg_rear>;
> +               st,boot-device-reg = <0x958>;
> +               st,boot-device-spi = <0x1a>;

I don't think we should encode any register offsets whatsoever in device
tree but maybe that's just me. (Yes, Stephen will beat me up about
pin control single, but I consider that a special case.)

I would just put the last two things as #defines into the driver file(s)
or - if it's related to other syscfg registers and varies with SoC incarnation,
as a #define in a shared header for that syscfg thing.

The syscfg phandle is elegant though, really like that.

Yours,
Linus Walleij
