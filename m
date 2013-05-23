Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab3EWOOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:14:47 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37775 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590Ab3EWOOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:14:45 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [Resend/PATCHv5 0/3] Omap serial cleanup
References: <1368633673-32308-1-git-send-email-sourav.poddar@ti.com>
Date: Thu, 23 May 2013 07:14:41 -0700
In-Reply-To: <1368633673-32308-1-git-send-email-sourav.poddar@ti.com> (Sourav
	Poddar's message of "Wed, 15 May 2013 21:31:10 +0530")
Message-ID: <87y5b5iy0e.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sourav,

Sourav Poddar <sourav.poddar@ti.com> writes:

> Resending this patch series again on top of 3.10-rc1.
>
> This is a cleanup series done in response to the
> serial driver fixes done for "no_console_suspend" case.

Greg has queued the serial core changes for v3.11, and I've queued this
series for the OMAP specific changes for v3.11[1].

Thanks again for your persistence with this series.

Kevin

[1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm.git for_3.11/uart/no_console_suspend

> This cleanups mainly include getting
> rid of using "omap_device_disable_idle_on_suspend" api for both dt and non dt case
> as the serial driver will be self sufficient to handle the "no_idle_on_suspend" issue.
> Serial was the only one making use of "omap_device_disable_idle_on_suspend"
>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Rajendra nayak <rnayak@ti.com>
>
> Test info
> Omap4430sdp:
> - Tested wakeup from UART after suspend for dt and non dt case.
> Omap5430evm:
> - Tested wakeup from UART after suspend for dt case.
>
> These patches were the part of the bigger series[2]. Breaking them into
> two relevant series as they go through the different tree.
>
> [2]: http://lkml.org/lkml/2013/4/26/274
>
> The following changes since commit b973425cbb51e08301b34fecdfd476a44507d8cf:
>
>   Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-05-14 09:30:54 -0700)
>
> are available in the git repository at:
>
>   git://gitorious.org/linux-connectivity/linux-connectivity.git omap_fix_resend
>
> Sourav Poddar (3):
>       arm: omap2+: serial: remove no_console_suspend support
>       arm: dts: am33xx: Remove "ti,no_idle_on_suspend" property.
>       arm: omap2+: omap_device: remove no_idle_on_suspend
>
>  arch/arm/boot/dts/am33xx.dtsi     |    1 -
>  arch/arm/mach-omap2/omap_device.c |    9 ++-------
>  arch/arm/mach-omap2/omap_device.h |   10 ----------
>  arch/arm/mach-omap2/serial.c      |    7 -------
>  4 files changed, 2 insertions(+), 25 deletions(-)
