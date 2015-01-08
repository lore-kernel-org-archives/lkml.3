Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbbAHWmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:42:39 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:60792 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbbAHWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:42:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Baruch Siach <baruch@tkos.co.il>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] ARM: digicolor: add minimal device tree description
Date: Thu, 08 Jan 2015 23:41:52 +0100
Message-ID: <20032538.pHVo39OjvN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9d8d7aed6220e9e92ab70217a65d3291924cfa71.1420744369.git.baruch@tkos.co.il>
References: <cover.1420744368.git.baruch@tkos.co.il> <9d8d7aed6220e9e92ab70217a65d3291924cfa71.1420744369.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:zHiJRey7e8IS0O9qcdpcR7rVLo682H7+DC1cju+4GJDE0xiLQtL
 y9aDxaK60vXRm//lxxYNL9qxB82IcfDqVUfU1p5USdpjgy3+Fiq32O9BD4tdv7921FVCalR
 feef3nmW1PB53kHJyp3+5JE0Bzday/q/ZAvSHC2QiKgDyZxBAQ7k6DLlfDWHSo6INFi2uR1
 MGN8qAk/+td1kvD4gs/7w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2015 21:39:59 Baruch Siach wrote:
> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200 earlyprintk";
> +	};
> +};

Please don't put earlyprintk into the dtb. Hopefully by the next
merge window we will have working earlycon support as a replacement.
You can already put an stdout-path property into the chosen node
for this.

> +	interrupt-parent = <&intc>;
> +
> +	aliases {
> +		serial0 = &uart0;
> +		serial1 = &uart1;
> +		serial2 = &uart2;
> +	};

Better move the aliases into the board specific file.

	Arnd
