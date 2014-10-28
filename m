Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaJ1Qjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:39:37 -0400
Received: from smtp-out-148.synserver.de ([212.40.185.148]:1084 "EHLO
	smtp-out-148.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaJ1Qjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:39:35 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21012
Message-ID: <544FC6B1.1060002@metafoo.de>
Date: Tue, 28 Oct 2014 17:39:13 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Max Filippov <jcmvbkbc@gmail.com>, alsa-devel@alsa-project.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, linux-xtensa@linux-xtensa.org,
        Takashi Iwai <tiwai@suse.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: add xtensa xtfpga I2S interface and
 platform
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com> <544FBD20.5000604@metafoo.de> <20141028160414.GY18557@sirena.org.uk>
In-Reply-To: <20141028160414.GY18557@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 05:04 PM, Mark Brown wrote:
> On Tue, Oct 28, 2014 at 04:58:24PM +0100, Lars-Peter Clausen wrote:
>> On 10/27/2014 08:07 PM, Max Filippov wrote:
>
>>> +	if (tx_active) {
>>> +		if (i2s->tx_fifo_high < 256)
>>> +			xtfpga_i2s_refill_fifo(i2s);
>>> +		else
>>> +			tasklet_hi_schedule(&i2s->refill_fifo);
>
>> Maybe use threaded IRQs instead of IRQ + tasklet.
>
> Is that going to play nicely with the fact that the interrupt can be
> shared and the desire to (AFAICT) do NAPI style stuff with the interrupt
> disabled for long periods?
>

Threaded interrupts got support for interrupt sharing a while ago, so I 
guess yes. I think it will even work better than the tasklet approach. You 
can configure the IRQ to disable itself as long as the thread is running.

- Lars
