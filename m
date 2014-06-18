Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbaFRC1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:27:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:20016 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbaFRC1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:27:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,498,1400050800"; 
   d="scan'208";a="446810162"
Date: Tue, 17 Jun 2014 19:27:31 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>,
        peterz@infradead.org
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618022731.GM8178@tassilo.jf.intel.com>
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001517.GL8178@tassilo.jf.intel.com>
 <20140618010423.GW4669@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618010423.GW4669@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK.  What would you suggest instead?  If all we do is to revert the

Hang checker should have two timer phases:

Timer fires first time:
- Save context switch counter on that. Force a reschedule to some
work queue. Rearm timer

Timer fires again:
- Check reschedule count. If the reschedule count changed
it was a real hang, otherwise ignore.

-Andi
