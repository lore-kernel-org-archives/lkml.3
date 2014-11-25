Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaKYL6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:58:24 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:50871 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaKYL6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:58:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: suravee.suthikulpanit@amd.com
Cc: mark.rutland@arm.com, will.deacon@arm.com, marc.zyngier@arm.com,
        catalin.marinas@arm.com, robherring2@gmail.com, liviu.dudau@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: Re: [PATCH V4] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Tue, 25 Nov 2014 12:57:30 +0100
Message-ID: <2285363.CoMWhviz1f@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416865877-8347-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1416865877-8347-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dbIC4pwgP8evsBOcDmC3iOJqYCbGG19OaUZRGULe+9D
 obSrllV2q5H6JoFmVp1bj9i8jTq0sgYiHuPz4JkvQXkUl/4b/A
 nAY4bM6TONLCYSRU2wwiZw5XrYWzAy2MaO3nesu7lWtFfRjYph
 WPuZ18DLlaHwwguuw0nofqNng6Q/r2PFOJATg8eYg6UrUJOmn1
 WjPW6YcTcaVU/Gt/eHLsqwhxzGPN3SUEzdSefkZZX+dRSkd28c
 R5/9yZLhwLGCFnLJ5ANf4FPmAMfp4KJvzRvGe8bzcGixkf7Wfl
 tAF1/wbNm+MyTbq7a/FTCf81UjCX51/MQuVZ5d4KHMk5mbznvr
 HM8S5bMYvG50B3utK7u4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 November 2014 15:51:17 suravee.suthikulpanit@amd.com wrote:
> 
> +	gic: interrupt-controller@e1101000 {
> +		compatible = "arm,gic-400", "arm,cortex-a15-gic";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		#address-cells = <2>;
> +		#size-cells = <2>;
> +		reg = <0x0 0xe1110000 0 0x1000>,
> +		      <0x0 0xe112f000 0 0x2000>,
> +		      <0x0 0xe1140000 0 0x10000>,
> +		      <0x0 0xe1160000 0 0x10000>;
> +		interrupts = <1 9 0xf04>;
> +		ranges;
> +		v2m0: v2m@e1180000 {
> +			compatible = "arm,gic-v2m-frame";
> +			msi-controller;
> +			arm,msi-base-spi = <64>;
> +			arm,msi-num-spis = <256>;
> +			reg = <0x0 0xe1180000 0 0x1000>;
> +		};
> +	};


Having an empty ranges property in the gic seems strange, especially
since the registers of the v2m seem to directly follow the gic's own
registers. Could you limit the ranges to only the registers that
are in the gic or its child devices itself?

	Arnd
