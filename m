Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030565Ab3DSOO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:14:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49805 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030503Ab3DSOO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:14:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v3] irqchip: Add support for ARMv7-M's NVIC
Date: Fri, 19 Apr 2013 16:14:19 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <1366214540-31166-1-git-send-email-u.kleine-koenig@pengutronix.de> <201304181138.13599.arnd@arndb.de> <20130419135107.GD15233@pengutronix.de>
In-Reply-To: <20130419135107.GD15233@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201304191614.19821.arnd@arndb.de>
X-Provags-ID: V02:K0:FHUWdb1Sml9eXv8r6ctaNZQUmQeXsy4gJIKqoJEDmYn
 0PNsdVFG9IYtrhVrlgLJQvP+XTKhUxcU2YeIwC6e+KOpxEiylD
 h4HdhQuVZYmI+7MSKKJO9hQUKm807DyAVDqnD4JbT8bfrQWTiO
 lGOKh/0HxB6KGlqP6lXJ+dqd3AvkoXF1mDCIrTBnLJDl1tFbpw
 Rs5ixjfAXQqiPSPp2CnmVaQoXMoE9cMC3USvQW9MYpdxCx4iyZ
 VwI9uNjcf6jgCKxOvPeU7CIXweXgcKX/87+CFtLQAt/mXVn+bz
 iR1nQODGHEmNvjwpiAAoHUxxDUFp/DOSbNK1sU3sYY2W/1jFag
 fW5X+2EFHbXvp65776zg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 April 2013, Uwe Kleine-König wrote:
> On Thu, Apr 18, 2013 at 11:38:13AM +0200, Arnd Bergmann wrote:
> > On Thursday 18 April 2013, Uwe Kleine-König wrote:
> > > That is, there are (INTLINESNUM + 1) * 32 irqs for INTLINESNUM < 15. For
> > > INTLINESNUM == 15 there are only 496 and not 16 * 32 == 512. That's the
> > > same on the gic (just with bigger numbers).
> > 
> > Ok, but since you are now using a linear domain, it doesn't actually hurt
> > to register 512 in that special case, right?
> Well, it depends if allocating space for 16 unused unsigned ints hurts
> (maybe not).

As long as SPARSE_IRQ is enabled, the space won't actually be allocated.

> And it makes mapping some irqs successfull while the irq
> doesn't really exist. But probably this doesn't hurt either because the
> problem already exists.
> 
> I don't care much. Is there another advantage beside saving a few source
> lines/instructions?

It just feels strange to read the value from hardware and then override
it anyway. But I agree it's not important either way.

	Arnd
