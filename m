Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab3BSAwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 19:52:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757534Ab3BSAwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 19:52:44 -0500
Date: Mon, 18 Feb 2013 20:57:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, gleb@redhat.com,
        kvm@vger.kernel.org, peterz@infradead.org, glommer@parallels.com,
        mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 4/4] Add a timer to allow the separation of consigned
 from steal time.
Message-ID: <20130218235718.GB6166@amt.cnet>
References: <20130205214818.4615.12937.stgit@lambeau>
 <20130205214941.4615.29852.stgit@lambeau>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205214941.4615.29852.stgit@lambeau>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 03:49:41PM -0600, Michael Wolf wrote:
> Add a helper routine to scheduler/core.c to allow the kvm module
> to retrieve the cpu hardlimit settings.  The values will be used
> to set up a timer that is used to separate the consigned from the
> steal time.

1) Can you please describe, in english, the mechanics of subtracting cpu
hardlimit values from steal time reported via run_delay supposed to
work?

"The period and the quota used to separate the consigned time 
(expected steal) from the steal time are taken
from the cfs bandwidth control settings. Any other steal time
accruing during that period will show as the traditional steal time."

There is no "expected steal time" over a fixed period of real time.

2) From the description of patch 1: "In the case of where you have
a system that is running in a capped or overcommitted environment 
the user may see steal time being reported in accounting tools 
such as top or vmstat." 

This is outdated, right? Because overcommitted environment is exactly
what steal time should report.


Thanks

