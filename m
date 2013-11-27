Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3K0L4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:56:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48329 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3K0L4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:56:41 -0500
Date: Wed, 27 Nov 2013 12:56:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 0/3] Hook up powerclamp with PM QOS and cpuidle
Message-ID: <20131127115634.GA10022@twins.programming.kicks-ass.net>
References: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 03:20:08PM -0800, Jacob Pan wrote:
> This patchset is intended to address the behavior change and efficiency
> loss introduced by using consolidated idle routine in powerclamp driver.
> 
> Specifically,
> [PATCH 3/8] idle, thermal, acpi: Remove home grown idle implementations
> 
> The motivation is that after using common idle routine, powerclamp driver
> can no longer pick the deepest idle state needed to conserve power.
> Idle state is selected by governors which can be influenced by PM QOS and
> other factors. This patchset hooks up powerclamp idle injection with PM
> QOS and eventually influce idle governors to pick the power saving target
> states.
> 
> There are some downside of this approach. Due to overhead, communication
> with PM QOS is at enable/disable idle injection time instead of each
> injection period. The implication is that if the system natual idle is
> more than target injected idle, powerclamp will skip some injection period.
> During this period however, deepest idle state may still be chosen
> necessarily regardless the latency constraint.

Does the QoS stuff have a means of notifying its users of constraints
violation? I suspect some applications might light to be told if their
requests aren't honoured.

