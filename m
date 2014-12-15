Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaLOHYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:24:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49513 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaLOHXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:23:55 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 15 Dec 2014 16:28:05 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [LKP] [mm] INFO: rcu_sched detected stalls on CPUs/tasks: { 1}
 (detected by 0, t=10002 jiffies, g=945, c=944, q=0)
Message-ID: <20141215072804.GA4898@js1304-P5Q-DELUXE>
References: <1418284830.5745.72.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418284830.5745.72.camel@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 04:00:30PM +0800, Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master
> commit 6a7d22008b2294f1dacbc77632a26f2142f2d4b0 ("mm: Fix boot crash with f7426b983a6a ("mm: cma: adjust address limit to avoid hitting low/high memory boundary")")
> 
> The original boot failures are fixed, but there are some boot hang now.
> Sometimes because of OOM for trinity test.

CCing relevant people.

Hmm... My fix is just work-around to avoid validation when VA to PA
conversion. So, it would be irrelevant to this problem. Blaming
original patch makes more sense to me.

Anyway, I looked at the original commit f7426b983a6a and found that
it doesn't have any effect after reserving CMA region. Attached dmesg
say that reservation is successful. So I wonder what cause this stall.
Could you share your config to help debug?

And, dmesg log also say that 16 MB is reserved for CMA. Is there any
possibility this memory reservation cause this stall? Possibly, your
OOM report is related to this reservation.

Thanks.

