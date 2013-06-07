Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3FGM1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:27:33 -0400
Received: from gloria.sntech.de ([95.129.55.99]:48387 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab3FGM1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:27:32 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: Re: [PATCH v2 1/8] clk: flag to use upper half of the register as change indicator
Date: Fri, 7 Jun 2013 14:27:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
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
References: <201306062107.58875.heiko@sntech.de> <201306062108.38587.heiko@sntech.de> <CACRpkda+QwnhCHBhQ3d-zUE9dD75Rv0_qt02h6prrzCBzNm5zw@mail.gmail.com>
In-Reply-To: <CACRpkda+QwnhCHBhQ3d-zUE9dD75Rv0_qt02h6prrzCBzNm5zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306071427.20512.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 7. Juni 2013, 13:46:32 schrieb Linus Walleij:
> On Thu, Jun 6, 2013 at 9:08 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > There exist platforms, namely at least all Rockchip Cortex-A9 based ones,
> > that don't use the paradigm of reading-changing-writing the register
> > contents, but instead only write the changes to the register with a mask
> > that indicates the changed bits.
> > 
> > This patch adds flags and code to support the case where the lower 16 bit
> > of hold the information and the upper 16 bit are used as mask to
> > indicate the written changes.
> > 
> > As hardware-specific flags should not be added to the common clk flags,
> > the flags are added to gate, mux and divider clocks individually.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> (...)
> 
> > +       if ((clk_gate_flags & CLK_GATE_MASK_UPPER_HALF) && bit_idx > 15)
> > { +               pr_err("%s: bit_idx %d invalid\n", __func__, bit_idx);
> > +               return ERR_PTR(-EINVAL);
> > +       }
> 
> Now this looks *EXTREMELY* familiar to a patch just sent by Haojian
> for HiSilicon.
> 
> "[PATCH v2 3/6] clk: divider: add CLK_DIVIDER_HIWORD_MASK flag"
> http://marc.info/?l=linux-arm-kernel&m=137035873916777&w=2
> 
> What kind of coincidence is this? Are Rockchip and HiSilicon using
> the same silicon IP or are they of a common origin? (It is a small
> world after all.)

Now this is really interesting :-) and the handling really seems to follow the 
same pattern.


> I think you two guys need to read each others patch sets closely
> here. I'd like Haojian to look at Heiko's patches and Heiko to look
> at Haojian's patches, just to make sure you're not actually writing
> two drivers for the same hardware in the end.

I'll take a look


Heiko
