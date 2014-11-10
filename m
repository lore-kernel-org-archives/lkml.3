Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaKJQhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:37:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaKJQhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:37:13 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 0/2] Tools: hv: vssdaemon: freeze/thaw logic improvement for the failure case
Date: Mon, 10 Nov 2014 17:37:00 +0100
Message-Id: <1415637422-27880-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series addresses the following issues:
- Verbosely report errors during freeze (mountpoint, exact error);
- Skip all readonly-mounted filesystems instead of skipping iso9660 only.

Changes since v1:
- Rebase on top of 'char-misc-next';
- "Tools: hv: vssdaemon: thaw everything in case of freeze" was thrown away as Dexuan's 
  "Tools: hv: vssdaemon: ignore the EBUSY on multiple freezing the same partition" contains
  the same change;
- "Tools: hv: vssdaemon: consult with errno in case of failure only" was replaced with
  "Tools: hv: vssdaemon: report freeze errors".

Vitaly Kuznetsov (2):
  Tools: hv: vssdaemon: report freeze errors
  Tools: hv: vssdaemon: skip all filesystems mounted readonly

 tools/hv/hv_vss_daemon.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

-- 
1.9.3

