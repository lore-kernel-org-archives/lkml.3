Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaKUTnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:43:01 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50506 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaKUTnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:43:00 -0500
Message-ID: <546F95BE.8080808@einserver.de>
Date: Fri, 21 Nov 2014 20:42:54 +0100
From: Andreas Ruprecht <rupran@einserver.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Heiko Stuebner <heiko@sntech.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: rockchip: i2s: Add dependency to I2S device driver
References: <1416594913-30187-1-git-send-email-rupran@einserver.de> <20141121185856.GJ3815@sirena.org.uk>
In-Reply-To: <20141121185856.GJ3815@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 21.11.2014 19:58, Mark Brown wrote:
> On Fri, Nov 21, 2014 at 07:35:13PM +0100, Andreas Ruprecht wrote:
>> Currently, CONFIG_SND_SOC_ROCKCHIP_I2S could also be selected 
>> without having CONFIG_SND_SOC_ROCKCHIP enabled.
>> 
>> As this makes no sense (and breaks the build, when the option 
>> CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM - which would be selected
>> by CONFIG_SND_SOC_ROCKCHIP - is not enabled), a Kconfig
>> dependency is added to CONFIG_SND_SOC_ROCKCHIP_I2S. This will
>> make the item visible only if CONFIG_SND_SOC_ROCKCHIP is
>> enabled.
> 
> This doesn't seem like an obvious fix - why is the fix not to put
> the select on the I2S driver (which is the thing that actually
> depends on the dmaengine stuff)?
> 

I didn't look a lot further into it, I just saw the build error report
and from the other commits touching the Kconfig file it looked like
there could be more options in the future.

I will submit a v2 of the patch in a minute with the select for the
dmaengine support moved to the I2S option.

Regards,

Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb5W9AAoJEJBoQA9qo224gp0P/0tSHqlwTn1CnB3KQR+sEdnN
KzJwEZr5NbdXZyu6eBq0n7IS7MdmusW4BZrFkO2YNwyTPCb0kQPo8gD8IRXYYqdv
Hlkx0k4X8lZrkIFQJak1w3ZNVds6pl81ljf33GAZ82cYJA4c/wPDBv6HVggXjlwc
0sVn4i+JuHXnvhTuiQPs1kPC6S0NGo69yow1xK2W2t46WCFqiI4b6ZSPqC3RP3CA
8wMpdzYzA9VXKpwuAkMzFy+uTBfiJFEkAQhhb8kEiOMQoOsIO5SAMMHce7HodFpd
m3nWfIl+C8ZPtIWuJPKcA8BY+L58bjE3OneCLTK50WRQn36AFeLQC7DPij5zHCDJ
lBxEpCP78dv/N058h9hpIloRzbESCjtQxhvyW3nkNbFLYUqKy1MW9yJkKDCzC1v2
yAYmxlo6JAQHzvZGOcy3RVX8Rar5JS7raNygPizLkQCPqrUfqhWUg6h2h32wKgUN
CXRO1pf0Sz9Uaxjx6CBowwxJlIZN9EiVQpCPmV+BeIeIuRgsPZF3rDPuHHw+WwCp
F2Oih8U5ytNBfVwQgcTEM1doYmaYQpFTSBDMIerTTxZKTZsEa+x1EyX3f2aievIW
EPJgOM15cODsAepRh74PsofmPYe6aFL+lTSIVwPv351exK2ELJwfCUBzsk50Hu8z
MQOsYmY33VXh2VemTlek
=xmsJ
-----END PGP SIGNATURE-----
