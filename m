Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaB1HPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:15:17 -0500
Received: from smtp-out-127.synserver.de ([212.40.185.127]:1056 "EHLO
	smtp-out-167.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751198AbaB1HPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:15:15 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12320
Message-ID: <53103787.2020702@metafoo.de>
Date: Fri, 28 Feb 2014 08:15:19 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: core: Set the default I/O up try
 regmap.
References: <1393494593-26310-1-git-send-email-Li.Xiubo@freescale.com> <1393494593-26310-3-git-send-email-Li.Xiubo@freescale.com> <20140228035244.GJ9383@sirena.org.uk> <c405df11848a40b7beda8d8fe747e7a7@BY2PR03MB505.namprd03.prod.outlook.com> <20140228052904.GP9383@sirena.org.uk> <1b89016263c84e0297655034a648032f@BY2PR03MB505.namprd03.prod.outlook.com> <53102EE4.80702@metafoo.de> <d872d0fd60eb4c01b38af98014c802aa@BY2PR03MB505.namprd03.prod.outlook.com> <531030C7.2060703@metafoo.de> <5d534c2ac77040d9bc373db9e43dde7c@BY2PR03MB505.namprd03.prod.outlook.com>
In-Reply-To: <5d534c2ac77040d9bc373db9e43dde7c@BY2PR03MB505.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 08:08 AM, Li.Xiubo@freescale.com wrote:
>>>>>> Subject: Re: [PATCH 2/3] ASoC: core: Set the default I/O up try regmap.
>>>>>>
>>>>>> On Fri, Feb 28, 2014 at 04:00:38AM +0000, Li.Xiubo@freescale.com wrote:
>>>>>>
>>>>>>> I'll send another patches to applied to use this for another CODEC
>> drivers.
>>>>>>> And there almost 80 files, Should I send them in one patch or split them
>>>>>> into
>>>>>>> individual patch for each CODEC driver ?
>>>>>>
>>>>>> I'd suggest doing one patch that covers the boring drivers where the
>>>>>> first thing they do is call set_cache_io() but split out the others into
>>>>>> one patch per driver since the need more examination.
>>>>>
>>>>> Got it.
>>>>
>>>> Btw. be careful, just removing the set_cache_io() call will not work for
>> all
>>>> drivers. There are some MFD child devices which use regmap from the parent
>>>> device. So dev_get_regmap() will return NULL for those.
>>>>
>>>
>>> @Lars,
>>>
>>> Do you mean the CODEC drivers like wm5110 and wm8997 ?
>>>
>>
>>
>> Yes.
>>
>
> I only found these two CODEC drivers using MFD who would get its parent's regmap.
>
> Has I missed some ?

A quick grep reveals:
mc13783.c:	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
si476x.c:	codec->control_data = dev_get_regmap(codec->dev->parent, NULL);
wm5102.c:	codec->control_data = priv->core.arizona->regmap;
wm5110.c:	codec->control_data = priv->core.arizona->regmap;
wm8997.c:	codec->control_data = priv->core.arizona->regmap;

But there might be more.
