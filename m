Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaF3LgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:36:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47145 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752722AbaF3LgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:36:12 -0400
Date: Mon, 30 Jun 2014 12:35:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Stone <daniels@collabora.com>
Subject: Re: [PATCH v5 05/14] clk: Add generic driver for Maxim PMIC clocks
Message-ID: <20140630113539.GX32514@n2100.arm.linux.org.uk>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-6-git-send-email-javier.martinez@collabora.co.uk> <CAKew6eU5X=WxhECtwUUwbXe_fCRU4bD6B7caWiA2dwcBfThd-g@mail.gmail.com> <53B142F1.1050407@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B142F1.1050407@collabora.co.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 12:58:57PM +0200, Javier Martinez Canillas wrote:
> >> +       if (!max_gen->lookup)
> >> +               return ERR_PTR(-ENOMEM);
> >> +
> >> +       max_gen->lookup->con_id = hw->init->name;
> > 
> > Also IMO,  init->name should be over-written if name is provided in DT,
> > otherwise generic "clock-output-names" property will go futile,
> > perhaps it should be done before clk_register.
> > 
> 
> Even though Documentation/devicetree/bindings/clock/clock-bindings.txt says that
> the "clock-output-names" property is optional I agree with you that will be
> better to support it. So I'll add it on the next version as well.

However, remember that con_id is the _DEVICE_ specific connection name,
not the _CLOCK_ name.  You will get a NAK from me if you violate this
rule.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
