Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3FGLqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:46:35 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:61792 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3FGLqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <201306062108.38587.heiko@sntech.de>
References: <201306062107.58875.heiko@sntech.de>
	<201306062108.38587.heiko@sntech.de>
Date: Fri, 7 Jun 2013 13:46:32 +0200
Message-ID: <CACRpkda+QwnhCHBhQ3d-zUE9dD75Rv0_qt02h6prrzCBzNm5zw@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] clk: flag to use upper half of the register as
 change indicator
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 9:08 PM, Heiko Stübner <heiko@sntech.de> wrote:

> There exist platforms, namely at least all Rockchip Cortex-A9 based ones,
> that don't use the paradigm of reading-changing-writing the register contents,
> but instead only write the changes to the register with a mask that indicates
> the changed bits.
>
> This patch adds flags and code to support the case where the lower 16 bit of
> hold the information and the upper 16 bit are used as mask to indicate the
> written changes.
>
> As hardware-specific flags should not be added to the common clk flags, the
> flags are added to gate, mux and divider clocks individually.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
(...)
> +       if ((clk_gate_flags & CLK_GATE_MASK_UPPER_HALF) && bit_idx > 15) {
> +               pr_err("%s: bit_idx %d invalid\n", __func__, bit_idx);
> +               return ERR_PTR(-EINVAL);
> +       }

Now this looks *EXTREMELY* familiar to a patch just sent by Haojian
for HiSilicon.

"[PATCH v2 3/6] clk: divider: add CLK_DIVIDER_HIWORD_MASK flag"
http://marc.info/?l=linux-arm-kernel&m=137035873916777&w=2

What kind of coincidence is this? Are Rockchip and HiSilicon using
the same silicon IP or are they of a common origin? (It is a small
world after all.)

I think you two guys need to read each others patch sets closely
here. I'd like Haojian to look at Heiko's patches and Heiko to look
at Haojian's patches, just to make sure you're not actually writing
two drivers for the same hardware in the end.

Yours,
Linus Walleij
