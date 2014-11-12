Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaKLKrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:47:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50175 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaKLKrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:47:09 -0500
Message-ID: <1415789217.2876.1.camel@pengutronix.de>
Subject: Re: [PATCH] ARM: dts: tegra: move serial aliases to per-board
From: Lucas Stach <l.stach@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Olof Johansson <olof@lixom.net>, thierry.reding@gmail.com,
        gnurou@gmail.com, linux-tegra@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linux-foundation.org
Date: Wed, 12 Nov 2014 11:46:57 +0100
In-Reply-To: <54627C1F.9050200@wwwdotorg.org>
References: <1415738970-7963-1-git-send-email-olof@lixom.net>
	 <54627C1F.9050200@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 11.11.2014, 14:14 -0700 schrieb Stephen Warren:
> On 11/11/2014 01:49 PM, Olof Johansson wrote:
> > There are general changes pending to make the /aliases/serial* entries
> > number the serial ports on the system. On tegra, so far the ports have been
> > just numbered dynamically as they are configured so that makes them change.
> >
> > To avoid this, add specific aliases per board to keep the old numbers. This
> > allows us to change the numbering by default on future SoCs while keeping the
> > numbering on existing boards.
> 
> This change seems mostly OK to me. FWIW though, I had suggested this 
> approach when the UART aliases were first added, and Laxman disagreed 
> with it. See commit b6551bb933f9 "ARM: tegra: dts: add aliases and DMA 
> requestor for serial controller", and its discussion: 
> https://lkml.org/lkml/2012/12/25/4. I've CC'd Laxman in case he still 
> objects.
> 
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> > ---
> >
> > Stephen/Thierry/Alex, as noticed this week we really should try to get
> > this in before the 3.19 merge window so that the global aliases change
> > can happen there without regression.
> 
> How did we resolve the issue that patch causes with old DTs; namely that 
> it causes a change in behaviour for those old DTs? On IRC, I'd wondered 
> whether we should set a flag so the kernel ignored aliases for boards 
> containing currently upstreamed Tegra SoCs so that issue wouldn't occur. 
> If we did that, we wouldn't need this patch.
> 
I don't think this is a workable solution. With bootloaders that
understand the aliases (like Barebox) this will lead to an incoherent
behavior between kernel and bootloader.

Either we don't have any aliases at all, or we respect them in both
kernel and firmware in the same way. I think this change is the only
sane solution to not change behavior on old bootloaders, while providing
a fixed numbering for the serial ports.

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

