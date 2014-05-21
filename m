Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaEUBt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 21:49:26 -0400
Received: from fgwmail4.fujitsu.co.jp ([164.71.1.141]:40677 "EHLO
	fgwmail4.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaEUBtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 21:49:24 -0400
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2014 21:49:23 EDT
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <537C040E.3040901@jp.fujitsu.com>
Date: Wed, 21 May 2014 10:40:30 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Yucong <slaoub@gmail.com>, tony.luck@intel.com
CC: bp@alien8.de, ak@linux.intel.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
In-Reply-To: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/20 11:11), Chen Yucong wrote:
> mces_seen is a Per-CPU variable which should only be accessed by Per-CPU as possible. So the
> clear operation of mces_seen should also be lcoal to Per-CPU rather than monarch CPU.

I don't think it should be local.
Originally what we want to have here is memory to save mces_seen for each online cpus,
such as a global array like mces_seen[cpus]. But at same time we don't want to preallocate
big array enough for max possible cpus. So we use per-cpu store instead. 

> 
> Meanwhile, there is also a potential risk that mces_seen will not be be cleared if a timeout
> occors in mce_end for monarch CPU. As a reuslt, the stale value of mces_seen will reappear
> on the next mce.

In case if we decide panic in mce path, uncleared mces_seen can be referred from memory dump.
I suppose it will help trouble investigation.

> 
> Based on the above reasons, this patch distirbute the clear operation of mces_seen to Per-CPU
> rather than only monarch CPU.

"local" "occurs" "result" "distribute"
I recommend you to use spell-checker for your postings...


Thanks,
H.Seto

