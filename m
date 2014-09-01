Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaIAIeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:34:12 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35848 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaIAIeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:34:08 -0400
Date: Mon, 1 Sep 2014 09:34:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v5 2/2] mfd: arizona: Update DT binding to
 support INn_MODE init_data
Message-ID: <20140901083400.GD7374@lee--X1>
References: <1409365639-5320-1-git-send-email-ideal.song@samsung.com>
 <1409365639-5320-3-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409365639-5320-3-git-send-email-ideal.song@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2014, Inha Song wrote:

> This patch update DT binding to support INn_MODE init_data. Each
> input signal path can be configurated either as a Analogue or
> Digital using the INn_MODE registers.
> 
> Signed-off-by: Inha Song <ideal.song@samsung.com>
> Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt | 7 +++++++
>  1 file changed, 7 insertions(+)

Applied, thanks.

> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index 5c7e723..7bd1273 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -42,6 +42,13 @@ Optional properties:
>      the chip default will be used.  If present exactly five values must
>      be specified.
>  
> +  - wlf,inmode : A list of INn_MODE register values, where n is the number
> +    of input signals. Valid values are 0 (Differential), 1 (Single-ended) and
> +    2 (Digital Microphone). If absent, INn_MODE registers set to 0 by default.

Please #define these in include/dt-bindings in a subsequent patch.

And an example?

> +    If present, values must be specified less than or equal to the number of
> +    input singals. If values less than the number of input signals, elements
> +    that has not been specifed are set to 0 by default.
> +
>    - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
>      they are being externally supplied. As covered in
>      Documentation/devicetree/bindings/regulator/regulator.txt

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
