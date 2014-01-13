Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaAMTIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:08:51 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49767 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaAMTIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:08:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,654,1384300800"; 
   d="scan'208";a="90294988"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH v2 0/2] xen/grant-table: Avoid m2p_override during mapping
Date: Mon, 13 Jan 2014 19:08:37 +0000
Message-ID: <1389640119-7936-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The grant mapping API does m2p_override unnecessarily: only gntdev needs it,
for blkback and future netback patches it just cause a lock contention, as
those pages never go to userspace. Therefore this series does the following:
- move the m2p_override part from grant_[un]map_refs to gntdev, where it is
  needed after mapping operations
- but move set_phys_to_machine from m2p_override to gnttab_[un]map_refs,
  because it is needed always
- update the function prototypes as kmap_ops are no longer needed

v2:
- move the storing of the old mfn in page->index to gnttab_map_refs
- move the function header update to a separate patch

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Suggested-by: David Vrabel <david.vrabel@citrix.com>

