Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbaGTVRd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:17:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:22160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbaGTVRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,697,1400050800"; 
   d="scan'208";a="576165490"
Date: Sun, 20 Jul 2014 14:17:30 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Kbuild: Add a option to enable dwarf4
Message-ID: <20140720211729.GP5803@tassilo.jf.intel.com>
References: <1405466172-17055-1-git-send-email-andi@firstfloor.org>
 <1405466172-17055-2-git-send-email-andi@firstfloor.org>
 <20140720192315.GA4679@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140720192315.GA4679@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2014 at 09:23:15PM +0200, Sam Ravnborg wrote:
> On Wed, Jul 16, 2014 at 01:16:12AM +0200, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > I found that a lot of unresolvable variables when using gdb on the kernel
> > become resolvable when dwarf4 is enabled. So add a Kconfig flag to enable it.
> > 
> > It definitely increases the debug information size, but on the other
> > hand this isn't so bad when debug fusion is used.
> 
> Would it not make sense to try to enable degug info like this:
> First try -gdwarf-4
> If this fails try -gdwarf-3
> If this fails try -gdwarf-2
> And if this also fails fallback to -g
> 
> We could then us a Kconfig option to enable the highest debug level - where 4 for now is the highest.
> On the other hand if most people have revent utils then they all have -gdwarf-4 supported
> and then it is no big deal.

I made it a separate option, because dwarf4 is somewhat bigger than dwarf3 and it's
probably only useful for people actively using gdb/crash
(and I don't think others users like systemtap/perf probe do dwarf4 yet)

If debug fusion was default it would be fine, but right now it would
need converting a lot of debuginfo packaing scripts first.

-Andi
