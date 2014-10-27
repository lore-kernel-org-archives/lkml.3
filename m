Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaJ0THc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:07:32 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58538 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbaJ0THa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:07:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: suravee.suthikulpanit@amd.com, mark.rutland@arm.com, will.deacon@arm.com,
        catalin.marinas@arm.com, Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>, marc.zyngier@arm.com,
        liviu.dudau@arm.com, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH V2] arm64: amd-seattle: Adding device tree for AMD Seattle platform
Date: Mon, 27 Oct 2014 20:07:22 +0100
Message-ID: <2202046.Qx9l5PJfzL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414436065-7717-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1414436065-7717-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/3iqFt2eFOvDm9RLWxl7zGTE7id5S+eb92CkRQpsVM0
 Tv+ZPUA0kNcFQb6B11G9YcDswIem8S829LxpBT6D9qwrd8V0vA
 xIiTRSQyO35sb5GPzv2cAuma7ttRGC1JO3yL6Q9t6jLXB1LHh4
 Qu6ZnTh8XQ7GOJcqGwZAH+4hDTNPuS4nUGrMGhi2bQpEpuXqoz
 vr4lQQ90Ykq3EE+vEIWZ8pfo3CUGH8g2C0QC9frg9knBv5C1UM
 hquRftjalTquV7PXCCXlRxXnXtYH8hsGKQkCBx032+olJCjTJV
 dWu7WfCfIgQKCATDsuitCvzOIvHovkDJoIWr/NrvTXDqZmhrmM
 1mvuik8cCE+47fLRb0fk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 October 2014 13:54:25 suravee.suthikulpanit@amd.com wrote:
> +       sata0: sata@00300000 {
> +               compatible = "snps,spear-ahci";
> +               reg = <0 0x300000 0 0x800>;
> +               interrupts = <0 355 4>;
> +               clocks = <&sataclk_333mhz>;
> +               clock-names = "apb_pclk";
> +               dma-coherent;
> +       };

Please use "snps,dwc-ahci" as the compatible string for a designware
ahci controller, not "snps,spear-ahci", which refers to the implementation
of that in the ST microelectronics SPEAr consumer SoC.

It would be good to also add a string that is specific for your SoC if
we ever need to identify it directly.

	Arnd
