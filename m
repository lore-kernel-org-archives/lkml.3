Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030264AbaLMLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 06:25:57 -0500
Received: from smtp-out-084.synserver.de ([212.40.185.84]:1094 "EHLO
	smtp-out-084.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966553AbaLMLZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 06:25:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28390
Message-ID: <548C223B.6050905@metafoo.de>
Date: Sat, 13 Dec 2014 12:25:47 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>,
        Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
CC: Jonathan Cameron <jic23@kernel.org>, Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Michael Welling <mwelling@ieee.org>,
        Philippe Reynes <tremyfr@yahoo.fr>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH v2 2/2] iio: add driver for the TI DAC8554
References: <1416858614-32265-1-git-send-email-nikolaus.schulz@avionic-design.de> <1416858614-32265-2-git-send-email-nikolaus.schulz@avionic-design.de> <5482EA33.7020305@gmx.de> <20141212155804.GA1142@avionic-0071.adnet.avionic-design.de> <548C209A.7000904@gmx.de>
In-Reply-To: <548C209A.7000904@gmx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 12:18 PM, Hartmut Knaack wrote:
[...]
>>> According to your DT bindings, the regulator from property "vref-supply" should
>>> be used. This is missing here.
>>
>> Uhm, it's right below, no?
> Looking into your DT bindings patch (which unfortunately didn't make it into our
> list), you specify "vref-supply" as a required property. So, I expected that you
> intended to make use of this property somewhere around here.

The regulator framework takes care of this. If you request a regulator with 
$name the framework will look for a property with the name $name-supply.

>>
>>>> +	st->reg =evm_regulator_get(&spi->dev, "vref");
>>>> +	if (IS_ERR(st->reg))
>>>> +		return PTR_ERR(st->reg);
[...]

