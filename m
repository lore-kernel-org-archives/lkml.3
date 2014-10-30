Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbaJ3KLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:11:34 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54570 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933783AbaJ3KL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:11:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: flora.fu@mediatek.com, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, arm@kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srv_heupstream@mediatek.com, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 3/3] ARM: dts: mt8135: Add Reset Controller for MediaTek SoC
Date: Thu, 30 Oct 2014 11:11:09 +0100
Message-ID: <2325869.W8YWKQm70A@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414659745.3069.2.camel@pengutronix.de>
References: <1414638733-10080-1-git-send-email-flora.fu@mediatek.com> <1414638733-10080-4-git-send-email-flora.fu@mediatek.com> <1414659745.3069.2.camel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LfnDJ/ITFDWp/aUb7VIlZfBCnS0a1HpJ+o74idJPbyS
 0RjqGHvILDdX6WbFQNM5GADTncV0yAEcgf+k2IJsbHn+a+HOhK
 QArxkcV98tXLCRg4woJNUGJYO4nJUq+XXOmqyrw8nle3hNNGTv
 A0nhvbeBQw9I48KK2ZnWLkwUGAqT3iFkLCO6aq6via1lGch6Bq
 7v9NlOfT/GO/aUnTcfQHHMXpr8bKLCUhgXM5wCmmBJaaLeH4Qp
 fu5Y8ZqlguvXQTrSqBFblU2LefhLfmP3mzOKfvm4hIYvj7pFPk
 ZYxHTnTu9VJy1h3SlKMNOrOJfYixa8so3m5+x/XEa81/WFBQcZ
 hVE93jZvTY0u+ONHn1W4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 10:02:25 Philipp Zabel wrote:
> Since the reset controller driver accesses registers solely through the
> syscon regmap, I'd prefer to keep with the device tree control graph
> concept and make the reset-controller nodes children of the syscon
> nodes. I've brought this up before: https://lkml.org/lkml/2014/5/27/422,
> and I think this is another case where child node support for syscon
> makes sense:
> 
>         infracfg: syscon@10001000 {
>                 compatible = "mediatek,mt8135-infracfg", "syscon";
>                 reg = <0 0x10001000 0 0x1000>;
>                 
>                 infrarst: reset-controller@30 {
>                         #reset-cells = <1>;
>                         compatible = "mediatek,mt8135-infracfg-reset", "mediatek,reset";
>                         reg = <0x30 0x8>;
>                 };
>         };
> 

Yes, this looks much better to me too.

	Arnd
