Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3GHCDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 22:03:11 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:12501 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753326Ab3GHCDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:03:10 -0400
Message-ID: <51DA1D75.2010503@atmel.com>
Date: Mon, 8 Jul 2013 10:01:25 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [RFC PATCH 08/13] sound: sam9x5_wm8731: machine driver for at91sam9x5
 wm8731 boards
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com> <1372667978-4718-9-git-send-email-richard.genoud@gmail.com> <51D2472B.2010407@atmel.com> <CACQ1gAji8KkjXee8o=9jt8O38611LBJ95yXimxbfn1qLaLOcnA@mail.gmail.com>
In-Reply-To: <CACQ1gAji8KkjXee8o=9jt8O38611LBJ95yXimxbfn1qLaLOcnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 7/5/2013 23:15, Richard Genoud wrote:
>>> +       card->dev = &pdev->dev;
>>> >>+       card->owner = THIS_MODULE;
>>> >>+       card->dai_link = dai;
>>> >>+       card->num_links = 1;
>>> >>+       dai->name = "WM8731";
>>> >>+       dai->stream_name = "WM8731 PCM";
>>> >>+       dai->codec_dai_name = "wm8731-hifi";
>>> >>+       dai->init = at91sam9x5ek_wm8731_init;
>>> >>+       card->dapm_widgets = at91sam9x5ek_dapm_widgets;
>>> >>+       card->num_dapm_widgets = ARRAY_SIZE(at91sam9x5ek_dapm_widgets);
>> >
>> >
>> >Will keep these as snd_soc_card and snd_soc_dai_link structure separately?
> I don't really understand what you mean here.
> do you mean that something like that will more explicit ? :
> +       card->dai_link[0].name = "WM8731";
> +       card->dai_link[0].stream_name = "WM8731 PCM";
> +       card->dai_link[0].codec_dai_name = "wm8731-hifi";
> +       card->dai_link[0].init = at91sam9x5ek_wm8731_init;
>

I mean using structure to define snd_soc_card and snd_soc_dai_link, look 
like:
struct snd_soc_dai_link dai_link_name = {
	.name = xxx,
	.stream_name = xxx,
	...
};

struct snd_soc_card card_name = {
	.name = xxxx
	.ower = THIS_MODULE,
	.dai_link = &dai_link_name,
	...
};

In this way, I think it will be more clear than put them in code.

Best Regards,
Bo Shen
