Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaLOLME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:12:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60267 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaLOLMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:12:00 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548EC1E2.1010101@jp.fujitsu.com>
Date: Mon, 15 Dec 2014 20:11:30 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 0/4] workqueue: fix memory allocation after numa mapping is
 changed v3
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <548C68DA.20507@jp.fujitsu.com>
In-Reply-To: <548C68DA.20507@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai-san, Tejun-san,

Thank you for review, this a fix v3. This has been tested on NUMA node hotplug
machine and seems work well.

The probelm is memory allocation failure because pool->node information can be stale
after node hotplug. This patch(1,2) tries to fix pool->node calculation.
Patch (3,4) tries to update cpumask calculation.
(Fixing memory allocation bug just requires patch 1,2. But cpumask should be update
 I think.)

Changelog since v2.
- reordered patch and split for each problem cases.
- removed unnecessary calls pointed out by Lai-san.
- restore node/cpu relationship when a new node comes online.
- handle corner case at CPU_ONLINE.

1/4 .... fix unbound workqueue's memory node affinity calculation.
2/4 ...  update percpu workqueue's memory node affinity at online/offline
3/4 ...  update workqueue's possible cpumask when a new node onlined.
4/4 ...  handle cpu-node affinity change at CPU_ONLINE.

Thanks,
-Kame

