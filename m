Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab3LJAfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:35:24 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48126 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3LJAfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:35:22 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH 0/2] clockevents
Date: Mon,  9 Dec 2013 16:34:44 -0800
Message-Id: <1386635686-15686-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <alpine.DEB.2.02.1312071151340.30673@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1312071151340.30673@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

before respinning the complete series, I thought we could take a look at
the changes to the timer core, since I expect them to need to be refined
for an actual submission.

The first patch is the patch you proposed to serialize callers of
clockevents_update_freq(). I guess you may find some better words to
describe your changes. I found it not that easy to find a nice
description for somebody else's patch.

The second patch is my shot at extending clockevents_update_freq()
to also handle timers in periodic mode. In my approach I assume that
simply calling the timer's 'set_mode()' API takes care of programming an
appropriate interval based on the current timer frequency. If that
doesn't work for all timers, I guess it would require a new API call. Or
I just missed some other way.

	Thanks,
	Sören

Soren Brinkmann (2):
  time: Serialize calls to 'clockevents_update_freq' in the timing core
  time: clockevents: Adjust timer interval when frequency changes

 kernel/time/clockevents.c    | 32 +++++++++++++++++++++++++-------
 kernel/time/tick-broadcast.c | 25 +++++++++++++++++++------
 kernel/time/tick-internal.h  |  4 ++++
 3 files changed, 48 insertions(+), 13 deletions(-)

-- 
1.8.5.1

