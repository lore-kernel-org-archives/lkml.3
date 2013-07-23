Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab3GWGBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 02:01:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:28237 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3GWGBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 02:01:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="374486819"
Date: Mon, 22 Jul 2013 23:01:08 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Vince Weaver <vince@deater.net>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Message-ID: <20130723060108.GA18396@tassilo.jf.intel.com>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 01:40:40AM -0400, Vince Weaver wrote:
> On Mon, 22 Jul 2013, Andi Kleen wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Add a precise qualifier, like cpu/event=0x3c,precise=1/
> 
> So you're adding this to "events/" but not to "format/"?

Fair point, but note that precise_ip is a bitfield. Since there is no
way to express that currently the parser would need to special case it anyways.

So it could be just added as precise_ip: precise_ip in events/,
but I have some doubts that really helps anyone.

Or invent some new syntax to abstract the bitfields, but that also
would need changes.

> This will break various existing programs.

Like what?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
