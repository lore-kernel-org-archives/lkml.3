Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbbA0Qa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:30:28 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57849 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbbA0QaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:30:25 -0500
Date: Tue, 27 Jan 2015 08:30:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Cc: wim@iguana.be, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, paul@crapouillou.net
Subject: Re: [PATCH 1/2] dt: watchdog: Add DT binding documentation for
 jz47xx watchdog timer
Message-ID: <20150127163008.GA21459@roeck-us.net>
References: <1422371490-44402-1-git-send-email-Zubair.Kakakhel@imgtec.com>
 <1422371490-44402-2-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422371490-44402-2-git-send-email-Zubair.Kakakhel@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54C7BD21.0063,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On Tue, Jan 27, 2015 at 03:11:29PM +0000, Zubair Lutfullah Kakakhel wrote:
> Add binding for jz47xx watchdog timer. It is a simple watchdog timer.
> Needs rtc clock and register addresses
> 
> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
> 
> ---
> The jz4740 is platform only at the moment.
> 
> But DT support is being added
> 
> See http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/
> 
> jz47xx is used because jz4780 will also use this driver

Not a valid argument. Please use jz4740, per convention.

xx implies anything from 00 to 99, which is not necessarily correct.
If support for other chips is added, that information can be mentioned
in the file itself, as it is done for many other drivers.

> ---
>  .../devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt b/Documentation/devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt
> new file mode 100644
> index 0000000..bf4c404
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/watchdog/ingenic,jz47xx-wdt.txt
> @@ -0,0 +1,17 @@
> +Ingenic Watchdog Timer (WDT) Controller for JZ47XX
> +
> +Required properties:
> +compatible: "ingenic,jz4740-watchdog"
> +reg: Register address and length for watchdog registers
> +clocks: phandle to rtcclk
> +clock-names: must be "rtc"
> +
> +Example:
> +
> +watchdog: jz47xx-watchdog@0x10002000 {
> +	compatible = "ingenic,jz4780-watchdog";

"ingenic,jz4780-watchdog" is not listed as possible value above,
nor is it listed in the patch itself, so you can not use it here.

> +	reg = <0x10002000 0x100>;
> +
> +	clocks = <&rtclk>;
> +	clock-names = "rtc";
> +};
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
