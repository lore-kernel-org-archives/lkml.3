Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187Ab3E2Iey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:34:54 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.145]:39486 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965032Ab3E2Iew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:34:52 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-3.tower-179.messagelabs.com!1369816412!28217670!1
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 29 May 2013 10:33:33 +0200
Date: Wed, 29 May 2013 10:35:27 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Wim Van Sebroeck <wim@iguana.be>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] watchdog: Add sysfs interface for MEN A21 watchdog
Message-ID: <20130529083527.GA12478@jtlinux>
References: <20130527090756.GA14258@spo001.leaseweb.com>
 <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de>
 <1369678434-13515-2-git-send-email-johannes.thumshirn@men.de>
 <20130527194154.GE14258@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130527194154.GE14258@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 29 May 2013 08:33:31.0653 (UTC) FILETIME=[337C2350:01CE5C47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 09:41:54PM +0200, Wim Van Sebroeck wrote:
> Hi Johannes,
>
> > This patch adds a sysfs interface for the watchdog device found on MEN A21
> > Boards.
> >
> > The newly generated files are:
> > * rebootcause:
> > Can be one of:
> > Power on Reset,
> > CPU Reset Request,
> > Push Button,
> > FPGA Reset Request,
> > Watchdog,
> > Local Power Bad,
> > Invalid or
> > BDI
> > and shows the reason of the boards last reboot.
>
> Question: why don't you use the detection of the reboot cause in your driver
> initialization so that you can:
> 1) report the reboot cause at the start of the driver (like we do in most
> drivers that support these kind of features)
> 2) set the .bootstatus info in the watchdog_device struct data?
> (See the WDIOF flags in #include <uapi/linux/watchdog.h>
> #define	WDIOF_OVERHEAT		0x0001	/* Reset due to CPU overheat */
> #define	WDIOF_FANFAULT		0x0002	/* Fan failed */
> #define	WDIOF_EXTERN1		0x0004	/* External relay 1 */
> #define	WDIOF_EXTERN2		0x0008	/* External relay 2 */
> #define	WDIOF_POWERUNDER	0x0010	/* Power bad/power fault */
> #define	WDIOF_CARDRESET		0x0020	/* Card previously reset the CPU */
> #define	WDIOF_POWEROVER		0x0040	/* Power over voltage */
> #define	WDIOF_SETTIMEOUT	0x0080  /* Set timeout (in seconds) */
> #define	WDIOF_MAGICCLOSE	0x0100	/* Supports magic close char */
> #define	WDIOF_PRETIMEOUT	0x0200  /* Pretimeout (in seconds), get/set */
> #define	WDIOF_ALARMONLY		0x0400	/* Watchdog triggers a management or
> 					   other external alarm not a reboot */
> #define	WDIOF_KEEPALIVEPING	0x8000	/* Keep alive ping reply */
> (Example driver: wdt_pci.c )).
>
> Kind regards,
> Wim.
>

Ok I'll do. Should I repost this as a change of this patch or the "add driver"
patch?

Regards,
Johannes
