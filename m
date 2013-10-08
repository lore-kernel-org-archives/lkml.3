Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab3JHPb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:31:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56740 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3JHPby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:31:54 -0400
Date: Tue, 8 Oct 2013 17:31:47 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Marc Pignat <marc.pignat@hevs.ch>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        John Stulz <john.stultz@linaro.org>, kernel@pengutronix.de,
        Ronald Wahl <ronald.wahl@raritan.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] fixes for integer rounding in timer core (Was: [PATCH v2]
 clockevents: Sanitize ticks to nsec conversion)
Message-ID: <20131008153147.GR10079@pengutronix.de>
References: <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de>
 <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <5253D9A1.1080106@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5253D9A1.1080106@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> What's the status of this patch?
I pinged Thomas about it already via irc, but I didn't get a response up
to now. It would be great to get that into 3.12. To make it easy for
Thomas, here is a pull request that includes the fix and converts
at91rm9200 back to clockevents_config_and_register dropping one of the
workarounds for the fixed bug.

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.pengutronix.de/git/ukl/linux.git tags/timer-for-tip

for you to fetch changes up to b58c4b70121070f45eefa739ecbb58d57da1c4d9:

  ARM: at91: rm9200: switch back to clockevents_config_and_register (2013-10-08 16:58:22 +0200)

----------------------------------------------------------------
The first patch in this pull request fixes an old integer rounding bug in the
timer core that was (and still is) worked around in a few arch's timer code.
The second patch drops such a work around now that the core is fixed.

----------------------------------------------------------------
Thomas Gleixner (1):
      clockevents: Sanitize ticks to nsec conversion

Uwe Kleine-König (1):
      ARM: at91: rm9200: switch back to clockevents_config_and_register

 arch/arm/mach-at91/at91rm9200_time.c |  7 ++--
 kernel/time/clockevents.c            | 65 +++++++++++++++++++++++++++---------
 2 files changed, 52 insertions(+), 20 deletions(-)

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
