Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3KNJ3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:29:36 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:38847 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab3KNJ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:29:34 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, micky_ching@realsil.com.cn
Cc: linus.walleij@linaro.org
Subject: [PATCH 0/4] mfd: rtsx: Decrease driver size and add new device
Date: Thu, 14 Nov 2013 09:29:11 +0000
Message-Id: <1384421355-4434-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent added support request of yet another device, the burden
of duplicated Ops and Voltage Switch code was becoming a little messy.
To rectify is, we're creating a generic initialisation call, which in
turn uses a generic Ops structure. The individual initialisation routines
fill in the small differences in call-backs and device data after
invoking the generic call.

 drivers/mfd/rtl8411.c        | 144 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------
 drivers/mfd/rtsx_pcr.c       |   8 ++++++-
 drivers/mfd/rtsx_pcr.h       |   1 +
 include/linux/mfd/rtsx_pci.h |   1 +
 4 files changed, 81 insertions(+), 73 deletions(-)

