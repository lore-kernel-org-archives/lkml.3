Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaEWLg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 07:36:29 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37291 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaEWLg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 07:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140523111446.GA12304@sirena.org.uk>
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
	<1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
	<20140522103039.GD12304@sirena.org.uk>
	<CAHbNUh2QHv8n7Y19qfO7BagX5AWe0i17MjDvr7yOpHf6YNGW4A@mail.gmail.com>
	<20140523111446.GA12304@sirena.org.uk>
Date: Fri, 23 May 2014 17:06:27 +0530
Message-ID: <CAHbNUh152xgyVxcCHiv0M6PLw8DE7KZ990WG7uRWWFBc8sPWRQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ASoC: max98090: Add master clock handling
From: Tushar Behera <tushar.behera@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Linux-ALSA <alsa-devel@alsa-project.org>,
        lkml <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Doug Anderson <dianders@chromium.org>,
        "jerry.wong" <jerry.wong@maximintegrated.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2014 16:44, Mark Brown <broonie@kernel.org> wrote:
> On Fri, May 23, 2014 at 11:05:17AM +0530, Tushar Behera wrote:
>
>> I tested with moving clk_enable/clk_disable calls to set_bias_level():
>> SND_SOC_BIAS_PREPARE. That works well for me. Does it look okay?
>
>> +               if (!IS_ERR(max98090->mclk)) {
>> +                       if (codec->dapm.bias_level == SND_SOC_BIAS_ON)
>> +                               clk_disable(max98090->mclk);
>> +                       else
>> +                               clk_enable(max98090->mclk);
>> +               }
>>                 break;
>
> Should be clk_prepare_enable() and similarly for the disable and you
> should check the error codes but yes, that looks good.

I was planning to keep clk_prepare/clk_unprepare in probe/remove.

We are not doing anything specific with the return codes here, so
might be I will add only a error message in case enable/disable fails.

-- 
Tushar Behera
