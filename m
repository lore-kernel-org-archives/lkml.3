Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbaCKU4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:56:43 -0400
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:40482 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755316AbaCKU4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:56:42 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH for 3.14] ARM: at91: fix network interface ordering for sama5d36
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <1394462238-22313-1-git-send-email-nicolas.ferre@atmel.com>
Date: Wed, 12 Mar 2014 04:56:28 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "<linux-arm-kernel@lists.infradead.org> mailing list" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        ARM Maintainers <arm@kernel.org>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <366E83ED-36B1-469F-891C-5B0E8916D85A@jcrosoft.com>
References: <1394462238-22313-1-git-send-email-nicolas.ferre@atmel.com>
To: Nicolas FERRE <nicolas.ferre@atmel.com>
X-Mailer: Apple Mail (2.1827)
X-Ovh-Tracer-Id: 8682095657570904940
X-Ovh-Remote: 193.138.220.90 (90.220.138.193.client.dyn.strong-ba1.blackoakcomputers.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrvddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 10, 2014, at 10:37 PM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> From: Boris BREZILLON <b.brezillon.dev@gmail.com>
> 
> On the newly introduced sama5d36, Gigabit and 10/100 Ethernet network
> interfaces are probed in a different order than for the sama5d35.
> Moreover, users are accustomed to this order in bootloaders and backports
> for older kernel revisions.
> So this patch switches DT node order as it is done for the other dual-Ethernet
> sama5d3 SoC.
> Better interface numbering which does not depend on DT node order is being
> developed for stronger interface identification.

twick ethernet enumerating by playing on the DT order is week

It’s better to introduce a new property

linux,ethernet-id or something like or simply rely on other information on the userspace to identify the
proper interface

Nicolas for AT91 keep me in Cc

Best Regards,
J.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Olof, Arnd and Kevin,
> 
> I would like to include this fix in 3.14-final.
> I do not have anymore patch for an at91-3.14-fixes branch so I only send this
> single patch to you. Can you still take it?
> 
> Thanks, best regards,
> 
> arch/arm/boot/dts/sama5d36.dtsi | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d36.dtsi b/arch/arm/boot/dts/sama5d36.dtsi
> index 6c31c26e6cc0..db58cad6acd3 100644
> --- a/arch/arm/boot/dts/sama5d36.dtsi
> +++ b/arch/arm/boot/dts/sama5d36.dtsi
> @@ -8,8 +8,8 @@
>  */
> #include "sama5d3.dtsi"
> #include "sama5d3_can.dtsi"
> -#include "sama5d3_emac.dtsi"
> #include "sama5d3_gmac.dtsi"
> +#include "sama5d3_emac.dtsi"
> #include "sama5d3_lcd.dtsi"
> #include "sama5d3_mci2.dtsi"
> #include "sama5d3_tcb1.dtsi"
> -- 
> 1.8.2.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

