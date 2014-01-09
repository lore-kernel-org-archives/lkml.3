Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaAIUAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:00:38 -0500
Received: from trabant.uid0.hu ([81.0.124.200]:51253 "EHLO trabant.uid0.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbaAIUAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:00:31 -0500
X-Greylist: delayed 2778 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2014 15:00:31 EST
Date: Thu, 09 Jan 2014 20:13:58 +0100
Subject: Re: [Xen-devel] [PATCH v9 0/5] xen/arm/arm64: CONFIG_PARAVIRT and
 stolen ticks accounting
Message-ID: <xocg2t9u8bji0r73dls3pkqc.1389294838857@email.android.com>
From: Zoltan HERPAI <wigyori@uid0.hu>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <Ian.Campbell@citrix.com>, arnd@arndb.de,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        " marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        " linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org " 
	<linux-arm-kernel@lists.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s09K0fwv004516



Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

>Hi all,
>this patch series introduces stolen ticks accounting for Xen on ARM and
>ARM64.
>Stolen ticks are clocksource ticks that have been "stolen" from the cpu,
>typically because Linux is running in a virtual machine and the vcpu has
>been descheduled.
>To account for these ticks we introduce CONFIG_PARAVIRT and pv_time_ops
>so that we can make use of:
>
>kernel/sched/cputime.c:steal_account_process_tick
>
>
>Changes in v9:
>- added back missing new files from patches;
>- fix compilation on avr32 (remove patch #5, revert to previous version
>  of patch #2).
>
>
>
>Stefano Stabellini (5):
>      xen: move xen_setup_runstate_info and get_runstate_snapshot to drivers/xen/time.c
>      kernel: missing include in cputime.c
>      arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
>      arm64: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
>      xen/arm: account for stolen ticks
>
> arch/arm/Kconfig                  |   20 ++++++++
> arch/arm/include/asm/paravirt.h   |   20 ++++++++
> arch/arm/kernel/Makefile          |    2 +
> arch/arm/kernel/paravirt.c        |   25 ++++++++++
> arch/arm/xen/enlighten.c          |   21 +++++++++
> arch/arm64/Kconfig                |   20 ++++++++
> arch/arm64/include/asm/paravirt.h |   20 ++++++++
> arch/arm64/kernel/Makefile        |    1 +
> arch/arm64/kernel/paravirt.c      |   25 ++++++++++
> arch/ia64/xen/time.c              |   48 +++----------------
> arch/x86/xen/time.c               |   76 +------------------------------
> drivers/xen/Makefile              |    2 +-
> drivers/xen/time.c                |   91 +++++++++++++++++++++++++++++++++++++
> include/xen/xen-ops.h             |    5 ++
> kernel/sched/cputime.c            |    3 ++
> 15 files changed, 261 insertions(+), 118 deletions(-)
> create mode 100644 arch/arm/include/asm/paravirt.h
> create mode 100644 arch/arm/kernel/paravirt.c
> create mode 100644 arch/arm64/include/asm/paravirt.h
> create mode 100644 arch/arm64/kernel/paravirt.c
> create mode 100644 drivers/xen/time.c
>
>
>git://git.kernel.org/pub/scm/linux/kernel/git/sstabellini/xen.git lost_ticks_9
>
>
>Cheers,
>
>Stefano
>
>_______________________________________________
>Xen-devel mailing list
>Xen-devel@lists.xen.org
>http://lists.xen.org/xen-devel
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
