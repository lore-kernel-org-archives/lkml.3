Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaCSTbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:31:13 -0400
Received: from smtp-out-002.synserver.de ([212.40.185.2]:1044 "EHLO
	smtp-out-242.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752264AbaCSTbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:31:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28455
Message-ID: <5329F0A1.8020801@metafoo.de>
Date: Wed, 19 Mar 2014 20:31:45 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jyri Sarha <jsarha@ti.com>, Jean-Francois Moine <moinejf@free.fr>,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        Xiubo Li <Li.Xiubo@freescale.com>, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH v3 4/4] ASoC: simple-card: Add DT documentation
 for multi-DAI links
References: <cover.1394883134.git.moinejf@free.fr> <d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr> <20140317164339.GR11706@sirena.org.uk> <20140318091728.1d2240ca@armhf> <53296CB7.1000909@ti.com> <5329E749.6070900@metafoo.de> <5329ECC2.7040803@ti.com> <20140319192157.GW11706@sirena.org.uk>
In-Reply-To: <20140319192157.GW11706@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 08:21 PM, Mark Brown wrote:
> On Wed, Mar 19, 2014 at 09:15:14PM +0200, Jyri Sarha wrote:
>> On 03/19/2014 08:51 PM, Lars-Peter Clausen wrote:
>
>>> When does this make sense? Either the bitclock is inverted for all of
>>> them or for none.
>
>> Definition of clock signal and it's inversion varies between chip
>> manufacturers and sometimes it may not be possible to get all the dai
>> drivers to work identically in this respect. Because of this in some cases
>> there may be a need to set the inversion bit only at one end of the link.
>
> No, Linux has a definition of all the clock modes which applies to all
> devices regardless of what the manufacturer documents in their
> datasheet.
>

Yep. The clock properties are well defined for the different modes that can 
be specified in the format property. It's up to the driver to translate this 
to driver specific settings. If two drivers behave differently for the same 
mode one of them (or both) are broken.

We should probably add the definitions for the different formats to the DT 
bindings. E.g. what is default, what is inverted polarity, etc.

- Lars
