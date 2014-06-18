Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaFRAPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:15:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:16690 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbaFRAPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:15:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,498,1400050800"; 
   d="scan'208";a="446770884"
Date: Tue, 17 Jun 2014 17:15:17 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618001517.GL8178@tassilo.jf.intel.com>
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A0CAE5.9000702@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It also ends up eating a new cacheline in a bunch of pretty hot paths.
> It would be nice to be able to keep the fast path part of this as at
> least read-only.
> 
> Could we do something (functionally) like the attached patch?  Instead
> of counting cond_resched() calls, we could just specify some future time
> by which we want have a quiescent state.  We could even push the time to
> be something _just_ before we would have declared a stall.

I still think it's totally the wrong place. cond_resched() is in so
many fast paths (every lock, every allocation). It just doesn't
make sense to add non essential things like this to it.

I would be rather to just revert the original patch.

-Andi
