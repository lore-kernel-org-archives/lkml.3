Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaJBRkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:40:18 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45927 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaJBRkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:40:15 -0400
Message-ID: <542D8EA4.6080903@gmail.com>
Date: Thu, 02 Oct 2014 19:43:00 +0200
From: Romain Perier <romain.perier@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: devicetree@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org,
        =?windows-1252?Q?=22heiko=40sntech=2Ede_?=
	 =?windows-1252?Q?=3E=3E_Heiko_St=FCbner=22?= <heiko@sntech.de>,
        sameo@linux.intel.com, lee.jones@linaro.org, grant.likely@linaro.org,
        robh+dt@kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, ldewangan@nvidia.com,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [RFC][PATCH 1/4] regulator: Add helper function to get "poweroff-source"
 property
References: <1412098186-5042-1-git-send-email-romain.perier@gmail.com> <20141001180759.GH4273@sirena.org.uk>
In-Reply-To: <20141001180759.GH4273@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the corresponding drivers and DT maintainers to the loop (parts 
of the kernel which use this property)

Le 01/10/2014 20:07, Mark Brown a écrit :
> On Tue, Sep 30, 2014 at 05:29:43PM +0000, Romain Perier wrote:
>
>> +/**
>> + * of_get_regulator_poweroff_source - Get poweroff-source for given device_node
>> + * @np: Pointer to the given device_node
>> + *
>> + * return true if present false otherwise
>> + */
>> +bool of_get_regulator_poweroff_source(const struct device_node *np)
>> +{
>> +	return of_property_read_bool(np, "poweroff-source");
>> +}
>> +EXPORT_SYMBOL_GPL(of_get_regulator_poweroff_source);
> This isn't really a regulator specific thing - it's common for the
> actual implementation to be to simply cut power but it could be
> something that doesn't look like a regulator doing it like a system
> monitor.  I'd rename this to something like is_system_poweroff_source().
>
> You probably also want to CC the DT maintainers on this and add some
> documentation of this as a standard property, not entirely sure where
> exactly but I'm sure the DT people could advise.

