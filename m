Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3JQJZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:25:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59135 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab3JQJZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:25:35 -0400
Message-ID: <525FACA9.3060405@ti.com>
Date: Thu, 17 Oct 2013 12:23:53 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
CC: linux-arm <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>
Subject: [PATCH 0/2] OMAP4460: cpuidle: Workaround for ROM bug because of
 CA9 r2pX GIC control register change
References: <1382000776-15897-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1382000776-15897-1-git-send-email-grygorii.strashko@ti.com>
X-Forwarded-Message-Id: <1382000776-15897-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.172]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same workaround as ff999b8a0983ee15668394ed49e38d3568fc6859
"ARM: OMAP4460: Workaround for ROM bug because of CA9 r2pX GIC control register change."
need to be applied not only when system is booting, but when
MPU hits OSWR state through CPUIdle too.

Now the same issue is reproduced on boards PandaES and Tablet/Blaze with
SOM OMAP4460 ES1.0 when CONFIG_CPU_IDLE is enabled.
- GIC distributor is disabled
- scheduling is not performed any more

Grygorii Strashko (2):
  Revert "ARM: OMAP4+: CPUidle: Deprecate use of omap4_mpuss_read_prev_context_state()"
  ARM: OMAP4460: cpuidle: WA for ROM bug because of CA9 r2pX gic control register change

 arch/arm/mach-omap2/common.h              |    6 +++++
 arch/arm/mach-omap2/cpuidle44xx.c         |   35 +++++++++++++++++++++++++++--
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |   14 ++++++++++++
 arch/arm/mach-omap2/omap4-common.c        |    6 +++++
 4 files changed, 59 insertions(+), 2 deletions(-)

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>

Regards,
-grygorii
-- 
1.7.9.5



