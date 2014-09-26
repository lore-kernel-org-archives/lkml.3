Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaIZDUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:20:08 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:60613 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaIZDUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:20:05 -0400
Message-ID: <5424DB33.1060700@roeck-us.net>
Date: Thu, 25 Sep 2014 20:19:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
CC: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/3] watchdog: qcom: document device tree bindings
References: <cover.1411684967.git.joshc@codeaurora.org> <84605584a0634ad35a7829daf5a148107aaabc72.1411684967.git.joshc@codeaurora.org>
In-Reply-To: <84605584a0634ad35a7829daf5a148107aaabc72.1411684967.git.joshc@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.5424DB64.0100,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 20
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2014 03:51 PM, Josh Cartwright wrote:
> The Qualcomm Krait Processor Sub-system (KPSS) contains one or more
> instances of the WDT.  Provide documentation on how to describe these in
> the device tree.
>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   .../devicetree/bindings/watchdog/qcom-wdt.txt      | 24 ++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
>
> diff --git a/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt b/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
> new file mode 100644
> index 0000000..4726924
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/qcom-wdt.txt
> @@ -0,0 +1,24 @@
> +Qualcomm Krait Processor Sub-system (KPSS) Watchdog
> +---------------------------------------------------
> +
> +Required properties :
> +- compatible : shall contain only one of the following:
> +
> +			"qcom,kpss-wdt-msm8960"
> +			"qcom,kpss-wdt-apq8064"
> +			"qcom,kpss-wdt-ipq8064"
> +
> +- reg : shall contain base register location and length
> +- clocks : shall contain the input clock
> +
> +Optional properties :
> +- timeout-sec : shall contain the default watchdog timeout in seconds,
> +                if unset, the default timeout is 30 seconds
> +
> +Example:
> +	watchdog@208a038 {
> +		compatible = "qcom,kpss-wdt-ipq8064";
> +		reg = <0x0208a038 0x40>;
> +		clocks = <&sleep_clk>;
> +		timeout-sec = <10>;
> +	};
>

