Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766AbaLDQmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:42:19 -0500
Received: from sauhun.de ([89.238.76.85]:33596 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932604AbaLDQmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:42:15 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 0/2] get rid of remaining users of attach_adapter
Date: Thu,  4 Dec 2014 17:41:51 +0100
Message-Id: <1417711313-7257-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attach_adapter mechanism of the I2C framework is deprecated for years.
There are two users left, drivers for old Macintosh computers. I recently got
the idea of replacing this mechanism with a custom one with the help of
deferred probing. Because I don't have the hardware, I worked on a seperate
branch where I modified the windtunnel driver to be runnable on my Renesas
Lager board (ARM). I first verified that the attach_adapter method was used,
then the driver rightfully failed on detecting the i2c clients. Using my custom
mechanism, the same happens: all busses get scanned, then the clients cannot be
detected. Since I didn't change the actual detection code, I assume that it
should be working on those Macintosh devices as well. The keywest driver is
only compile-tested. That being said, I'd be more than happy, if we could find
someone willing to test these patches. If they could be applied, we can
_finally_ get rid of this legacy mechanism and clean up the i2c core.

The branch I used for ARM compilation is here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/attach_adapter_removal_with_arm_compile-experimental

Thanks,

   Wolfram

Wolfram Sang (2):
  macintosh: therm_windtunnel: drop using attach adapter
  sound: ppc: keywest: drop using attach adapter

 drivers/macintosh/therm_windtunnel.c | 25 +++++++++++++++++++++++--
 sound/ppc/keywest.c                  | 21 ++++++++++++++++++---
 2 files changed, 41 insertions(+), 5 deletions(-)

-- 
2.1.3

