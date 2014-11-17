Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaKQLTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:19:53 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:55614 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaKQLTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:19:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ankit Jindal <ankit.jindal@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Varka Bhadram <varkabhadram@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anup Patel <anup@brainfault.org>, Guenter Roeck <linux@roeck-us.net>,
        patches@apm.com, Rob Herring <robh+dt@kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH v5 5/6] Documentation: dt-bindings: Add binding info for X-Gene QMTM UIO driver
Date: Mon, 17 Nov 2014 12:17:16 +0100
Message-ID: <2279061.naADrHDgyn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416220572-13381-6-git-send-email-ankit.jindal@linaro.org>
References: <1416220572-13381-1-git-send-email-ankit.jindal@linaro.org> <1416220572-13381-6-git-send-email-ankit.jindal@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Hd+UhnvjslDXOzO1zL1Rtdp8qMXoJXCOquZnEQWF/m1
 7DSlILSEa8p/A23o9t0rh+98GTFACOOvkZ6/4HLRCYbFOIpetD
 eEV435Tsv8axYPczXkSWD8ALD++ayUdrwTHv+i2/NGnrMOwY5t
 OcqWZnk1+2f4Ic/9dHPPdHFTd8hmZCS1KzzHiG8TA930CwUImm
 hWNysJ2yGuGw8+oRTNOLfgd4ZoQcBGliGWKl0g6yYyA+d16L/9
 jiBzQNGGBm7rlLmimJwmxQYUgaihlZ5kaLTCkzPXQr2r9Xg7bb
 cNzA27LB4NmP2MAOYT0vV3iC+oNmpCLiMiNPU16CWxgjm0goUL
 1Sp4iKxZ6c0lIxjNXKBw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 16:06:11 Ankit Jindal wrote:
> +
> +       qmtm1_uio: qmtm_uio@1f200000 {
> +               compatible = "apm,xgene-qmtm";
> +               status = "disabled";
> +               reg = <0x0 0x1f200000 0x0 0x10000>,
> +                     <0x0 0x1b000000 0x0 0x400000>;
> +               reg-names = "csr", "fabric";
> +               qpool-memory = <&qmtm1_uio_qpool>;
> +               clocks = <&qmtm1clk 0>;
> +               num-queues = <0x400>;
> +               devid = <1>;
> +       };
> +

To make my previous review comments clearer:

NAK

Do not create device nodes that are meant for a specific use case in
software and that are not usable for the common case. I don't think
it makes any sense to keep on submitting a UIO driver for this until
we have a proper network driver that uses this so we can make sure we
have a working binding.

	Arnd
