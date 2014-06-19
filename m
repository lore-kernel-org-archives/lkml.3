Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbaFSFMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:12:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:2398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbaFSFMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:12:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,505,1400050800"; 
   d="scan'208";a="447337283"
Date: Thu, 19 Jun 2014 10:43:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        jeeja.kp@intel.com, dhowells@redhat.com, tglx@linutronix.de,
        mtk.manpages@gmail.com, paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, dongxing.zhang@intel.com
Subject: Re: [PATCH] ALSA: compress: Fix the mismatch size of struc between
 share lib(32bit) and kernel(64bit)
Message-ID: <20140619051300.GF22053@intel.com>
References: <1402346792.30956.17.camel@wxm-ubuntu>
 <201406131619.32976.arnd@arndb.de>
 <20140617030636.GE22053@intel.com>
 <201406171348.59329.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201406171348.59329.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 01:48:59PM +0200, Arnd Bergmann wrote:
> On Tuesday 17 June 2014, Vinod Koul wrote:
> > > Anyway, if you use the __packed attribute, best apply it only to
> > > the individual __u64 member(s), not the entire struct, otherwise
> > > you might change user space programs in a subtle way when the alignment
> > > changes from 4 to 1 byte. 
> >
> > then wouldn't it make sense to call out the aligned as well to ensure that it is
> > aligning to what we want. Then we should add aligned (4) everywhere as mostly we
> > need 4 byte aligned here
> 
> If you want to be explicit, then just mark the entire structure as
> attribute((packed,aligned(4))), not each individual member.
Oh yes, thats the idea. I will send out and also while reviewing found that
packed was missing for few of other structs, so lets fix it now before 64bits
systems proliferate and cause havoc :)

-- 
~Vinod
