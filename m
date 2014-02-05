Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaBENbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 08:31:12 -0500
Received: from smtp-out-092.synserver.de ([212.40.185.92]:1057 "EHLO
	smtp-out-089.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750775AbaBENbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 08:31:11 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22070
Message-ID: <52F23D1D.7040804@metafoo.de>
Date: Wed, 05 Feb 2014 14:31:09 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH v3 4/5] ASoC: tda998x: adjust the audio hw
 parameters from EDID
References: <cover.1391274627.git.moinejf@free.fr> <1b15025671d9099863a3091346536e45891e4a26.1391274628.git.moinejf@free.fr> <20140204180625.GM22609@sirena.org.uk> <20140205101134.4591e5c3@armhf> <52F2021A.9020804@metafoo.de> <20140205111814.GF22609@sirena.org.uk>
In-Reply-To: <20140205111814.GF22609@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 12:18 PM, Mark Brown wrote:
> On Wed, Feb 05, 2014 at 10:19:22AM +0100, Lars-Peter Clausen wrote:
[..]
>> Bonus points for making this a generic helper function that takes a
>> runtime and a EDID and then applies the EDID constraints on the
>> runtime.
>
> ...as previously requested.  I know there was some discusion of broader
> moves to factor this stuff out but it'd still be good to keep it
> separated out even prior to a final non-EDID based solution so it's
> easier to refactor.

I think it will always be EDID (or ELD) based. As I understood it the 
re-factoring Takashi was talking about is related to how this data is passed 
from the graphics driver to the audio driver. The way things work right now 
in HDA land is that the graphics driver reads the EDID from the monitor, 
converts it to ELD and writes it to a special memory region in the graphics 
controller. This generates an interrupt in the audio driver and the audio 
driver reads the ELD from the hardware and sets up the constraints based on 
that. And I think that the plan is to change this to pass the EDID directly 
from the graphics driver to the audio driver without taking the detour 
through the hardware. This is what we'll need for embedded systems anyway. A 
system that allows to associate a sound driver with a specific HDMI port and 
status updates for that port, e.g. new EDID or cable connected/disconnected 
are passed from the graphics driver handling that port to the audio driver.

- Lars

