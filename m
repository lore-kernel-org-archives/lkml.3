Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaH2NhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 09:37:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48833 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752574AbaH2NhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 09:37:10 -0400
Message-ID: <54008202.4090008@free-electrons.com>
Date: Fri, 29 Aug 2014 15:37:06 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Raphael Rigo <ml-arm@syscall.eu>, Arnaud Ebalard <arno@natisbad.org>,
        Simon Boulay <simon.boulay@vitec.com>
Subject: Re: [PATCH 2/4] clk: mvebu: armada-370: Fix timer drift caused by
 the SSCG deviation
References: <1409312620-20631-1-git-send-email-gregory.clement@free-electrons.com>	<1409312620-20631-3-git-send-email-gregory.clement@free-electrons.com> <20140829150821.66f1d03d@free-electrons.com>
In-Reply-To: <20140829150821.66f1d03d@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 29/08/2014 15:08, Thomas Petazzoni wrote:
> Dear Gregory CLEMENT,
> 
> On Fri, 29 Aug 2014 13:43:38 +0200, Gregory CLEMENT wrote:
> 
>> +bool a370_is_sscg_enabled(void __iomem *sar)
> 
> Minor nit: "static" is missing here.

OK I will fix it in the next version


Thanks,

Gregory


> 
>> +{
>> +	return !(readl(sar) & SARL_A370_SSCG_ENABLE);
>> +}
>> +
>>  static const struct coreclk_soc_desc a370_coreclks = {
>>  	.get_tclk_freq = a370_get_tclk_freq,
>>  	.get_cpu_freq = a370_get_cpu_freq,
>>  	.get_clk_ratio = a370_get_clk_ratio,
>> +	.is_sscg_enabled = a370_is_sscg_enabled,
>>  	.ratios = a370_coreclk_ratios,
>>  	.num_ratios = ARRAY_SIZE(a370_coreclk_ratios),
>>  };
> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
