Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaJPKYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:24:46 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:34577 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaJPKYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:24:43 -0400
Message-ID: <543F9CE3.7040404@collabora.co.uk>
Date: Thu, 16 Oct 2014 12:24:35 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/9] regulator: max77802: Add .{get,set}_mode callbacks
References: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk> <1413390039-19364-3-git-send-email-javier.martinez@collabora.co.uk> <20141016083653.GE724@sirena.org.uk>
In-Reply-To: <20141016083653.GE724@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

Thanks a lot for your feedback.

On 10/16/2014 10:36 AM, Mark Brown wrote:
> On Wed, Oct 15, 2014 at 06:20:32PM +0200, Javier Martinez Canillas wrote:
> 
>> +#define MAX77802_MODE(pval) ((pval == MAX77802_OPMODE_NORMAL) ?	\
>> +			     REGULATOR_MODE_NORMAL : REGULATOR_MODE_STANDBY)
>> +
> 
> Make this a static inline function if there's any need for it, this is
> both more legible and more helpful for the compiler.
> 

Ok, will change that.

>> +	switch (mode) {
>> +	case REGULATOR_MODE_IDLE:
>> +	case REGULATOR_MODE_STANDBY:
>> +		val = MAX77802_OPMODE_LP;	/* ON in Low Power Mode */
>> +		break;
> 
> You should never have multiple modes mapping onto a singel value - if
> the user sets a mode they should find that the device has that mode.
> 

I see, thanks for the clarification. I think STANDBY better maps the device
Low Power Mode according the description in include/linux/regulator/consumer.h
so I'll just make IDLE invalid in v2.

Best regards,
Javier
