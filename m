Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaH2LGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:06:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51521 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795AbaH2LGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:06:21 -0400
Date: Fri, 29 Aug 2014 12:06:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
Message-ID: <20140829110601.GB21473@leverpostej>
References: <1409296332-39318-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409296332-39318-1-git-send-email-Li.Xiubo@freescale.com>
Thread-Topic: [PATCHv2] ASoC: fsl-sai: using 'lsb-first' property instead of
 'big-endian-data'.
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 08:12:12AM +0100, Xiubo Li wrote:
> The 'big-endian-data' property is originally used to indicate whether the
> LSB firstly or MSB firstly will be transmitted to the CODEC or received
> from the CODEC, and there has nothing relation to the memory data.
> 
> Generally, if the audio data in big endian format, which will be using the
> bytes reversion, Here this can only be used to bits reversion.
> 
> So using the 'lsb-first' instead of 'big-endian-data' can make the code
> to be readable easier and more easy to understand what this property is
> used to do.
> 
> This property used for configuring whether the LSB or the MSB is transmitted
> first for the fifo data.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Nicolin Chen <nicoleotsuka@gmail.com>
> ---
>  Documentation/devicetree/bindings/sound/fsl-sai.txt | 8 ++++----
>  sound/soc/fsl/fsl_sai.c                             | 6 +++---
>  sound/soc/fsl/fsl_sai.h                             | 2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> index 06a405e..4956b14 100644
> --- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
> +++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> @@ -20,9 +20,9 @@ Required properties:
>    See ../pinctrl/pinctrl-bindings.txt for details of the property values.
>  - big-endian: Boolean property, required if all the FTM_PWM registers
>    are big-endian rather than little-endian.
> -- big-endian-data: If this property is absent, the little endian mode will
> -  be in use as default, or the big endian mode will be in use for all the
> -  fifo data.
> +- lsb-first: Configures whether the LSB or the MSB is transmitted first for
> +  the fifo data. If this property is absent, the MSB is transmitted first as
> +  default, or the LSB is transmitted first.

Both Nicolin [1] and Mark [2] asked for the old property to be kept
around for compatibility reasons. Those requests seem to have been
ignored entirely; the commit message doesn't even describe why you
believe removing support for the old property is safe.

So NAK unless this patch is updated to either:

- Keep support for the old property, but mark it as deprecated in the
  documentation (having a warning if said property is used is also
  fine).

- Describe why it is safe to remove the property outright, and both Mark
  and Nicolin agree that this is fine.

The former is the preferred way of doing things, and the latter should
be the exceptional case. We don't even save much here my dropping
support for the old property.

I have no proeprty with addition of the the new property; the rationale
for the new naming makes sense to me.

Thanks,
Mark.

[1] http://lkml.kernel.org/r/20140827070544.GO17528@sirena.org.uk
[2] http://lkml.kernel.org/r/CAGoOwPSTJaT0UA4yaYR0x49C8UHbmKAR8PzUfV9ZWVW5XBfV5w@mail.gmail.com
