Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbaFSCuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:50:24 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:52464 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbaFSCuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:50:23 -0400
Message-ID: <1403146219.5189.4.camel@marge.simpson.net>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Date: Thu, 19 Jun 2014 04:50:19 +0200
In-Reply-To: <20140619021337.GA4669@linux.vnet.ibm.com>
References: <539B594C.8070004@intel.com>
	 <20140613224519.GV4581@linux.vnet.ibm.com> <53A0CAE5.9000702@intel.com>
	 <20140618001836.GV4669@linux.vnet.ibm.com> <53A132D4.60408@intel.com>
	 <20140618125831.GB4669@linux.vnet.ibm.com> <53A1CE19.7040103@intel.com>
	 <20140618203052.GT4669@linux.vnet.ibm.com>
	 <20140618235131.GA25946@linux.vnet.ibm.com>
	 <20140619014200.GO8178@tassilo.jf.intel.com>
	 <20140619021337.GA4669@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 19:13 -0700, Paul E. McKenney wrote: 
> On Wed, Jun 18, 2014 at 06:42:00PM -0700, Andi Kleen wrote:
> > 
> > I still think it's totally the wrong direction to pollute so 
> > many fast paths with this obscure debugging check workaround
> > unconditionally.
> 
> OOM prevention should count for something, I would hope.
> 
> > cond_resched() is in EVERY sleeping lock and in EVERY memory allocation!
> > And these are really critical paths for many workloads.
> > 
> > If you really wanted to do this I think you would first need
> > to define a cond_resched_i_am_not_fast() or somesuch.
> > 
> > Or put it all behind some debugging ifdef.
> 
> My first thought was to put it behind CONFIG_NO_HZ_FULL, but everyone
> seems to be enabling that one.

Not everybody, SUSE doesn't even have it enabled in factory.

-Mike

