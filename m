Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbaFSBmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:42:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:47105 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756931AbaFSBmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:42:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,504,1400050800"; 
   d="scan'208";a="557695213"
Date: Wed, 18 Jun 2014 18:42:00 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619014200.GO8178@tassilo.jf.intel.com>
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001836.GV4669@linux.vnet.ibm.com>
 <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618235131.GA25946@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I still think it's totally the wrong direction to pollute so 
many fast paths with this obscure debugging check workaround
unconditionally.

cond_resched() is in EVERY sleeping lock and in EVERY memory allocation!
And these are really critical paths for many workloads.

If you really wanted to do this I think you would first need
to define a cond_resched_i_am_not_fast() or somesuch.

Or put it all behind some debugging ifdef.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
