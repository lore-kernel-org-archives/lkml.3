Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaLCKrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:47:43 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:64409 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLCKrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:47:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Agner <stefan@agner.ch>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] irqchip: gic: define register_routable_domain_ops conditional
Date: Wed, 03 Dec 2014 11:46:34 +0100
Message-ID: <5174649.NxPq80uDz8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417565531-4507-4-git-send-email-stefan@agner.ch>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch> <1417565531-4507-4-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GT2IHX1zGVEheLuNi0ddtbvtCrnMBPntR6WZGfxUXpd
 Dosdm0yWNZ9sqpFHrjpS3S01NZFTbc6Kwsefm2L54m9H9N8H7w
 k1wdsnF+GLi2MzvyICM1Y/QVroexFsxh3ePYx+pFKLexyvGvj/
 JZxUxEAw7XvsUtAlybU69IfZZptOcIW5y0+ohBu4CmZaqDVl5E
 hzMsFSHirYwwfKrS5n0jF29cIueDBctGP1LCvaNMeeKfN/QItA
 Nq1WjsRrphWhRYUgrd88l+ar2V1Do13M8s/PfNp8H/aRxClGoA
 261dr04pS39XkyRyjHGrC3YCg+5Z0NOCNs/Xyrntpbmgfqh5xA
 K7gUGCr7H7bra9dkA+Rc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 01:12:02 Stefan Agner wrote:
> The inline function register_routable_domain_ops is only usable if
> CONFIG_ARM_GIC is set. Make it depend on this configuration. This
> also allows other SoC interrupt controller to provide such a
> function.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

I don't think this is a good idea: either the interface is meant
to be generic and should work with any interrupt controller, or
it is specific to one irqchip and another irqchip should provide
a different interface that has a nonconflicting name.

I suppose you want the latter here, given that the declaration
is part of the gic specific header file.

	Arnd
