Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbbAPBR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:17:59 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:20386 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932445AbbAPBR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:17:56 -0500
Message-ID: <54B866B9.8000900@atmel.com>
Date: Fri, 16 Jan 2015 09:17:45 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        "Alexander Morozov" <linux@meltdown.ru>
Subject: Re: [PATCH v2 1/3] ASoC: codecs: wm8904: add dt ids table
References: <1418614273-2303-1-git-send-email-voice.shen@atmel.com> <20150115115425.GX3043@sirena.org.uk>
In-Reply-To: <20150115115425.GX3043@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 01/15/2015 07:54 PM, Mark Brown wrote:
> On Mon, Dec 15, 2014 at 11:31:11AM +0800, Bo Shen wrote:
>
>> +#ifdef CONFIG_OF
>> +static enum wm8904_type wm8904_data = WM8904;
>> +static enum wm8904_type wm8912_data = WM8912;
>> +
>> +static const struct of_device_id wm8904_of_match[] = {
>> +	{
>> +		.compatible = "wlf,wm8904",
>> +		.data = &wm8904_data,
>
> Does this end up in the i2c_driver_id driver data or do we need some
> extra code when devtype is assigned to check for an of_node and look at
> the DT data instead?  That certainly used to be the case...

At the beginning I think as the same as you, and also add the code to 
get the data as I do in <drivers/misc/atmel-ssc.c>. However, as I 
remember, I2C seems only use the compatible string after the comma, that 
means only for "wlf,wm8904", it uses "wm8904" to match. So, I remove all 
the code I added, and just keep these, and it can get the device type 
correctly.

So, when I submit the patch and keep the code as simple as possible.

Thanks.

Best Regards,
Bo Shen

