Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab3E0Tl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 15:41:56 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48382 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756763Ab3E0Tlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 15:41:55 -0400
Date: Mon, 27 May 2013 21:41:54 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: johannes.thumshirn@men.de
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] watchdog: Add sysfs interface for MEN A21 watchdog
Message-ID: <20130527194154.GE14258@spo001.leaseweb.com>
References: <20130527090756.GA14258@spo001.leaseweb.com> <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de> <1369678434-13515-2-git-send-email-johannes.thumshirn@men.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369678434-13515-2-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

> This patch adds a sysfs interface for the watchdog device found on MEN A21
> Boards.
> 
> The newly generated files are:
> * rebootcause:
> Can be one of:
> Power on Reset,
> CPU Reset Request,
> Push Button,
> FPGA Reset Request,
> Watchdog,
> Local Power Bad,
> Invalid or
> BDI
> and shows the reason of the boards last reboot.

Question: why don't you use the detection of the reboot cause in your driver
initialization so that you can:
1) report the reboot cause at the start of the driver (like we do in most
drivers that support these kind of features)
2) set the .bootstatus info in the watchdog_device struct data?
(See the WDIOF flags in #include <uapi/linux/watchdog.h>
#define	WDIOF_OVERHEAT		0x0001	/* Reset due to CPU overheat */
#define	WDIOF_FANFAULT		0x0002	/* Fan failed */
#define	WDIOF_EXTERN1		0x0004	/* External relay 1 */
#define	WDIOF_EXTERN2		0x0008	/* External relay 2 */
#define	WDIOF_POWERUNDER	0x0010	/* Power bad/power fault */
#define	WDIOF_CARDRESET		0x0020	/* Card previously reset the CPU */
#define	WDIOF_POWEROVER		0x0040	/* Power over voltage */
#define	WDIOF_SETTIMEOUT	0x0080  /* Set timeout (in seconds) */
#define	WDIOF_MAGICCLOSE	0x0100	/* Supports magic close char */
#define	WDIOF_PRETIMEOUT	0x0200  /* Pretimeout (in seconds), get/set */
#define	WDIOF_ALARMONLY		0x0400	/* Watchdog triggers a management or
					   other external alarm not a reboot */
#define	WDIOF_KEEPALIVEPING	0x8000	/* Keep alive ping reply */
(Example driver: wdt_pci.c )).

Kind regards,
Wim.

