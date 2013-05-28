Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab3E1FrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 01:47:04 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37345 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab3E1FrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 01:47:02 -0400
Date: Mon, 27 May 2013 22:47:01 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linus.walleij@linaro.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Boris BREZILLON <linux-arm@overkiz.com>
Subject: Re: [GIT PULL] at91: cleanup (pinctrl macros, defconfigs) for 3.11 #1
Message-ID: <20130528054701.GB18476@quad.lixom.net>
References: <1368799336-25226-1-git-send-email-nicolas.ferre@atmel.com>
 <519F9116.8060109@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519F9116.8060109@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 06:11:02PM +0200, Nicolas Ferre wrote:
> On 17/05/2013 16:02, Nicolas Ferre :
> >Arnd, Olof,
> >
> >Here is the first AT91 cleanup pull-request for 3.11. I is dominated by a big
> >update of DT files because of the move to macros in pinctrl. As we plan to
> >make this "cleanup" series the base of all our work on AT91 for 3.11, we would
> >like to see it appearing early in arm-soc and linux-next: this is why we send
> >it to you right now.
> >
> >We have colected the Acked-by from Linus Walleij and we all think that it makes
> >sense to merge this material through arm-soc tree:
> >- is touches nearly nothing of pinctrl actual code (a header file)
> >- all dtsi/dts modifications for 3.11 will need this as a codebase for avoiding
> >   merging nightmare
> >
> >I hope that it is okay with you.
> >
> >Thanks, best regards,
> >
> >The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:
> >
> >   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
> >
> >are available in the git repository at:
> >
> >   git://github.com/at91linux/linux-at91.git tags/at91-cleanup
> 
> Arnd, Olof,
> 
> After having sent the second "fixes" pull-request to you, I want to
> warn you about merging conflicts concerning this "cleanup"
> pull-request for 3.11.
> 
> 2 merging conflicts are appearing when placing the "cleanup" branch
> on top of the "fixes" material contained today in at91-fixes tag.
> To address this, I have pushed a resolution branch on our usual git tree:
> 
> git://github.com/at91linux/linux-at91.git   at91-3.11-cleanup1+resolved
> 
> In case of any question, please let me know. If you want me to
> rebase the original tag that I've sent you, I can do it as well.

Hi,

Thanks, not a big deal for us to resolve so that's ok.

Pulled in the branch. Some comments below:


> >----------------------------------------------------------------
> >Big update with pinctrl by use of macros and
> >header files. Increases readability and avoid
> >typos.
> >Update of AT91 defconfigs and merge of defconfigs for
> >SoC look-alike:
> >sam9260/9g20 and sam9261/9g10.

This is hard to follow, please structure them better in the future.

> >----------------------------------------------------------------
> >Jean-Christophe PLAGNIOL-VILLARD (6):
> >       ARM: at91: dt: use #include for all device trees
> >       ARM: at91: dt: switch to standard GPIO flag defines.
> >       ARM: at91: dt: add pinctrl pre-processor define
> >       ARM: at91: dt: switch to pinctrl to pre-processor
> >       ARM: at91: dt: switch to standard IRQ flag defines
> >       ARM: at91: udpate defconfigs

Typo in the patch subject, please keep an eye on these in the future.

> >  arch/arm/configs/at91_dt_defconfig                 |  55 ++-
> >  arch/arm/configs/at91rm9200_defconfig              | 218 ++-------
> >  ...am9g20_defconfig => at91sam9260_9g20_defconfig} |  67 ++-
> >  arch/arm/configs/at91sam9260_defconfig             |  91 ----
> >  ...am9261_defconfig => at91sam9261_9g10_defconfig} |  19 +-
> >  arch/arm/configs/at91sam9263_defconfig             |  39 +-
> >  arch/arm/configs/at91sam9g45_defconfig             |  94 ++--
> >  arch/arm/configs/sama5_defconfig                   |  35 +-
> >  arch/arm/mach-at91/Kconfig.non_dt                  | 159 +++----
> >  arch/arm/mach-at91/Makefile                        |   2 -
> >  arch/arm/mach-at91/board-sam9261ek.c               |  28 +-
> >  include/dt-bindings/pinctrl/at91.h                 |  35 ++
> >  63 files changed, 1407 insertions(+), 1617 deletions(-)
> >  rename arch/arm/configs/{at91sam9g20_defconfig => at91sam9260_9g20_defconfig} (67%)
> >  delete mode 100644 arch/arm/configs/at91sam9260_defconfig
> >  rename arch/arm/configs/{at91sam9261_defconfig => at91sam9261_9g10_defconfig} (91%)
> >  create mode 100644 include/dt-bindings/pinctrl/at91.h

Good to see consolidation, it'd be awesome if there could be even more.


-Olof
