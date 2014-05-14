Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaENAv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 20:51:28 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53845 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaENAv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 20:51:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        =?utf-8?q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Lee Jones" <lee.jones@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1399633911-7094-6-git-send-email-boris.brezillon@free-electrons.com>
Cc: "Chen-Yu Tsai" <wens@csie.org>,
        "Maxime Ripard" <maxime.ripard@free-electrons.com>,
        "Philipp Zabel" <p.zabel@pengutronix.de>,
        "Shuge" <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        "Hans de Goede" <hdegoede@redhat.com>,
        "Randy Dunlap" <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        "Boris BREZILLON" <boris.brezillon@free-electrons.com>
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399633911-7094-6-git-send-email-boris.brezillon@free-electrons.com>
Message-ID: <20140514005119.16152.19787@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v3 5/7] clk: sunxi: add PRCM (Power/Reset/Clock Management) clks
 support
Date: Tue, 13 May 2014 17:51:19 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2014-05-09 04:11:49)
> +struct clk_ops ar100_ops = {
> +       .recalc_rate = ar100_recalc_rate,
> +       .determine_rate = ar100_determine_rate,
> +       .set_parent = ar100_set_parent,
> +       .get_parent = ar100_get_parent,
> +       .set_rate = ar100_set_rate,
> +};

I might be having a brain fart, but is there a valid case for having
both a .recalc_rate and a .determine_rate? I believe that the former
will never be used and the latter will always be used by the clock
framework core.

Regards,
Mike
