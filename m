Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaEUCEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:04:40 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43376 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaEUCEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:04:39 -0400
Message-ID: <1400637782.14703.32.camel@debian>
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
From: Chen Yucong <slaoub@gmail.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: tony.luck@intel.com, bp@alien8.de, ak@linux.intel.com,
        ying.huang@intel.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org
Date: Wed, 21 May 2014 10:03:02 +0800
In-Reply-To: <537C040E.3040901@jp.fujitsu.com>
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
	 <537C040E.3040901@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 10:40 +0900, Hidetoshi Seto wrote:
> (2014/05/20 11:11), Chen Yucong wrote:
> > mces_seen is a Per-CPU variable which should only be accessed by Per-CPU as possible. So the
> > clear operation of mces_seen should also be lcoal to Per-CPU rather than monarch CPU.
> 
> I don't think it should be local.
> Originally what we want to have here is memory to save mces_seen for each online cpus,
> such as a global array like mces_seen[cpus]. But at same time we don't want to preallocate
> big array enough for max possible cpus. So we use per-cpu store instead. 
> 
But mces_seen will just be updated by Per-CPU rather than monarch CPU.
It is only read by monarch CPU.
> > 
> > Meanwhile, there is also a potential risk that mces_seen will not be be cleared if a timeout
> > occors in mce_end for monarch CPU. As a reuslt, the stale value of mces_seen will reappear
> > on the next mce.
> 
> In case if we decide panic in mce path, uncleared mces_seen can be referred from memory dump.
> I suppose it will help trouble investigation.
> 
> > 
> > Based on the above reasons, this patch distirbute the clear operation of mces_seen to Per-CPU
> > rather than only monarch CPU.
> 
> "local" "occurs" "result" "distribute"
> I recommend you to use spell-checker for your postings...
Thanks very much for your suggestion, I will use a spell-cheker for my
carelessness. 

thx!
cyc

