Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030910Ab3DSPCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:02:05 -0400
Received: from mo3.mail-out.ovh.net ([178.32.228.3]:60104 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030622Ab3DSPCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:02:03 -0400
Date: Fri, 19 Apr 2013 16:57:12 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, tanzilli@acmesystems.it,
        dgilbert@interlog.com, robertcnelson@gmail.com
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 1/5] ARM: at91: at91sam9x5 RTC is not compatible with
 at91rm9200 one
Message-ID: <20130419145712.GG4998@game.jcrosoft.org>
References: <cover.1366289869.git.nicolas.ferre@atmel.com>
 <864f10566b35864d469f6ff2913b9afaa0c69350.1366289869.git.nicolas.ferre@atmel.com>
 <51714C74.2030907@cogentembedded.com>
 <51714F47.5040006@atmel.com>
 <51715988.9060606@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51715988.9060606@cogentembedded.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6664483025554287543
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrvdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrvdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:49 Fri 19 Apr     , Sergei Shtylyov wrote:
> On 19-04-2013 18:05, Nicolas Ferre wrote:
> 
> >>>Due to a bug with RTC IMR, we cannot consider at91sam9x5 RTC compatible
> >>>with the previous one. Modify DT compatibility string, even if the driver
> >>>is not yet modified to take it into account.
> 
> >>>Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >>>---
> >>>   arch/arm/boot/dts/at91sam9x5.dtsi | 2 +-
> >>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> >>>diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi
> >>>b/arch/arm/boot/dts/at91sam9x5.dtsi
> >>>index a3d4464..58747f3 100644
> >>>--- a/arch/arm/boot/dts/at91sam9x5.dtsi
> >>>+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
> >>>@@ -564,7 +564,7 @@
> >>>               };
> >>>
> >>>               rtc@fffffeb0 {
> >>>-                compatible = "atmel,at91rm9200-rtc";
> >>>+                compatible = "atmel,at91sam9x5-rtc";
> 
> >>    Do not use wildcards in the "compatible" prop values (I guess 'x' is
> >>a wildcard).
> 
> >Well, it is for naming a series of hardware, not for giving a generic
> >name that could cover different hardware.
> 
> >In the sense of Atmel it is our way to call the at91sam9x5 series of
> >SoC: you will see that the code that covers these SoCs is always named
> >like this.
> >In fact, the hardware contained in these SoC cannot be different from
> >one flavor of the family to the other.
> 
>    Nevertheless, the wildcards shouldn't be used. Use the name of
> e.g. the first member of the family.
we use this across others bindings

at91sam9x5 is the name of the Family

Best Regards,
J.
