Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3LORql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 12:46:41 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52534 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3LORqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 12:46:39 -0500
Message-ID: <52ADE93B.3070907@linaro.org>
Date: Sun, 15 Dec 2013 11:39:07 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] clk: bcm281xx: add initial clock framework support
References: <529F4B0F.2020801@linaro.org> <529F4B4F.4020405@linaro.org> <20131214235731.26321.53050@quantum>
In-Reply-To: <20131214235731.26321.53050@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 05:57 PM, Mike Turquette wrote:
> Quoting Alex Elder (2013-12-04 07:33:35)
>> +       return true;
>> +}
>> +
>> +/* A bit position must be less than the number of bits in a 32-bit
>> register. */
> 
> Hi Alex,
> 
> The patch is corrupt at line 634 and several other places below.  Did
> you edit it manually? I'm happy with the series after reviewing it but
> it cannot be applied. Can you fix the issue and send me a pull request?
> 
> Thanks,
> Mike
> 

First, yes I sent it manually (copy from the git-generated patch
and paste into a mail message, and I'm sorry about that.  I have
yet to set up my Linaro settings for "git-send-email" and I'll
do that this week.

I have a v3 that has been updated to apply to v3.13-rc3 (there
is no -rc4 yet).

I'm not sure how this works with the series of 8 patches from Tim
Kryger that it depends on.  But here is a pull request for the
version (including the prerequisites) based on 3.13-rc3.  (It is
done manually again, so there are some line wraps...)

Thanks a lot for the review Mike.  I know you're a busy guy.

					-Alex

The following changes since commit 374b105797c3d4f29c685f3be535c35f5689b30e:

  Linux 3.13-rc3 (2013-12-06 09:34:04 -0800)

are available in the git repository at:

  ssh://git@git.linaro.org/people/alex.elder/linux.git
review/bcm-kona-clocks-v3

for you to fetch changes up to cf62c29babf6068abf91588411704566812b7900:

  ARM: dts: bcm281xx: define real clocks (2013-12-13 10:40:21 -0600)

----------------------------------------------------------------
Alex Elder (3):
      clk: bcm281xx: define kona clock binding
      clk: bcm281xx: add initial clock framework support
      ARM: dts: bcm281xx: define real clocks

Tim Kryger (8):
      ARM: dts: Declare clocks as fixed on bcm11351
      ARM: dts: Specify clocks for UARTs on bcm11351
      Documentation: dt: kona-sdhci: Add clocks property
      ARM: dts: Specify clocks for SDHCIs on bcm11351
      mmc: sdhci-bcm-kona: Add basic use of clocks
      Documentation: dt: kona-timer: Add clocks property
      clocksource: kona: Add basic use of external clock
      ARM: dts: Specify clocks for timer on bcm11351

 .../devicetree/bindings/arm/bcm/kona-timer.txt     |    7 +-
 .../devicetree/bindings/clock/bcm-kona-clock.txt   |   93 ++
 .../devicetree/bindings/mmc/kona-sdhci.txt         |    4 +
 arch/arm/boot/dts/bcm11351.dtsi                    |  199 +++-
 drivers/clk/Kconfig                                |    1 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/bcm/Kconfig                            |    8 +
 drivers/clk/bcm/Makefile                           |    3 +
 drivers/clk/bcm/clk-bcm281xx.c                     |  416 ++++++++
 drivers/clk/bcm/clk-kona-setup.c                   |  769 +++++++++++++++
 drivers/clk/bcm/clk-kona.c                         | 1033
++++++++++++++++++++
 drivers/clk/bcm/clk-kona.h                         |  414 ++++++++
 drivers/clocksource/bcm_kona_timer.c               |   14 +-
 drivers/mmc/host/sdhci-bcm-kona.c                  |   37 +-
 include/dt-bindings/clock/bcm281xx.h               |   65 ++
 15 files changed, 3053 insertions(+), 11 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/clock/bcm-kona-clock.txt
 create mode 100644 drivers/clk/bcm/Kconfig
 create mode 100644 drivers/clk/bcm/Makefile
 create mode 100644 drivers/clk/bcm/clk-bcm281xx.c
 create mode 100644 drivers/clk/bcm/clk-kona-setup.c
 create mode 100644 drivers/clk/bcm/clk-kona.c
 create mode 100644 drivers/clk/bcm/clk-kona.h
 create mode 100644 include/dt-bindings/clock/bcm281xx.h

