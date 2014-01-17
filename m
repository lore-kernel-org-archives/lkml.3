Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaAQSoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:44:09 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:40508 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaAQSoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:44:06 -0500
Message-ID: <52D979F2.8070202@koalo.de>
Date: Fri, 17 Jan 2014 19:44:02 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Daniel Matuschek <daniel@matuschek.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Dimitris.Papastamos@wolfsonmicro.com,
        Liam Girdwood <lgirdwood@gmail.com>, perex@perex.cz,
        Takashi Iwai <tiwai@suse.de>, patches@opensource.wolfsonmicro.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: wm8804: Allow control of master clock divider in
 PLL generation
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform> <52D95DA2.7000509@koalo.de> <20140117175927.GZ17314@sirena.org.uk> <52D97120.8030606@koalo.de> <20140117183332.GC17314@sirena.org.uk>
In-Reply-To: <20140117183332.GC17314@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 07:33 PM, Mark Brown wrote:
> On Fri, Jan 17, 2014 at 07:06:24PM +0100, Florian Meier wrote:
>>
> Intentionally off-list?

Oh no - I am sorry!

>> If I remember correctly the error was
>> "codec can not start from non-off bias with idle_bias_off==true"
> 
>> I think the solution is just to set idle_bias_off = false and everything
>> seems to be working with that. I just don't know if there might be any
>> side effects.
> 
> Setting it to false increases power consumption since the device is
> kept more powered on when idle but reduces startup time from idle.  For
> digital only devices like the wm8804 there shouldn't be any reason to
> keep it powered up when not in use, the startup time is generally
> negligable anyway.
> 

So a better solution would be to set SND_SOC_BIAS_OFF instead of
SND_SOC_BIAS_STANDBY at the end of probe?
