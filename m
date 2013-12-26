Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3LZPCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 10:02:12 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35313 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3LZPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 10:02:11 -0500
Message-ID: <52BC44F1.9030205@linaro.org>
Date: Thu, 26 Dec 2013 09:02:09 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: support hardware-specific debugfs entries
References: <52BC3CA1.7000701@linaro.org> <20131226145052.GM8064@book.gsilab.sittig.org>
In-Reply-To: <20131226145052.GM8064@book.gsilab.sittig.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2013 08:50 AM, Gerhard Sittig wrote:
> On Thu, Dec 26, 2013 at 08:26 -0600, Alex Elder wrote:
>>
>> @@ -140,6 +147,9 @@ struct clk_ops {
>>  	int		(*set_rate)(struct clk_hw *hw, unsigned long,
>>  				    unsigned long);
>>  	void		(*init)(struct clk_hw *hw);
>> +#ifdef CONFIG_COMMON_CLK_DEBUG
>> +	int		(*debug_init)(struct clk_hw *hw, struct dentry *dentry);
>> +#endif
>>  };
> 
> Please note that this CONFIG_COMMON_CLK_DEBUG switch may go away
> (or get replaced) soon.  Mike plans to effectively enable common
> clock debugging as soon as debugfs is in effect (which I welcome
> very much).

Fine with me.  I'll wait for further feedback before sending
out an updated patch.  Thanks.

					-Alex

> 
> So you should monitor current development and adjust your patch,
> or be prepared for breakage and fixing afterwards.  I'd suggest
> to just declare the .debug_init member unconditionally now.
> Since Mike's patch very likely gets accepted, and nothing will
> break when yours gets added later (regardless of the number of
> review iterations it will see).
> 
> 
> virtually yours
> Gerhard Sittig
> 

