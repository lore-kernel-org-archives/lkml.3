Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3H2Lck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 07:32:40 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53934 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab3H2Lcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 07:32:39 -0400
Message-ID: <521F3151.1030704@gmail.com>
Date: Thu, 29 Aug 2013 13:32:33 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 08/16] ARM: mxs: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-9-git-send-email-sebastian.hesselbarth@gmail.com> <20130829110849.GB18729@S2101-09.ap.freescale.net>
In-Reply-To: <20130829110849.GB18729@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/13 13:08, Shawn Guo wrote:
> On Tue, Aug 27, 2013 at 11:28:02PM +0200, Sebastian Hesselbarth wrote:
>> @@ -100,19 +101,17 @@ static enum imx23_clk clks_init_on[] __initdata = {
>>   	cpu, hbus, xbus, emi, uart,
>>   };
>>
>> -int __init mx23_clocks_init(void)
>> +static void __init mx23_clocks_init(struct device_node *np)
>>   {
>> -	struct device_node *np;
>>   	u32 i;
>>
>> +	clkctrl = of_iomap(np, 0);
>> +	WARN_ON(!clkctrl);
>> +
>>   	np = of_find_compatible_node(NULL, NULL, "fsl,imx23-digctl");
>>   	digctrl = of_iomap(np, 0);
>>   	WARN_ON(!digctrl);
>>
>> -	np = of_find_compatible_node(NULL, NULL, "fsl,imx23-clkctrl");
>> -	clkctrl = of_iomap(np, 0);
>> -	WARN_ON(!clkctrl);
>> -
>
> With the changes, 'np' becomes a pointer to digctl node instead of
> clkctrl as the original.  This will cause problem for
> of_clk_add_provider(np, ...) later in this function.
>
> Same problem with mx28_clocks_init() changes.

Ok, will take care of it. I assume you are fine with having an extra
struct device_node pointer for the sake of readability instead of
reusing the same pointer.

Sebastian

