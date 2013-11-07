Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3KGKzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 05:55:19 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47018 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3KGKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 05:55:16 -0500
MIME-Version: 1.0
Date: Thu, 7 Nov 2013 16:25:15 +0530
Message-ID: <CAK9yfHz+H4FQpo_J0ycJP_rvRPMyDgXpZFvx+GvRjyywECUoCw@mail.gmail.com>
Subject: Boot failure on Origen with next-20131107
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today's linux next fails to boot Origen (Exynos4210) board. However,
Arndale (Exynos5250) board boots fine. Git bisect points to the
following as bad commit:

2361613206e66ce59cc0e08efa8d98ec15b84ed1 is the first bad commit
commit 2361613206e66ce59cc0e08efa8d98ec15b84ed1
Author: Grant Likely <grant.likely@linaro.org>
Date:   Sun Sep 15 22:32:39 2013 +0100

    of/irq: Refactor interrupt-map parsing

Reverting gave several conflicts which I could not resolve with certainty.

git bisect log
-------------------
git bisect start
# good: [5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52] Linux 3.12
git bisect good 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52
# bad: [48da1a29f5883ef9d14c6b828e469d86b4fc0980] Add linux-next
specific files for 20131107
git bisect bad 48da1a29f5883ef9d14c6b828e469d86b4fc0980
# good: [8af25488610c16d9eed35b5e1ecdbe649a89d429] Merge
remote-tracking branch 'l2-mtd/master'
git bisect good 8af25488610c16d9eed35b5e1ecdbe649a89d429
# bad: [0c23677988f77f927d4ad217d95ae9f7c0ad2773] Merge
remote-tracking branch 'ftrace/for-next'
git bisect bad 0c23677988f77f927d4ad217d95ae9f7c0ad2773
# good: [382a02bbc47f14e6789fb423dac9d21cf6d3e282] Merge
remote-tracking branch 'fbdev/for-next'
git bisect good 382a02bbc47f14e6789fb423dac9d21cf6d3e282
# good: [fa1471b9ac4ee9f9b92a7879a3a7ae42830d261e] Merge branch 'x86/uaccess'
git bisect good fa1471b9ac4ee9f9b92a7879a3a7ae42830d261e
# good: [af1f7e3e36fc11d7dc78173ecbfd56290ee5f91f] Merge
remote-tracking branch 'iommu/next'
git bisect good af1f7e3e36fc11d7dc78173ecbfd56290ee5f91f
# good: [f8ce25620cdce9bb71072c5480591607f8e828ac] Merge
remote-tracking branch 'spi/topic/wr' into spi-next
git bisect good f8ce25620cdce9bb71072c5480591607f8e828ac
# bad: [4251da70ee593348e23d00fb298425e882ec6404] Merge
remote-tracking branch 'devicetree/devicetree/next'
git bisect bad 4251da70ee593348e23d00fb298425e882ec6404
# good: [9175c9d2aed528800175ef81c90569d00d23f9be] audit: fix type of
sessionid in audit_set_loginuid()
git bisect good 9175c9d2aed528800175ef81c90569d00d23f9be
# good: [ebd46f016a30ad4cc766540fe89b0974a0278dba] doc: add missing
files to timers/00-INDEX
git bisect good ebd46f016a30ad4cc766540fe89b0974a0278dba
# bad: [3da5278727a895d49a601f67fd49dffa0b80f9a5] of/irq: Rework of_irq_count()
git bisect bad 3da5278727a895d49a601f67fd49dffa0b80f9a5
# good: [0c02c8007ea5554d028f99fd3e29fc201fdeeab3] of/irq: Rename
of_irq_map_* functions to of_irq_parse_*
git bisect good 0c02c8007ea5554d028f99fd3e29fc201fdeeab3
# bad: [2361613206e66ce59cc0e08efa8d98ec15b84ed1] of/irq: Refactor
interrupt-map parsing
git bisect bad 2361613206e66ce59cc0e08efa8d98ec15b84ed1
# good: [e6d30ab1e7d1281784672c0fc2ffa385cfb7279e] of/irq: simplify
args to irq_create_of_mapping
git bisect good e6d30ab1e7d1281784672c0fc2ffa385cfb7279e


-- 
With warm regards,
Sachin
