Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3KTQdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:33:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46576 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3KTQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:33:20 -0500
Date: Wed, 20 Nov 2013 17:33:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com,
        rui.zhang@intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        hpa@zytor.com
Subject: Re: [PATCH] x86, acpi, idle: Restructure the mwait idle routines
Message-ID: <20131120163313.GR10022@twins.programming.kicks-ass.net>
References: <20131119090019.GJ3866@twins.programming.kicks-ass.net>
 <20131119090859.GC3694@twins.programming.kicks-ass.net>
 <20131119113153.GD3694@twins.programming.kicks-ass.net>
 <528B7433.7020507@linux.intel.com>
 <20131119145143.GK10022@twins.programming.kicks-ass.net>
 <20131119151338.GF3694@twins.programming.kicks-ass.net>
 <20131119130630.487da962@ultegra>
 <20131120102803.GO10022@twins.programming.kicks-ass.net>
 <20131120105837.GH3694@twins.programming.kicks-ass.net>
 <528CE24F.5000604@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528CE24F.5000604@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:24:47AM -0800, Arjan van de Ven wrote:
> On 11/20/2013 2:58 AM, Peter Zijlstra wrote:
> >So pretty silly actually; you cannot do a store (any store) in between
> >monitor and mwait.
> 
> you can
> just not to the cacheline you are watching (or things that alias with that)

Ah indeed, the thread_info::status is in the same cacheline.
