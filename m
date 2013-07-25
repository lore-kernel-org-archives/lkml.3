Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3GYQiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:38:00 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:33918 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756541Ab3GYQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:37:54 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Ugly patches for stolen reservation
Date: Thu, 25 Jul 2013 09:37:47 -0700
Message-Id: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2/2 has the description, but suffice it to say I'm not really
pleased with this, though it does solve a problem we have.  On some
machines, we get MMIO space allocated on top of this hidden memory,
which can cause problems.  I'm not sure if there are similar problems
for other hunks of the address space; if so it's possible this could be
made more general (though the bits for looking up the address of this
region are definitely Intel graphics specific).

Chris has some patches on top to add a new E820 type so we can look up
the region later, which removes some redundant code in the i915 driver
at least.

Any comments?  I assume no one likes this, but maybe it's just another
early quirk we'll have to live with...

Thanks,
Jesse

