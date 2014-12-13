Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaLMQe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 11:34:28 -0500
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:42623 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbaLMQe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 11:34:27 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Dec 2014 11:34:26 EST
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Message-ID: <548C68DA.20507@jp.fujitsu.com>
Date: Sun, 14 Dec 2014 01:27:06 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 0/4] workqueue: fix bug when numa mapping is changed v2.
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yasuaki Ishimatsu hit a allocation failure bug when the numa mapping
between CPU and node is changed. This was the last scene:
 SLUB: Unable to allocate memory on node 2 (gfp=0x80d0)
  cache: kmalloc-192, object size: 192, buffer size: 192, default order: 1, min order: 0
  node 0: slabs: 6172, objs: 259224, free: 245741
  node 1: slabs: 3261, objs: 136962, free: 127656

I and Yasuaki have a host which has a feature of node hotplug, this is a fix by me.
Tested several patterns of hotplug and I found no issue, now.
Of course I read Lai's patch and Tejun's comment. I hope I could reflect them.

1/4 ... add node-hotplug event callback.
2/4 ... add a sanity check (for debug)
3/4 ... remove per-node unbound workqueue if node goes offline.
4/4 ... update per-cpu pool's information and cpumasks, node information
        based on the latest (cpu, node) information.

Thanks,
-Kame

