Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaKGRJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:09:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaKGRJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:09:39 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 0/3] Tools: hv: vssdaemon: freeze/thaw logic improvement for the failure case
Date: Fri,  7 Nov 2014 18:09:27 +0100
Message-Id: <1415380170-641-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series addresses the following issues:
- Wrong error reporting for multiple filesystems case.
- Skip all readonly-mounted filesystems instead of skipping iso9660.
- Thaw all filesystems after an unsuccessful freeze attempt.

Vitaly Kuznetsov (3):
  Tools: hv: vssdaemon: consult with errno in case of failure only
  Tools: hv: vssdaemon: skip all filesystems mounted readonly
  Tools: hv: vssdaemon: thaw everything in case of freeze failure

 tools/hv/hv_vss_daemon.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
1.9.3

