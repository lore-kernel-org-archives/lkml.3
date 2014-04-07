Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaDGXQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 19:16:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:19445 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771AbaDGXQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 19:16:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,813,1389772800"; 
   d="scan'208";a="508710477"
Date: Mon, 7 Apr 2014 13:59:25 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140407205925.GX32556@tassilo.jf.intel.com>
References: <20140407201919.GA15838@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407201919.GA15838@sepie.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 10:19:19PM +0200, Michal Marek wrote:
> Hi Linus,
> 
> besides the kbuild branch, here is the LTO build support by Andi. It is
> a separate branch, because it depends on other patches by Andi which
> were merged through other trees. The link-time-optimization build is an
> experimental feature, so there one kconfig option to enable it and
> another kconfig option to disable it (behind a door with a sign "Beware
> of the Leopard"...), so that it is not enabled by
> allmodconfig/allyesconfig.

Thanks Michal,

I should add this version builds quite a bit slower than other LTO trees,
because the single pass kallsyms didn't quite make it, so the Link
Time Optimization is re-done 2-3 times if KALLSYMS is enabled. That 
will be hopefully fixed next cycle.

LTO will always be somewhat slower than a normal build, but right now 
it's a lot slower because of this, depending on the size of the vmlinux.

-Andi
