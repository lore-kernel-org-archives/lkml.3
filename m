Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaFSCNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:13:44 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59452 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaFSCNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:13:43 -0400
Date: Wed, 18 Jun 2014 19:13:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619021337.GA4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001836.GV4669@linux.vnet.ibm.com>
 <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619014200.GO8178@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061902-7164-0000-0000-0000028979C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 06:42:00PM -0700, Andi Kleen wrote:
> 
> I still think it's totally the wrong direction to pollute so 
> many fast paths with this obscure debugging check workaround
> unconditionally.

OOM prevention should count for something, I would hope.

> cond_resched() is in EVERY sleeping lock and in EVERY memory allocation!
> And these are really critical paths for many workloads.
> 
> If you really wanted to do this I think you would first need
> to define a cond_resched_i_am_not_fast() or somesuch.
> 
> Or put it all behind some debugging ifdef.

My first thought was to put it behind CONFIG_NO_HZ_FULL, but everyone
seems to be enabling that one.

As mentioned earlier, I could potentially push the check behind
the need-resched check, which would get it off of the common case
of the code paths you call out above.

							Thanx, Paul

