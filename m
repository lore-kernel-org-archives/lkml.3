Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab3FMURX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 16:17:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36533 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903Ab3FMURV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 16:17:21 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 0/2] x86, mtrr: fixs for mtrr_cleanup
Date: Thu, 13 Jun 2013 13:17:00 -0700
Message-Id: <1371154622-8929-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua reported: Commit cd7b304dfaf1 (x86, range: fix missing merge
during add range) broke mtrr cleanup on his setup in 3.9.5.
corresponding commit in upstream is fbe06b7bae7c.

  *BAD*gran_size: 64K chunk_size: 16M num_reg: 6 lose cover RAM: -0G

https://bugzilla.kernel.org/show_bug.cgi?id=59491

Fix it from two places, so late mtrr cleanup side and range add side.

  x86, mtrr: Fix original mtrr range get for mtrr_cleanup
  range: Do not add new blank slot with add_range_with_merge

Please apply them for v3.10.

Thanks

Yinghai
