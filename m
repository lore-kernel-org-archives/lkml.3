Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3CGJA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:00:27 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:60972 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab3CGJAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:00:25 -0500
Message-ID: <513856F9.1070509@huawei.com>
Date: Thu, 7 Mar 2013 16:59:37 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH Resend 0/8] sysrq: fix inconstistent help message of sysrq
 key
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(v1->v2: change the help message of sysrq key, instead of allow user trigger upper-case character)

Currently help message of /proc/sysrq-trigger highlight its
upper-case characters, like below:

      SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
      memory-full-oom-kill(F) kill-all-tasks(I) ...

this would confuse user trigger sysrq by upper-case character, which is
inconsistent with the real lower-case character registed key.

This inconsistent help message will also lead more confused when
26 upper-case letters put into use in future.

This series fix it.

Thanks the comments from Andrew and Randy.

---
 Documentation/sysrq.txt               |   20 ++++++++---------
 arch/arm/kernel/etm.c                 |    2 +-
 arch/powerpc/xmon/xmon.c              |    2 +-
 arch/sparc/kernel/process_64.c        |    4 ++--
 drivers/net/ethernet/ibm/emac/debug.c |    2 +-
 drivers/tty/sysrq.c                   |   38 ++++++++++++++++-----------------
 kernel/debug/debug_core.c             |    2 +-
 kernel/power/poweroff.c               |    2 +-
 8 files changed, 36 insertions(+), 36 deletions(-)


