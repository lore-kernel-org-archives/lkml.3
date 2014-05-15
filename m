Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaEOMk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:40:28 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61920 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaEOMk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:40:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Anders Berg <anders.berg@avagotech.com>,
        Mike Turquette <mturquette@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 0/6] Add platform support for LSI AXM55xx
Date: Thu, 15 May 2014 14:39:55 +0200
Message-ID: <30207873.oHzEC0kjdd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAE0=X_15Yk3VhHTwG-piA_eYL1mKW9wu_Szp-yL0YyfL8m0ecA@mail.gmail.com>
References: <cover.1400072260.git.anders.berg@avagotech.com> <6334605.NlytHCzYVP@wuerfel> <CAE0=X_15Yk3VhHTwG-piA_eYL1mKW9wu_Szp-yL0YyfL8m0ecA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uPHq8dVanhbuQRqAw3DSNBAoMz69AwLHiieeDbra05N
 upoc95F5uJzYrZPNZVYSjTTGEkOuo2u71uN2kBUnwfdhoCBmlG
 K+RqORDiF1Q559T/xlLPi0rCykoLphyAC1RI7rg/WDwL4ofLl9
 64chmRp//GCXWJAUqXXDG1nOe5I8eRgzcwcL/B7MvDNoYM2cXQ
 rZ1ycXd5H6QLjd8SfivvIzd897+V1af8ewXtP8HTpzbrED01Vg
 R+wcdiFOhN2+IMVK83+c/L88BR5Vtl5ZAnIj++aI3Q/WzcvBZw
 2gXfIlG2R1xS3/+Y6fSB8vpOA0Rff3pWpStmDjukpjpZ2mm9V2
 ZptCyRqR/zWYuKz+2AiY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 14:37:26 Anders Berg wrote:
> On Wed, May 14, 2014 at 8:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 14 May 2014 20:37:55 Anders Berg wrote:
> >>
> >> This is version 3 of this series to introduces basic platform support for the LSI
> >> AXM5516 SoC.
> >>
> >> No major changes since v2. Ready to be applied to the arm-soc tree?
> >
> > I think it's good, but I'm not sure if we should put them all into arm-soc.
> > There are no dependencies between the drivers that I can see, so why not
> > merge the clock and reset drivers through the individual subsystem maintainers?
> >
> 
> After suggestions from Mike on the clk driver (and it's dts binding)
> I've done an updated clock driver patch - and a dependency surfaced...
> The file <dt-bindings/clock/lsi,axm5516-clks.h>. Which way should this
> take, arm-soc or Mikes clk tree? Perhaps this is a reason to take it
> all through arm-soc?

I don't see the dependency: The clock driver is built only when CONFIG_ARCH_AXXIA
is set, and that only gets introduced in the platform patches. As long
as the header files come with the platform, it should be fine.

	Arnd
