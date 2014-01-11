Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbaAKNjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 08:39:00 -0500
Received: from mo6.mail-out.ovh.net ([178.32.228.6]:36446 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaAKNi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 08:38:58 -0500
Message-ID: <52D1494E.9090303@overkiz.com>
Date: Sat, 11 Jan 2014 14:38:22 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: Re: [RFC PATCH 0/9] mtd: nand: add sunxi NAND Flash Controller support
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5272307788826572989
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 15:21, Boris BREZILLON wrote:
> Hello,
>
> This series add the sunxi NFC support with up to 8 NAND chip connected.
> I'm still in the early stages drivers development and some key features are
> missing, but it's usable (I tested it on the cubietruck board).
>
> Here's what's missing:
>   - HW ECC support
>   - DMA support
>   - HW randomization support
>   - many more improvements
>
> This series depends on Emilio's patch series implementing mod0 clks
> (http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/185478.html)
> + an other patch not yet posted
> (http://git.elopez.com.ar/linux/commits/5b4eb3ac406b9c98965714d40e8dd6da943d1ab0)

During my reasearch regarding the HW ECC and HW randomizer of the Allwinner
NAND flash controller I found this document describing the Altera NAND 
flash controller
(which is in turn based on a cadence IP):

http://www.altera.com/literature/hb/arria-v/av_54010.pdf

This really looks like the sunxi NAND flash controller (except for the 
registers positions
and contents) ;-)

>
> Best Regards,
>
> Boris
>
> Boris BREZILLON (9):
>    mtd: nand: retrieve ECC requirements from Hynix READ ID byte 4
>    mtd: nand: define struct nand_timings
>    of: mtd: add NAND timings retrieval support
>    of: mtd: add NAND timings bindings documentation
>    mtd: nand: add sunxi NFC support
>    mtd: nand: add sunxi NFC dt bindings doc
>    ARM: dt/sunxi: add NFC node to Allwinner A20 SoC
>    ARM: dt/sunxi: add NFC pinctrl pin definitions
>    ARM: sunxi/dt: enable NAND on cubietruck board
>
>   Documentation/devicetree/bindings/mtd/nand.txt     |   34 +
>   .../devicetree/bindings/mtd/sunxi-nand.txt         |   71 ++
>   arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |   33 +
>   arch/arm/boot/dts/sun7i-a20.dtsi                   |   35 +
>   drivers/mtd/nand/Kconfig                           |    6 +
>   drivers/mtd/nand/Makefile                          |    1 +
>   drivers/mtd/nand/nand_base.c                       |   37 ++
>   drivers/mtd/nand/sunxi_nfc.c                       |  700 ++++++++++++++++++++
>   drivers/of/of_mtd.c                                |   47 ++
>   include/linux/mtd/nand.h                           |   44 ++
>   include/linux/of_mtd.h                             |    9 +
>   11 files changed, 1017 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mtd/sunxi-nand.txt
>   create mode 100644 drivers/mtd/nand/sunxi_nfc.c
>

