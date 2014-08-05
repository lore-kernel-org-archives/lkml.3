Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbaHELBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:01:30 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38759 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaHELB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:01:28 -0400
Message-ID: <53E0B926.9010103@gmail.com>
Date: Tue, 05 Aug 2014 16:29:50 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nicolin Chen <nicoleotsuka@gmail.com>, broonie@kernel.org
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, b42378@freescale.com,
        b02247@freescale.com
Subject: Re: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
References: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
In-Reply-To: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 01:02 PM, Nicolin Chen wrote:
> From: Nicolin Chen <Guangyu.Chen@freescale.com>
>
> SAI supports these operation modes:
> 1) asynchronous mode
>     Both Tx and Rx are set to be asynchronous.
> 2) synchronous mode (Rx sync with Tx)
>     Tx is set to be asynchronous, Rx is set to be synchronous.
> 3) synchronous mode (Tx sync with Rx)
>     Rx is set to be asynchronous, Tx is set to be synchronous.
> 4) synchronous mode (Tx/Rx sync with another SAI's Tx)
> 5) synchronous mode (Tx/Rx sync with another SAI's Rx)
>
> * 4) and 5) are beyond this patch because they are related with another SAI.
>
> As the initial version of this SAI driver, it supported 2) as default while
> the others were totally missing.
>
> So this patch just adds supports for 1) and 3).
>
> Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> ---
>   .../devicetree/bindings/sound/fsl-sai.txt          | 16 ++++++++++++
>   sound/soc/fsl/fsl_sai.c                            | 30 +++++++++++++++++++---
>   sound/soc/fsl/fsl_sai.h                            |  4 +++
>   3 files changed, 46 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/sound/fsl-sai.txt b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> index 0f4e238..77864f4 100644
> --- a/Documentation/devicetree/bindings/sound/fsl-sai.txt
> +++ b/Documentation/devicetree/bindings/sound/fsl-sai.txt
> @@ -24,6 +24,22 @@ Required properties:
>   - big-endian-data: If this property is absent, the little endian mode will
>     be in use as default, or the big endian mode will be in use for all the
>     fifo data.
> +- fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
> +  that SAI will work in the synchronous mode (sync Tx with Rx) which means
> +  both the transimitter and receiver will send and receive data by following
> +  receiver's bit clocks and frame sync clocks.
> +- fsl,sai-asynchronous: This is a boolean property. If present, indicating
> +  that SAI will work in the asynchronous mode, which means both transimitter
> +  and receiver will send and receive data by following their own bit clocks
> +  and frame sync clocks separately.
>
Would be readable if it like this...

fsl,sai-synchronous-rx: This is a boolean property. If present, indicating
			that SAI will work in the synchronous mode (sync Tx with Rx) which means
			both the transimitter and receiver will send and receive data by following
			receiver's bit clocks and frame sync clocks.
- fsl,sai-asynchronous: This is a boolean property. If present, indicating
			that SAI will work in the asynchronous mode, which means both transimitter
			and receiver will send and receive data by following their own bit clocks
			and frame sync clocks separately.
.....

-- 
Regards,
Varka Bhadram.

