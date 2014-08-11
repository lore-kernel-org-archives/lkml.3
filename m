Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaHKKGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:06:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62573 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbaHKKGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:06:11 -0400
Date: Mon, 11 Aug 2014 11:06:06 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Inha Song <ideal.song@samsung.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "ckeepax@opensource.wolfsonmicro.com" 
	<ckeepax@opensource.wolfsonmicro.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>
Subject: Re: [alsa-devel] [PATCH 2/2] mfd: arizona: Update DT binding to
 support INn_MODE
Message-ID: <20140811100606.GB17745@leverpostej>
References: <20140809173545.2fc1f72e@songinha-Samsung-DeskTop-System>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809173545.2fc1f72e@songinha-Samsung-DeskTop-System>
Thread-Topic: [alsa-devel] [PATCH 2/2] mfd: arizona: Update DT binding to
 support INn_MODE
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2014 at 09:35:45AM +0100, Inha Song wrote:
> This patch update DT binding to support INn_MODE init_data
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index 5c7e723..c21a30e 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -42,6 +42,11 @@ Optional properties:
>      the chip default will be used.  If present exactly five values must
>      be specified.
>  
> +  - wlf,inmode : A list of INn_MODE register values. If absent, INn_MODE register
> +    set to 0 by default. The size of this list depends on ARIZONA_MAX_INPUT values.
> +    ARIZONA_MAX_INPUT is defined in include/linux/mfd/arizona/pdata.h. If present,
> +    exactly ARIZONA_MAX_INPUT values must be specified.

Please don't refer to Linux internals here. How many INn_MODE registers
can this hardware have?

Why does this need to be overriden? Please mention this in the commit
message and documentation.

Why is exposing a raw register value the best way of doing this?

Thanks,
Mark.
