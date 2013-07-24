Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3GXVPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:15:11 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:59624
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab3GXVPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:15:09 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com, dave@sr71.net
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: hv: balloon: Online memory segments "in context" 
Date: Wed, 24 Jul 2013 14:29:15 -0700
Message-Id: <1374701355-30799-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code depends on user level code to bring online memory
segments that have been hot added. Change this code to online memory
in the same context that is hot adding the memory.

This patch set implements the necessary infrastructure for making
it possible to online memory segments from within a driver.

K. Y. Srinivasan (2):
  Drivers: base: memory: Export functionality for "in kernel" onlining
    of memory
  Drivers: hv: balloon: Online the hot-added memory "in context"

 drivers/base/memory.c   |   35 +++++++++++++++++++++++++++++++++++
 drivers/hv/hv_balloon.c |   20 +++-----------------
 include/linux/memory.h  |    5 +++++
 3 files changed, 43 insertions(+), 17 deletions(-)

-- 
1.7.4.1

