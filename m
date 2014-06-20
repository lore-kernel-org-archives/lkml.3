Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965515AbaFTS46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:56:58 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:62070 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaFTS44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:56:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <robherring2@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] dt/documentation: add specification of dma bus information
Date: Fri, 20 Jun 2014 20:56:49 +0200
Message-ID: <4193075.zZSpRTFEYz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53A46CB7.1030109@ti.com>
References: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com> <CAL_JsqJAtWnHKPVpDsdOOzT_X=npc3hroLNTGqULM2SJr=1OEg@mail.gmail.com> <53A46CB7.1030109@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7RUR7hOGm342S+qaxCZYimpovZVMZFB531oUbNXDxSs
 VNhltcifAL+88JGGCmgccI5a7dHGd2xVFPvK2Di4gfpx8KT1NZ
 +fQFvWU67BTZZxW54Zzn+iZFhPnm4MEPi1ImUBNOr4Yi939QvB
 hz9ag+4XP+uCrNXlePF7GWLifxKZf1xMBVeiKlf37XNuDtro2Y
 Kqoqdmfr6cDS3tEoApAEgg2hqCzBn3k5Fds4u0bP0cpCsfAIsa
 KF4okkgKNHShM9TEUZ2c2iqedmoK9OqkyZ3X3wDIL9Jdun0k3s
 Totb60RqLsvliuAuywBgrfW4ERqlJP5x4WP4WUhlR0mFbatjH8
 5A1Tn2av1FgX+pffQXEM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 June 2014 13:17:43 Santosh Shilimkar wrote:
> >> +                       dma-coherent;
> >> +                       dma-ranges;
> >> +
> >> +                       dwc3@2690000 {
> >> +                               compatible = "synopsys,dwc3";
> >> +                               [...]
> >> +                       };
> > 
> > This example is a bit strange. I don't understand the relationship
> > between keystone-dwc3 and synopsys,dwc3, nor do I want to. I'd prefer
> > to see a simple example here.


> > dma-ranges is a property of the parent which you show, but
> > dma-coherent originally was a property of the bus master itself. While
> > we need to support that, are we changing that? We need to be clear on
> > where the property belongs even if the kernel is more lax.
> > 
> I don't think we are changing it fundamentally but may be I missing
> your point. The dma-coherent as is now a per-device property.
> USB is one of the bus master supports coherency and hence showed
> up in above example.

I think it's enough if you just drop the "synopsys,dwc3" node and the
intermediate dma-ranges property from the example, leaving the
dma-coherent property in the "ti,keystone-dwc3" node.

	Arnd
