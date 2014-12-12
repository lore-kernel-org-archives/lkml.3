Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733AbaLLJda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 04:33:30 -0500
Received: from smtp-out-075.synserver.de ([212.40.185.75]:1088 "EHLO
	smtp-out-075.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934091AbaLLJd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 04:33:28 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 19934
Message-ID: <548AB663.2020207@metafoo.de>
Date: Fri, 12 Dec 2014 10:33:23 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Jackson <andrew.jackson@arm.com>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] ASoC: dwc: Remove unnecessary debug messages and
 tests
References: <cover.1418372910.git.Andrew.Jackson@arm.com>	 <97f65b6037b9ac676f6ca7717a230a68cbe81fd1.1418372910.git.Andrew.Jackson@arm.com> <1418376671.18092.40.camel@perches.com>
In-Reply-To: <1418376671.18092.40.camel@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 10:31 AM, Joe Perches wrote:
[...]
>>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -	if (!res) {
>> -		dev_err(&pdev->dev, "no i2s resource defined\n");
>> -		return -ENODEV;
>> -	}
>> -
>
> Why delete this?
>
>>   	dev->i2s_base = devm_ioremap_resource(&pdev->dev, res);
>> -	if (IS_ERR(dev->i2s_base)) {
>> -		dev_err(&pdev->dev, "ioremap fail for i2s_region\n");
>> +	if (IS_ERR(dev->i2s_base))
>>   		return PTR_ERR(dev->i2s_base);
>> -	}
>
> or this?

devm_ioremap_resource both checks if res is NULL and does also its own error 
reporting. So the code in the driver is redundant.

