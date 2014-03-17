Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353AbaCQPAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:00:38 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:56501 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933070AbaCQPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:00:36 -0400
From: Ralph Mueck <linux-kernel@rmueck.de>
To: linux-kernel@rmueck.de
Cc: i4passt@lists.cs.fau.de, neilb@suse.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthias Oefelein <ma.oefelein@arcor.de>
Subject: [PATCH 0/2] md: Add consistency check feature for level-1 RAID
Date: Mon, 17 Mar 2014 16:00:03 +0100
Message-Id: <1395068405-13860-1-git-send-email-linux-kernel@rmueck.de>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces an online consistency check for RAID-1
md-arrays.
The feature compares each block that is read with its pendants on the
other array members to detect silent data corruption (a.k.a. bit rot).
Unfortunately, the feature is not fully-functional at this point, as we
have reached a dead end (see below).
We still want to hand in the patch for reference; maybe you can help
us, for we plan to keep on working on it.

The following issues remain:

- Partitions cannot be mounted with enabled safe read for some reason
  (We suppose something goes wrong when duplicating the bio structure)
- Broken sectors during a read result in a crash
- There may be synchronization issues

The following patches apply to the linux-next tree
(rev ed87ead565a6130174fc27a46af65169cbff7677).

Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>

-- 
1.8.3.2

