Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3HTD5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:57:17 -0400
Received: from intranet.asianux.com ([58.214.24.6]:62497 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3HTD5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:57:16 -0400
X-Spam-Score: -101.1
Message-ID: <5212E8DF.5020209@asianux.com>
Date: Tue, 20 Aug 2013 11:56:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        riel@redhat.com, hughd@google.com, xemul@parallels.com,
        Cyrill Gorcunov <gorcunov@openvz.org>, rientjes@google.com,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, hughd@google.com
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] mm: mempolicy: the failure processing about mpol_to_str()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the implementation (patch 1/3), need fill buffer as full as
possible when buffer space is not enough.

For the caller (patch 2/3, 3/3), need check the return value of
mpol_to_str().

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 fs/proc/task_mmu.c |   16 ++++++++++++++--
 mm/mempolicy.c     |   14 ++++++++++----
 mm/shmem.c         |   15 ++++++++++++++-
 3 files changed, 38 insertions(+), 7 deletions(-)
