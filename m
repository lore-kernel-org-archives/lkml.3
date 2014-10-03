Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbaJCX3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:29:47 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36410 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbaJCX3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:29:44 -0400
X-Originating-IP: 75.92.167.159
Date: Fri, 3 Oct 2014 16:29:21 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Matt Turner <mattst88@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?utf-8?B?6JSh5q2j6b6Z?= <zhenglong.cai@cs2c.com.cn>,
        Tejun Heo <tj@kernel.org>, Fabian Frederick <fabf@skynet.be>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Peter Foley <pefoley2@pefoley.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] init/Kconfig: Hide printk log config if CONFIG_PRINTK=n
Message-ID: <20141003232916.GA15905@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The buffers sized by CONFIG_LOG_BUF_SHIFT and
CONFIG_LOG_CPU_MAX_BUF_SHIFT do not exist if CONFIG_PRINTK=n, so don't
ask about their size at all.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Posting for review.  I can upstream this through the tiny tree.

 init/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index e84c642..31505a5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -811,6 +811,7 @@ config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
 	range 12 21
 	default 17
+	depends on PRINTK
 	help
 	  Select the minimal kernel log buffer size as a power of 2.
 	  The final size is affected by LOG_CPU_MAX_BUF_SHIFT config
@@ -830,6 +831,7 @@ config LOG_CPU_MAX_BUF_SHIFT
 	range 0 21
 	default 12 if !BASE_SMALL
 	default 0 if BASE_SMALL
+	depends on PRINTK
 	help
 	  This option allows to increase the default ring buffer size
 	  according to the number of CPUs. The value defines the contribution
-- 
2.1.1

