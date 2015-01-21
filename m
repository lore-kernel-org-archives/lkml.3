Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbbAUJJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:09:11 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:39716 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbbAUJI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:08:58 -0500
From: Li Bin <huawei.libin@huawei.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Miroslav Benes <mbenes@suse.cz>
CC: <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <guohanjun@huawei.com>,
        <zhangdianfang@huawei.com>, <xiexiuqi@huawei.com>
Subject: [PATCH 0/2] disable/enable_patch manners for interdependent patches
Date: Wed, 21 Jan 2015 17:07:40 +0800
Message-ID: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert commit 83a90bb1345767f0cb96d242fd8b9db44b2b0e17
and introduce disable/enable_patch manners for interdependent patches

for disable_patch:
The patch is unallowed to be disabled if one patch after has
dependencies with it and has been enabled.

for enable_patch:
The patch is unallowed to be enabled if one patch before has
dependencies with it and has been disabled.
Li Bin (2):
  livepatch: Revert "livepatch: enforce patch stacking semantics"
  livepatch: disable/enable_patch manners for interdependent patches

 kernel/livepatch/core.c |   66 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 58 insertions(+), 8 deletions(-)

