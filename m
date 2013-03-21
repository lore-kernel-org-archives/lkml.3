Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab3CUPpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:45:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:51128 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab3CUPpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:45:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,887,1355126400"; 
   d="scan'208";a="310036042"
Message-ID: <514B2B03.4030301@linux.intel.com>
Date: Thu, 21 Mar 2013 08:45:07 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: paulmck@linux.vnet.ibm.com, Frederic Weisbecker <fweisbec@gmail.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, zhong@linux.vnet.ibm.com, khilman@linaro.org,
        geoff@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH] nohz1: Documentation
References: <CAFTL4hybMf+9GjjyKRSEEp0x+wT7OwpKShE5sR_JqW24DGfKOw@mail.gmail.com>  <1363636794.15703.32@driftwood>  <CAFTL4hz=VKCchgvKcSHbctZcRyjCSmCbLu6OhLz0zEcYA20zOQ@mail.gmail.com>  <20130318222548.GG3656@linux.vnet.ibm.com>  <1363822338.6345.33.camel@gandalf.local.home>  <20130320235545.GL3637@linux.vnet.ibm.com> <1363825631.6345.45.camel@gandalf.local.home>
In-Reply-To: <1363825631.6345.45.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/2013 5:27 PM, Steven Rostedt wrote:
> I'm not sure I would recommend idle=poll either. It would certainly
> work, but it goes to the other extreme. You think NO_HZ=n drains a
> battery? Try idle=poll.


do not ever use idle=poll on anything production.. really bad idea.

if you temporary cannot cope with the latency, you can use the PMQOS system
to limit (including going all the way to idle=poll).
but using idle=poll completely is very nasty for the hardware.

In addition we should document that idle=poll will cost you peak performance,
possibly quite a bit.

the same is true for the kernel paramter to some extend; it's there to work around
broken bioses/hardware/etc; if you have a latency/runtime requirement, it's much better
to use PMQOS for this from userspace.

