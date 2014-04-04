Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaDDHam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:30:42 -0400
Received: from smtp-out-118.synserver.de ([212.40.185.118]:1033 "EHLO
	smtp-out-115.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750811AbaDDHal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:30:41 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31573
Message-ID: <533E5FD4.8040403@metafoo.de>
Date: Fri, 04 Apr 2014 09:31:32 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arun Shamanna Lakshmi <aruns@nvidia.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Songhee Baek <sbaek@nvidia.com>
Subject: Re: [PATCH] ASoC: dapm: Add support for multi register mux
References: <1396494710-20944-1-git-send-email-aruns@nvidia.com> <533D1B65.3030405@metafoo.de> <781A12BB53C15A4BB37291FDE08C03F3A05CDCDF9F@HQMAIL02.nvidia.com>
In-Reply-To: <781A12BB53C15A4BB37291FDE08C03F3A05CDCDF9F@HQMAIL02.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 10:11 PM, Arun Shamanna Lakshmi wrote:
[...]
>> Here as well, default for bit_pos should be 0.
>
> This means when 'None' of the options are selected, by default, it
> enumerates to 0. Since we are using __ffs, BIT(0) of Register-0 also
> enumerates to 0. That's the reason why I used just ffs in the first place.
> Let me know your opinion. My value table looks like below.
>
> #define MUX_VALUE(npart, nbit)	(nbit + 32 * npart)
> static const int mux_values[] = {
> 	0,
> 	MUX_VALUE(0, 0),
> 	.
> 	.
> 	.
> 	MUX_VALUE(0, 31),
> 	/* above inputs are for part0 mux */
> 	MUX_VALUE(1, 0),
> 	.
> 	.
> 	.
> 	MUX_VALUE(1, 31),
> 	/* above inputs are for part1 mux */
> 	MUX_VALUE(2, 0),
> 	.
> 	.
> 	.
> 	MUX_VALUE(2, 31),
> 	/* above inputs are for part2 mux */
> };

Ok, so having none of the input selected should be a valid user selectable 
option?
