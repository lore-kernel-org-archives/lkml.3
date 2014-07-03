Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaGCBA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 21:00:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:56115 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaGCBA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 21:00:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,591,1400050800"; 
   d="scan'208";a="567571465"
Date: Wed, 2 Jul 2014 18:00:19 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Kees Cook <kees@outflux.net>
Cc: Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz
Subject: Re: mmotm 2014-07-02-15-07 uploaded (stack protector)
Message-ID: <20140703010019.GS19781@tassilo.jf.intel.com>
References: <53b482d3.gR7nYB/K7hPREviI%akpm@linux-foundation.org>
 <53B493E2.2030905@infradead.org>
 <20140703002231.GR19781@tassilo.jf.intel.com>
 <20140703005100.GI5412@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703005100.GI5412@outflux.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that if you make kbuild hard-fail when selecting this missing
> compiler option, you can never switch it back because "make menuconfig" will
> refuse to build since the compiler option would be missing. Being silent
> about the missing option (and/or falling back to other options) means that
> you could get two different kernel features selection with the same CONFIG_*
> set, depending on the kernel, which is extremely bad ("I selected
> stack-protector-strong but it built without it?!").

The assumption that every flag in a .config has been consciouscly 
selected by a human is a quite dubious one ...

LTO just turns itself off if the toolchain doesn't support it.

> So, the middle ground was to warn about it during the kbuild logic so
> you could find the source of the problem, but ultimately fail the build
> when the compiler doesn't support it so there weren't any silent failure
> modes.

Longer term it would be of course best to move all the cc-options
probing into Kconfig. I bet that would speed up builds too.

-Andi
