Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3KRIkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 03:40:11 -0500
Received: from 7.mo2.mail-out.ovh.net ([188.165.48.182]:40376 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243Ab3KRIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 03:40:08 -0500
Message-ID: <5289D23B.6090101@overkiz.com>
Date: Mon, 18 Nov 2013 09:39:23 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/9] ARM: at91/dt: add ethernet phy to at91rm9200ek board
References: <1377687640-10529-1-git-send-email-b.brezillon@overkiz.com> <1377687819-10653-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1377687819-10653-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15170375346177669241
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/2013 13:03, Boris BREZILLON wrote:
> Add ethernet phy node in at91rm9200ek.dts.
> The reg register is not specified, as it may differ depending on the init
> process of the board:
> ADDR0/1 phy pins are connected to PA13/14 rm9200 pins. Which means the phy
> will take its address from these pins during the reset process.
>
> The macb driver will launch a full scan on the mdio bus to discover the phy
> address.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   arch/arm/boot/dts/at91rm9200ek.dts |    5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm/boot/dts/at91rm9200ek.dts b/arch/arm/boot/dts/at91rm9200ek.dts
> index d2d72c3..37b0880 100644
> --- a/arch/arm/boot/dts/at91rm9200ek.dts
> +++ b/arch/arm/boot/dts/at91rm9200ek.dts
> @@ -47,6 +47,11 @@
>   			macb0: ethernet@fffbc000 {
>   				phy-mode = "rmii";
>   				status = "okay";
> +
> +				phy0: ethernet-phy {
> +					interrupt-parent = <&pioC>;
> +					interrupts = <4 IRQ_TYPE_EDGE_FALLING>;

rm9200 pio controller does not support specific edge detection.
The line above should be replaced with:
				interrupts = <4 IRQ_TYPE_EDGE_BOTH>;
or
				interrupts = <4 0>;

Nicolas, I know you were planning to push this patch for 3.14.
If you haven't done it yet (or if you changed your mind), I can send a 
new version including this fix.


> +				};
>   			};
>
>   			usb1: gadget@fffb0000 {
>

