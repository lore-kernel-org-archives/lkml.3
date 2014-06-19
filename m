Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965666AbaFSVcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:32:10 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49572 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833AbaFSVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:32:08 -0400
Date: Thu, 19 Jun 2014 14:32:03 -0700
From: josh@joshtriplett.org
To: Christoph Lameter <cl@gentwo.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619213203.GA16747@cloud>
References: <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
 <alpine.DEB.2.11.1406190941180.2785@gentwo.org>
 <20140619180916.GE4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191531020.4002@gentwo.org>
 <20140619204220.GJ4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191612000.5484@gentwo.org>
 <alpine.DEB.2.11.1406191614270.5484@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406191614270.5484@gentwo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 04:16:34PM -0500, Christoph Lameter wrote:
> This looks very much like the CONFIG_PREEMPT problem in not so
> extreme form. Maybe we need to add another config option:
> 
> CONFIG_REALLY_REALLY_NO_PREEMPT
> 
> to get the fastest code possible and those cond_rescheds removed from the
> critical paths?
> 
> Or better
> 
> CONFIG_PREEMPT_HALF_WAY
> 
> to enable those cond_rescheds.

That much actually does seem quite reasonable: making cond_resched() do
non-trivial work ought to have a config option to disable it.
