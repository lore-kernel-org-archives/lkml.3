Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaEUCn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:43:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53713 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaEUCn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:43:26 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <537C12BC.6080408@jp.fujitsu.com>
Date: Wed, 21 May 2014 11:43:08 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Yucong <slaoub@gmail.com>
CC: tony.luck@intel.com, bp@alien8.de, ak@linux.intel.com,
        ying.huang@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>	 <537C040E.3040901@jp.fujitsu.com> <1400637782.14703.32.camel@debian>
In-Reply-To: <1400637782.14703.32.camel@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/21 11:03), Chen Yucong wrote:
> On Wed, 2014-05-21 at 10:40 +0900, Hidetoshi Seto wrote:
>> (2014/05/20 11:11), Chen Yucong wrote:
>>> mces_seen is a Per-CPU variable which should only be accessed by Per-CPU as possible. So the
>>> clear operation of mces_seen should also be lcoal to Per-CPU rather than monarch CPU.
>>
>> I don't think it should be local.
>> Originally what we want to have here is memory to save mces_seen for each online cpus,
>> such as a global array like mces_seen[cpus]. But at same time we don't want to preallocate
>> big array enough for max possible cpus. So we use per-cpu store instead. 
>>
> But mces_seen will just be updated by Per-CPU rather than monarch CPU.
> It is only read by monarch CPU.

Because mce status registers are per-cpu and monarch cannot access subjects' registers
directly, all subjects read it's status for monarch, store the status to memory for monarch,
and then monarch gather all status to make decision for all.

At last monarch kindly clear gathered status for all.
It will be one of important steps to ready for next mce events.

I think you should clarify why "distributing the clear operation" is required here.
What is the benefit?


Thanks,
H.Seto

