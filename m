Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbaFSOmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:42:22 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:50372
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624AbaFSOmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:42:21 -0400
Date: Thu, 19 Jun 2014 09:42:18 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andi Kleen <ak@linux.intel.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
In-Reply-To: <20140619014200.GO8178@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1406190941180.2785@gentwo.org>
References: <539B594C.8070004@intel.com> <20140613224519.GV4581@linux.vnet.ibm.com> <53A0CAE5.9000702@intel.com> <20140618001836.GV4669@linux.vnet.ibm.com> <53A132D4.60408@intel.com> <20140618125831.GB4669@linux.vnet.ibm.com> <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com> <20140618235131.GA25946@linux.vnet.ibm.com> <20140619014200.GO8178@tassilo.jf.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Andi Kleen wrote:

> I still think it's totally the wrong direction to pollute so
> many fast paths with this obscure debugging check workaround
> unconditionally.
>
> cond_resched() is in EVERY sleeping lock and in EVERY memory allocation!
> And these are really critical paths for many workloads.
>
> If you really wanted to do this I think you would first need
> to define a cond_resched_i_am_not_fast() or somesuch.
>
> Or put it all behind some debugging ifdef.

Again I am fully on Andi's side here. Please remove these frequent calls
to cond_resched. If one wants a fully preemptable kernel then please use
CONFIG_PREEMPT.

