Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3ILPVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:21:17 -0400
Received: from one.firstfloor.org ([193.170.194.197]:52829 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3ILPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:21:16 -0400
Date: Thu, 12 Sep 2013 17:21:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hwpoison: move set_migratetype_isolate() outside
 get_any_page()
Message-ID: <20130912152113.GH18242@two.firstfloor.org>
References: <1378998704-d94o0a30-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378998704-d94o0a30-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 11:11:44AM -0400, Naoya Horiguchi wrote:
> Chen Gong pointed out that set/unset_migratetype_isolate() was done in
> different functions in mm/memory-failure.c, which makes the code less
> readable/maintenable. So this patch makes it done in soft_offline_page().
> 
> With this patch, we get to hold lock_memory_hotplug() longer but it's not
> a problem because races between memory hotplug and soft offline are very rare.
> 
> This patch is against next-20130910.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Reviewed-by: Chen, Gong <gong.chen@linux.intel.com>

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
