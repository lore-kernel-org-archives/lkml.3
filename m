Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab3J1V5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:57:13 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58446 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3J1V5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:57:11 -0400
Date: Mon, 28 Oct 2013 14:56:49 -0700
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 1/5] ARM: add basic support for Trusted Foundations
Message-ID: <20131028215649.GB10833@quad.lixom.net>
References: <1382956118-12495-1-git-send-email-acourbot@nvidia.com>
 <1382956118-12495-2-git-send-email-acourbot@nvidia.com>
 <D49A3E92-54FD-4275-82F5-DBB476086B03@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D49A3E92-54FD-4275-82F5-DBB476086B03@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 05:57:04AM -0500, Kumar Gala wrote:
> 
> On Oct 28, 2013, at 5:28 AM, Alexandre Courbot wrote:
> 
> > Trusted Foundations is a TrustZone-based secure monitor for ARM that
> > can be invoked using the same SMC-based API on all supported
> > platforms. This patch adds initial basic support for Trusted
> > Foundations using the ARM firmware API. Current features are limited
> > to the ability to boot secondary processors.
> > 
> > Note: The API followed by Trusted Foundations does *not* follow the SMC
> > calling conventions. It has nothing to do with PSCI neither and is only
> > relevant to devices that use Trusted Foundations (like most Tegra-based
> > retail devices).
> > 
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > Reviewed-by: Stephen Warren <swarren@nvidia.com>
> > ---
> > .../arm/firmware/tl,trusted-foundations.txt        | 20 ++++++
> > .../devicetree/bindings/vendor-prefixes.txt        |  1 +
> > arch/arm/Kconfig                                   |  2 +
> > arch/arm/Makefile                                  |  1 +
> > arch/arm/firmware/Kconfig                          | 28 ++++++++
> > arch/arm/firmware/Makefile                         |  1 +
> > arch/arm/firmware/trusted_foundations.c            | 79 ++++++++++++++++++++++
> > arch/arm/include/asm/trusted_foundations.h         | 67 ++++++++++++++++++
> > 8 files changed, 199 insertions(+)
> > create mode 100644 Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
> > create mode 100644 arch/arm/firmware/Kconfig
> > create mode 100644 arch/arm/firmware/Makefile
> > create mode 100644 arch/arm/firmware/trusted_foundations.c
> > create mode 100644 arch/arm/include/asm/trusted_foundations.h
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
> > new file mode 100644
> > index 0000000..2ec75c9
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
> > @@ -0,0 +1,20 @@
> > +Trusted Foundations
> > +-------------------
> > +
> > +Boards that use the Trusted Foundations secure monitor can signal its
> > +presence by declaring a node compatible with "tl,trusted-foundations"
> > +under the /firmware/ node
> > +
> > +Required properties:
> > +- compatible : "tl,trusted-foundations"
> > +- version-major : major version number of Trusted Foundations firmware
> > +- version-minor: minor version number of Trusted Foundations firmware
> 
> vendor prefix version.

Are you saying he should use tl,version-major tl,version-minor? For bindings
that are already vendor-specific we haven't (on ARM) asked for vendor prefix on
properties. It doesn't mean that we should keep going down that route though,
so I'm just asking for clarification for my own edification. :)


-Olof
