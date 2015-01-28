Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763010AbbA1F35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:29:57 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:50910 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610AbbA1F3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:29:54 -0500
From: HuKeping <hukeping@huawei.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <matt.fleming@intel.com>,
        <cbouatmailru@gmail.com>, <ccross@android.com>,
        <keescook@chromium.org>, <tony.luck@intel.com>,
        <stable@vger.kernel.org>, <sdu.liu@huawei.com>, <wangnan0@huawei.com>,
        <peifeiyue@huawei.com>
Subject: [PATCH v2 0/2][request for stable inclusion] several pstore related bugfixs
Date: Wed, 28 Jan 2015 13:23:39 +0800
Message-ID: <1422422621-5003-1-git-send-email-hukeping@huawei.com>
X-Mailer: git-send-email 1.8.5.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.54C873CB.0163,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: b2a3d5fe6725a25d78dd0fffa5a37e3d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi greg,
We want to use pstore on linux 3.10. But we found several bugfixs have not
been merged yet. Most of them are obvious and can be cherry-picked cleanly.
Would you please apply them to stable 3.10?

Change from v1:
 - remove d4bf205da618bbd0b038e404d646f14e76915718 which has already been merged
 - adjust 0405a5cec3406f19e69da07c8111a6bf1088ac29

PART 1: patches that can be cleanly applied:

 bf2883339a33b7544b92ea465b90c3de55082032
 pstore: Fail to unlink if a driver has not defined pstore_erase
 
 c39524e6744284452ef45480d3153bec28960c32
 pstore: d_alloc_name() doesn't return an ERR_PTR
 
 57fd835385a043577457a385f28c08be693991bf
 pstore: clarify clearing of _read_cnt in ramoops_context
 
 aa9a4a1edfbd3d223af01db833da2f07850bc655
 pstore: skip zero size persistent ram buffer in traverse
 
 b0aa931fb84431394d995472d0af2a6c2b61064d
 pstore: Fix NULL pointer fault if get NULL prz in ramoops_get_next_prz
 
PART 2: pathes that should be adjusted:

 Rob Herring (1):
  pstore/ram: avoid atomic accesses for ioremapped regions

 fs/pstore/ram_core.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

 Madper Xie (1):
  efi-pstore: Make efi-pstore return a unique id

 drivers/firmware/efi/efi-pstore.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

-- 
1.8.5.5

