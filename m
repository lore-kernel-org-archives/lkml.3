Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaCJF1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 01:27:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65204 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaCJF1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 01:27:51 -0400
X-IronPort-AV: E=Sophos;i="4.97,622,1389715200"; 
   d="scan'208";a="9669948"
Message-ID: <531D4DFA.4000809@cn.fujitsu.com>
Date: Mon, 10 Mar 2014 13:30:34 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, bcrl@kvack.org, jmoyer@redhat.com,
        kosaki.motohiro@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com
CC: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>
Subject: [V2 PATCH 0/2] Bug fix in aio ring page migration
References: <1393403919-1178-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1393403919-1178-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 13:25:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 13:25:07,
	Serialize complete at 2014/03/10 13:25:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
   aio, memory-hotplug: Fix confliction when migrating and accessing
     ring pages.
   aio, mem-hotplug: Add memory barrier to aio ring page migration.

  fs/aio.c |   42 ++++++++++++++++++++++++++++++++++++++++++
  1 files changed, 42 insertions(+), 0 deletions(-)

-- 
1.7.7
