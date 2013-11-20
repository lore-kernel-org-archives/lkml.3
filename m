Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3KTQ7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:59:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47419 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3KTQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:59:34 -0500
Date: Wed, 20 Nov 2013 17:59:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org, rjw@rjwysocki.net,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3/7] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20131120165921.GT16796@laptop.programming.kicks-ass.net>
References: <20131120160450.072555619@infradead.org>
 <20131120162736.508462614@infradead.org>
 <528CE611.8040903@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528CE611.8040903@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:40:49AM -0800, Arjan van de Ven wrote:
> On 11/20/2013 8:04 AM, Peter Zijlstra wrote:
> >This does not fully preseve existing behaviour in that the generic
> >idle cycle function calls into the normal cpuidle governed idle
> >routines and should thus respect things like QoS parameters and the
> >like.
> 
> 
> NAK on the powerclamp side.
> 
> powerclamp MUST NOT do that....
> it is needed to go to the deepest state no matter what
> (this is for when your system is overheating. there is not a lot of choice
> here... alternative is an emergency reset that the hardware does for safety)

Then its a worse broken piece of shit than I thought it was.

The only way to do what you want is to pretty much do stop_machine().

There's no guarantee your current FIFO-50 tasks will ever get to run.

Also, since when does Intel hardware do emergency resets on thermal
events? It used to force throttle stuff.
