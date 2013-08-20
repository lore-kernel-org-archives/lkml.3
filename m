Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3HTFal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:30:41 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:42861 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3HTFak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:30:40 -0400
Date: Tue, 20 Aug 2013 09:30:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        riel@redhat.com, hughd@google.com, xemul@parallels.com,
        rientjes@google.com, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] mm: mempolicy: the failure processing about
 mpol_to_str()
Message-ID: <20130820053036.GB18673@moon>
References: <5212E8DF.5020209@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5212E8DF.5020209@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:56:15AM +0800, Chen Gang wrote:
> For the implementation (patch 1/3), need fill buffer as full as
> possible when buffer space is not enough.
> 
> For the caller (patch 2/3, 3/3), need check the return value of
> mpol_to_str().
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Won't simple check for mpol_to_str() < 0 be enough? IOW fix all
callers to check that mpol_to_str exit without errors. As far
as I see here are only two users. Something like

show_numa_map
	ret = mpol_to_str();
	if (ret)
		return ret;

shmem_show_mpol
	ret = mpol_to_str();
	if (ret)
		return ret;

sure you'll have to change shmem_show_mpol statement to return int code.
Won't this be more short and convenient?
