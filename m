Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934806Ab3CZP37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:29:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:13442 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932591Ab3CZP34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:29:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="307644634"
Message-ID: <5151BEF2.9090100@linux.intel.com>
Date: Tue, 26 Mar 2013 08:29:54 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>  <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org> <1364301998.5053.17.camel@laptop>
In-Reply-To: <1364301998.5053.17.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Isn't this basically related to picking the NO_HZ cpu; if the system
> isn't fully symmetric with its power gates you want the NO_HZ cpu to be
> the 'special' cpu. If it is symmetric we really don't care which core
> is left 'running' and we can even select a new pack cpu from the idle
> cores once the old one is fully utilized.

you don't really care much sure, but there's some advantages for sorting "all the way left",
e.g. to linux cpu 0.
Some tasks only run there, and interrupts tend to be favored to that cpu as well on x86.


