Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab3J1Xbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:31:40 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:33785 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab3J1Xbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:31:38 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Olof Johansson <olof@lixom.net>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <Mark.Rutland@arm.com>, devicetree@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Alexandre Courbot <acourbot@nvidia.com>, linux-tegra@vger.kernel.org,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v9 1/5] ARM: add basic support for Trusted Foundations
Date: Tue, 29 Oct 2013 00:31:36 +0100
Message-ID: <2702565.PHk13m6fVo@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.6-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131028215649.GB10833@quad.lixom.net>
References: <1382956118-12495-1-git-send-email-acourbot@nvidia.com> <D49A3E92-54FD-4275-82F5-DBB476086B03@codeaurora.org> <20131028215649.GB10833@quad.lixom.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 of October 2013 14:56:49 Olof Johansson wrote:
> On Mon, Oct 28, 2013 at 05:57:04AM -0500, Kumar Gala wrote:
> > On Oct 28, 2013, at 5:28 AM, Alexandre Courbot wrote:
> > > Trusted Foundations is a TrustZone-based secure monitor for ARM that
> > > can be invoked using the same SMC-based API on all supported
> > > platforms. This patch adds initial basic support for Trusted
> > > Foundations using the ARM firmware API. Current features are limited
> > > to the ability to boot secondary processors.
> > > 
> > > Note: The API followed by Trusted Foundations does *not* follow the
> > > SMC
> > > calling conventions. It has nothing to do with PSCI neither and is
> > > only
> > > relevant to devices that use Trusted Foundations (like most
> > > Tegra-based
> > > retail devices).
> > > 
> > > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > > Reviewed-by: Stephen Warren <swarren@nvidia.com>
> > > ---
> > > .../arm/firmware/tl,trusted-foundations.txt        | 20 ++++++
> > > .../devicetree/bindings/vendor-prefixes.txt        |  1 +
> > > arch/arm/Kconfig                                   |  2 +
> > > arch/arm/Makefile                                  |  1 +
> > > arch/arm/firmware/Kconfig                          | 28 ++++++++
> > > arch/arm/firmware/Makefile                         |  1 +
> > > arch/arm/firmware/trusted_foundations.c            | 79
> > > ++++++++++++++++++++++ arch/arm/include/asm/trusted_foundations.h  
> > >       | 67 ++++++++++++++++++ 8 files changed, 199 insertions(+)
> > > create mode 100644
> > > Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundatio
> > > ns.txt create mode 100644 arch/arm/firmware/Kconfig
> > > create mode 100644 arch/arm/firmware/Makefile
> > > create mode 100644 arch/arm/firmware/trusted_foundations.c
> > > create mode 100644 arch/arm/include/asm/trusted_foundations.h
> > > 
> > > diff --git
> > > a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundat
> > > ions.txt
> > > b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundat
> > > ions.txt new file mode 100644
> > > index 0000000..2ec75c9
> > > --- /dev/null
> > > +++
> > > b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundat
> > > ions.txt @@ -0,0 +1,20 @@
> > > +Trusted Foundations
> > > +-------------------
> > > +
> > > +Boards that use the Trusted Foundations secure monitor can signal
> > > its
> > > +presence by declaring a node compatible with
> > > "tl,trusted-foundations"
> > > +under the /firmware/ node
> > > +
> > > +Required properties:
> > > +- compatible : "tl,trusted-foundations"
> > > +- version-major : major version number of Trusted Foundations
> > > firmware
> > > +- version-minor: minor version number of Trusted Foundations
> > > firmware
> > 
> > vendor prefix version.
> 
> Are you saying he should use tl,version-major tl,version-minor? For
> bindings that are already vendor-specific we haven't (on ARM) asked for
> vendor prefix on properties. It doesn't mean that we should keep going
> down that route though, so I'm just asking for clarification for my own
> edification. :)

This is a good question. We should decide what the right thing (TM) is and 
write it down. I, on the contrary, was convinced that it's the way Kumar 
says.

Best regards,
Tomasz

