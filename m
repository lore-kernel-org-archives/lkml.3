Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3FJSh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab3FJShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:37:24 -0400
Date: Mon, 10 Jun 2013 20:33:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        John Stultz <johnstul@us.ibm.com>,
        Tomas Janousek <tjanouse@redhat.com>,
        Tomas Smetana <tsmetana@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] do_sysinfo: use get_monotonic_boottime()
Message-ID: <20130610183323.GA14408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610183300.GA14379@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change do_sysinfo() to use get_monotonic_boottime() instead of
do_posix_clock_monotonic_gettime() + monotonic_to_bootbased().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/sys.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 50f8677..746575d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2343,8 +2343,7 @@ static int do_sysinfo(struct sysinfo *info)
 
 	memset(info, 0, sizeof(struct sysinfo));
 
-	ktime_get_ts(&tp);
-	monotonic_to_bootbased(&tp);
+	get_monotonic_boottime(&tp);
 	info->uptime = tp.tv_sec + (tp.tv_nsec ? 1 : 0);
 
 	get_avenrun(info->loads, 0, SI_LOAD_SHIFT - FSHIFT);
-- 
1.5.5.1

