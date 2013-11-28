Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3K1IqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:46:08 -0500
Received: from 4.mo6.mail-out.ovh.net ([87.98.184.159]:56363 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033Ab3K1IqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:46:05 -0500
Message-ID: <52970002.3020405@overkiz.com>
Date: Thu, 28 Nov 2013 09:34:10 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v5 06/17] clk: at91: add PMC pll clocks
References: <1384289513-3068-1-git-send-email-b.brezillon@overkiz.com> <1384293439-4525-1-git-send-email-b.brezillon@overkiz.com> <20131127214843.16819.59481@quantum>
In-Reply-To: <20131127214843.16819.59481@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4503600737187868
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 27/11/2013 22:48, Mike Turquette wrote:
> Quoting Boris BREZILLON (2013-11-12 13:57:19)
>> +static const struct clk_ops pll_ops = {
>> +       .prepare = clk_pll_prepare,
>> +       .is_prepared = clk_pll_is_ready,
>> +       .disable = clk_pll_disable,
>> +       .is_enabled = clk_pll_is_ready,
>> +       .recalc_rate = clk_pll_recalc_rate,
>> +       .round_rate = clk_pll_round_rate,
>> +       .set_rate = clk_pll_set_rate,
>> +};
> Hi Boris,
>
> It is a bit strange to see only a .prepare and .disable callback
> populated. What happens if a driver calls clk_disable and then
> clk_enable? You clock will still be disabled in hardware.

Oops, I haven't thought about that.
I did this because the clk_pll_disable does not sleep, but this is a big 
mistake :-(.

I'll fix this.

Thanks.

Best Regards,

Boris
> Regards,
> Mike

