Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaCXNdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:33:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:9500 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbaCXNda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:33:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,720,1389772800"; 
   d="scan'208";a="478814608"
Date: Mon, 24 Mar 2014 09:31:54 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Keith Busch <keith.busch@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v2] NVMe: silence GCC warning on 32 bit
Message-ID: <20140324133154.GD5777@linux.intel.com>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
 <1392934261.15264.22.camel@x220>
 <alpine.LRH.2.03.1402210921010.4656@AMR>
 <1393925767.3038.23.camel@x220>
 <20140324131104.GC5777@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140324131104.GC5777@linux.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 09:11:04AM -0400, Matthew Wilcox wrote:
> On Tue, Mar 04, 2014 at 10:36:07AM +0100, Paul Bolle wrote:
> > Also note that it's actually not clear to me why these warnings only
> > trigger on 32 bit. I guess there's some int/long conversion lurking
> > somewhere. I haven't found it. 
> 
> I bet you're using a different revision of the compiler on 32 and 64 bit.
> Different gcc revisions have different abilities to track initialisation.

I should try things myself before opening my big mouth.  Weird.  Using
gcc-4.8, I see the same thing.  Guess I should just apply the patch,
though it feels wrong to be initialising an entire struct just to silence
a bogus compiler warning :-(
