Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3LDF7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:59:42 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56153 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3LDF7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:59:40 -0500
Message-ID: <529EC4B3.7030009@ti.com>
Date: Wed, 4 Dec 2013 11:29:15 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Keerthy <j-keerthy@ti.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <grant.likely@linaro.org>, <lgirdwood@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/4] Regulators: TPS65218: Add Regulator driver for TPS65218
 PMIC
References: <1386053006-6480-1-git-send-email-j-keerthy@ti.com> <1386053006-6480-4-git-send-email-j-keerthy@ti.com> <20131203151654.GB27568@sirena.org.uk>
In-Reply-To: <20131203151654.GB27568@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review Mark.

On Tuesday 03 December 2013 08:46 PM, Mark Brown wrote:
> On Tue, Dec 03, 2013 at 12:13:24PM +0530, Keerthy wrote:
>
>> +static int tps65218_ldo1_dcdc3_vsel_to_uv(unsigned int vsel)
>> +{
>> +	int uV = 0;
>> +
>> +	if (vsel <= 26)
>> +		uV = vsel * 25000 + 900000;
>> +	else
>> +		uV = (vsel - 26) * 50000 + 1550000;
>> +
>> +	return uV;
>> +}
> Use regulator_map_voltage_linear_range() (and similarly for most of the
> other functions).

Ok.

>> +static const struct of_device_id tps65218_of_match[] = {
>> +	TPS65218_OF_MATCH("ti,tps65218-dcdc1", tps65218_pmic_regs[0]),
>> +	TPS65218_OF_MATCH("ti,tps65218-dcdc2", tps65218_pmic_regs[1]),
>> +	TPS65218_OF_MATCH("ti,tps65218-dcdc3", tps65218_pmic_regs[2]),
>> +	TPS65218_OF_MATCH("ti,tps65218-dcdc4", tps65218_pmic_regs[3]),
>> +	TPS65218_OF_MATCH("ti,tps65218-dcdc5", tps65218_pmic_regs[4]),
>> +	TPS65218_OF_MATCH("ti,tps65218-dcdc6", tps65218_pmic_regs[5]),
>> +	TPS65218_OF_MATCH("ti,tps65218-ldo1", tps65218_pmic_regs[6]),
>> +};
>> +MODULE_DEVICE_TABLE(of, tps65218_of_match);
> Indexing into another array by magic number like this is both error
> prone and hard to read.  Either use defined constants or individual
> variables for the things being referenced.
Okay.

Regards,
Keerthy
