Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaKDLCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:02:16 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:40044 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaKDLCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:02:14 -0500
Message-ID: <5458B22D.8000209@collabora.co.uk>
Date: Tue, 04 Nov 2014 12:02:05 +0100
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
Subject: Re: [PATCH v4 02/14] regulator: Add function to map modes to struct
 regulator_desc
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk> <1415025649-8119-3-git-send-email-javier.martinez@collabora.co.uk> <1415097072.7941.5.camel@AMDC1943>
In-Reply-To: <1415097072.7941.5.camel@AMDC1943>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

Thanks a for your feedback.

On 11/04/2014 11:31 AM, Krzysztof Kozlowski wrote:
>> + *
>> + * @map_modes: Callback invoked to translate between hardware to standard modes.
> 
> Initially I thought it should map from standard to hardware. But then I
> looked at max77802 implementation and it maps from hardware to standard.
> Anyway I got confused (both are "modes" and both unsigned ints).
> 
> Could you describe which should be returned?
> 

Sure, maybe rewording to:

"Callback invoked to translate from hardware to standard modes." ?

But I'll add also document that the parameter should be a hardware
mode and the return value a standard mode.

 >>   */
>>  struct regulator_desc {
>>  	const char *name;
>> @@ -285,6 +287,8 @@ struct regulator_desc {
>>  	unsigned int enable_time;
>>  
>>  	unsigned int off_on_delay;
>> +
>> +	unsigned int (*map_modes)(unsigned int mode);
> 
> Shouldn't this be in regulator ops?
> 

regulator ops are for the operations that a regulator support
(enable, disable, set mode, etc). All the thse are actions but
how to translate between hardware and standard modes is not an
action but a non-varying configuration of the regulator.

So I believe that regulator desc was what fit the most. I don't
have a strong opinion though if people think that it should be
in regulator ops instead.

Best regards,
Javier
