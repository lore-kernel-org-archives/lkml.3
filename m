Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaE0SCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:02:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60042 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaE0SCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:02:48 -0400
Message-ID: <5384D345.4070606@codeaurora.org>
Date: Tue, 27 May 2014 11:02:45 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH] coccinelle: Check for missing NULL terminators in of_device_id
 tables
References: <1400888504-31309-1-git-send-email-sboyd@codeaurora.org> <alpine.DEB.2.02.1405240956220.2012@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1405240956220.2012@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/14 00:57, Julia Lawall wrote:
> On Fri, 23 May 2014, Stephen Boyd wrote:
>
>> +... struct of_device_id arr[] = {
>> +	...,
>> +	{
>> +	...,
>> +	.var = E,
>> +	...
>> +	}
>> +};
> You shouldn't need any of the ...s in these rules.
>

Hm.. Removing all the ...s in these rules only gives me 3 matches now. I
used to get 5.

Before

$ COCCI=scripts/coccinelle/misc/of_table.cocci make coccicheck MODE=report

Please check for false positives in the output before submitting a patch.
When using "patch" mode, carefully review the patch before submitting it.

./sound/soc/pxa/pxa-ssp.c:810:36-37: pxa_ssp_of_ids is not NULL terminated at line 810
./drivers/mfd/tps65218.c:199:32-33: of_tps65218_match_table is not NULL terminated at line 199
./drivers/staging/mt29f_spinand/mt29f_spinand.c:926:34-35: spinand_dt is not NULL terminated at line 926
./drivers/clk/clk-u300.c:1170:1-2: u300_clk_match is not NULL terminated at line 1170
./drivers/clk/st/clkgen-pll.c:655:1-2: c32_gpu_pll_of_match is not NULL terminated at line 655


After

$ COCCI=scripts/coccinelle/misc/of_table.cocci make coccicheck MODE=report

Please check for false positives in the output before submitting a patch.
When using "patch" mode, carefully review the patch before submitting it.

./sound/soc/pxa/pxa-ssp.c:810:36-37: pxa_ssp_of_ids is not NULL terminated at line 810
./drivers/mfd/tps65218.c:199:32-33: of_tps65218_match_table is not NULL terminated at line 199
./drivers/staging/mt29f_spinand/mt29f_spinand.c:926:34-35: spinand_dt is not NULL terminated at line 926


Removing most of the ...s seems to work though. I'll send a v2.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

