Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaKDLHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:07:19 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40055 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaKDLHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:07:15 -0500
Message-ID: <5458B356.5000206@collabora.co.uk>
Date: Tue, 04 Nov 2014 12:07:02 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Mark Brown <broonie@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 10/14] regulator: of: Add support for parsing initial
 and suspend modes
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk> <1415025649-8119-11-git-send-email-javier.martinez@collabora.co.uk> <1415097677.7941.8.camel@AMDC1943>
In-Reply-To: <1415097677.7941.8.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 11/04/2014 11:41 AM, Krzysztof Kozlowski wrote:
>> +	if (!of_property_read_u32(np, "regulator-initial-mode", &pval)) {
>> +		if (desc && desc->map_modes)
>> +			constraints->initial_mode = desc->map_modes(pval);
>> +		else
>> +			pr_warn("%s: failed to parse regulator-initial-mode\n",
>> +				np->name);
>> +	}
>> +
> 
> Here's a hidden assumption that if driver does not provide map_modes
> then any "regulator-initial-mode" property is not valid. Shouldn't this
> be mentioned somewhere? Maybe in description of map_modes callback?
> 

Well it can't be valid if the regulator core does not know how to map the
value in the property to one of the standard modes. The binding explains
that each PMIC has to define its hardware modes, I can also add a note
in the .map_modes. I guess no one will say no to more documentation :-)

Best regards,
Javier

