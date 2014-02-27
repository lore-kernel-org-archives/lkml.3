Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaB0KiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:38:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55710 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbaB0KiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:38:15 -0500
X-IronPort-AV: E=Sophos;i="4.97,553,1389715200"; 
   d="scan'208";a="9615208"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, bcrl@kvack.org, jmoyer@redhat.com,
        kosaki.motohiro@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Bug fix in aio ring page migration.
Date: Thu, 27 Feb 2014 18:40:14 +0800
Message-Id: <1393497616-16428-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 18:35:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 18:35:03,
	Serialize complete at 2014/02/27 18:35:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set fixes the following two problems:

1. Need to use ctx->completion_lock to protect ring pages 
   from being mis-written while migration.

2. Need memory barrier to ensure memory copy is done before 
   ctx->ring_pages[] is updated.

NOTE: AIO ring page migration was implemented since Linux 3.12.
      So we need to merge these two patches into 3.12 stable tree.  


Tang Chen (2):
  aio, memory-hotplug: Fix confliction when migrating and accessing ring
    pages.
  aio, mem-hotplug: Add memory barrier to aio ring page migration.

 fs/aio.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

-- 
1.8.3.1

