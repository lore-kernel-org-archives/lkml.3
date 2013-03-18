Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3CRUVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:21:05 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:57771
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab3CRUVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:21:04 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/3] Drivers: hv: balloon
Date: Mon, 18 Mar 2013 13:51:13 -0700
Message-Id: <1363639873-1576-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support 2M page allocations when memory is ballooned out of the
guest. Hyper-V Dynamic Memory protocol is optimized around the ability
to move memory in 2M chunks.

I have also included a patch to properly notify the host of permanent
hot-add failures.

In this version of the patches, I have added some additional comments to the
code and the patch descriptions.

K. Y. Srinivasan (3):
  mm: Export split_page()
  Drivers: hv: balloon: Support 2M page allocations for ballooning
  Drivers: hv: Notify the host of permanent hot-add failures

 drivers/hv/hv_balloon.c |   51 +++++++++++++++++++++++++++++++++++++++++++---
 mm/page_alloc.c         |    1 +
 2 files changed, 48 insertions(+), 4 deletions(-)

-- 
1.7.4.1

