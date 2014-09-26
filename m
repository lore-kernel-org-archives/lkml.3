Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbaIZQl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:41:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34842 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbaIZQlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:41:24 -0400
Message-ID: <54259708.1030801@ti.com>
Date: Fri, 26 Sep 2014 19:40:40 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>
CC: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-pm@vger.kernel.org>, <ben.dooks@codethink.co.uk>,
        <laurent.pinchart@ideasonboard.com>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] ARM: keystone: pm: switch to use generic pm domains
References: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>	<1411657537-25238-3-git-send-email-grygorii.strashko@ti.com> <7hlhp79w6p.fsf@deeprootsystems.com>
In-Reply-To: <7hlhp79w6p.fsf@deeprootsystems.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 01:23 AM, Kevin Hilman wrote:
> Grygorii Strashko <grygorii.strashko@ti.com> writes:
>
>> This patch switches Keystone 2 PM code to use Generic PM domains
>> instead of PM  clock domains because of the lack of DT support
>> for the last.
>>
>> Keystone 2 PM domain should be specified per device for which
>> Runtime PM has to be enabled and handles the list of functional clocks
>> to enable/disable device.
>>
>> Example:
>>   qmss_domain: qmss_pm_controller {
>> 	compatible = "ti,keystone-pm-controller";
>> 	clocks = <&chipclk13>;
>> 	#power-domain-cells = <0>;
>>   };
>>
>>   qmss: qmss@2a40000 {
>> 	compatible = "ti,keystone-navigator-qmss";
>> 	...
>> 	power-domains = <&qmss_domain>;
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>
> [...]
>
>> +static int keystone_pm_domain_power_off(struct generic_pm_domain *genpd)
>> +{
>> +	int ret;
>> +	struct keystone_domain *dm = container_of(genpd,
>> +						  struct keystone_domain,
>> +						  base);
>> +
>> +	/* Enable reset clocks for all devices in the PU domain */
>
> This says enable clocks...
>
>> +	ret = pm_clk_suspend(dm->dev);
>
> ...but this calls clk_disable().
>
>> +	if (ret)
>> +		dev_err(dm->dev, "can't turn off clocks %d\n", ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int keystone_pm_domain_power_on(struct generic_pm_domain *genpd)
>> +{
>> +	int ret;
>> +	struct keystone_domain *dm = container_of(genpd,
>> +						  struct keystone_domain,
>> +						  base);
>> +
>> +	/* Disable reset clocks for all devices in the PU domain */
>
> And this says disable clocks...
>
>> +	ret = pm_clk_resume(dm->dev);
>
> ...but this calls clk_enable().
>
> -ECONFUSED.
>

Will update.

Thanks you for comments.

Regards,
-grygorii



