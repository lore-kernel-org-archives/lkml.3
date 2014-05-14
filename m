Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaENHbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:31:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44176 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752295AbaENHbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:31:13 -0400
Message-ID: <53731BB3.4060504@free-electrons.com>
Date: Wed, 14 May 2014 09:30:59 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 5/7] clk: sunxi: add PRCM (Power/Reset/Clock Management)
 clks support
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com> <1399633911-7094-6-git-send-email-boris.brezillon@free-electrons.com> <20140514005119.16152.19787@quantum>
In-Reply-To: <20140514005119.16152.19787@quantum>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike,

On 14/05/2014 02:51, Mike Turquette wrote:
> Quoting Boris BREZILLON (2014-05-09 04:11:49)
>> +struct clk_ops ar100_ops = {
>> +       .recalc_rate = ar100_recalc_rate,
>> +       .determine_rate = ar100_determine_rate,
>> +       .set_parent = ar100_set_parent,
>> +       .get_parent = ar100_get_parent,
>> +       .set_rate = ar100_set_rate,
>> +};
> I might be having a brain fart, but is there a valid case for having
> both a .recalc_rate and a .determine_rate? I believe that the former
> will never be used and the latter will always be used by the clock
> framework core.

I think you're mistaking recalc_rate for round_rate.
AFAIK, recalc_rate is mandatory for a clk that implement either
round_rate or determine_rate.


Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

