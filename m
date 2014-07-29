Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaG2Jq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:46:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54342 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbaG2Jq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:46:26 -0400
Date: Tue, 29 Jul 2014 10:46:13 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "timur@tabi.org" <timur@tabi.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "b02247@freescale.com" <b02247@freescale.com>,
        "b42378@freescale.com" <b42378@freescale.com>,
        "tklauser@distanz.ch" <tklauser@distanz.ch>
Subject: Re: [PATCH v3 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and
 platform drivers
Message-ID: <20140729094613.GK2576@leverpostej>
References: <cover.1406259578.git.nicoleotsuka@gmail.com>
 <f4ff79269a1680f9ce128e0e98fea926d3a41834.1406259578.git.nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4ff79269a1680f9ce128e0e98fea926d3a41834.1406259578.git.nicoleotsuka@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +   - big-endian : If this property is absent, the native endian mode will
> +                 be in use as default, or the big endian mode will be in use
> +                 for all the device registers.

Native endian is meaningless. If a CPU supports both BE and LE, there is
no native endianness. The endianness of the kernel is dynamic while the
endianness of registers in HW is fixed. 

Just choose an endianness to assume by default (presumably little). That
way this describes the HW and always works with a kernel of arbitrary
endianness.

Thanks,
Mark.
