Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaBDNgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:36:54 -0500
Received: from smtp-out-089.synserver.de ([212.40.185.89]:1098 "EHLO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaBDNgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:36:51 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18705
Message-ID: <52F0ECF2.9070102@metafoo.de>
Date: Tue, 04 Feb 2014 14:36:50 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v3 2/5] ASoC: tda998x: add a codec driver
 for the TDA998x
References: <cover.1391274627.git.moinejf@free.fr> <ae68394f080f0ea5acaf3377cb1d18f29e42c646.1391274628.git.moinejf@free.fr> <20140204133014.GA22609@sirena.org.uk>
In-Reply-To: <20140204133014.GA22609@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 02:30 PM, Mark Brown wrote:
[...]
>
> What does this actually do?  No information is being passed in to the
> core function here, not even any information on if it's starting or
> stopping.  Looking at the rest of the code I can't help thinking it
> might be clearer to inline this possibly with a lookup helper, the code
> is very small and the lack of parameters makes it hard to follow.
>
>> +static const struct snd_soc_dapm_route tda_routes[] = {
>> +	{ "hdmi-out", NULL, "HDMI I2S Playback" },
>> +	{ "hdmi-out", NULL, "HDMI SPDIF Playback" },
>> +};
>
> S/PDIF.

Won't this cause issues with the debugfs widget entries? It's fixable by 
escaping it (replace it by a dash or something) in the debugfs widget 
filename, but I don't think we do this right now.

- Lars

