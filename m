Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934820Ab3E1Q3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:29:41 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50356 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934660Ab3E1Q3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:29:39 -0400
Message-ID: <1369758577.3301.543.camel@edumazet-glaptop>
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: Ben Greear <greearb@candelatech.com>,
        Francois Romieu <romieu@fr.zoreil.com>, atomlin@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pshelar@nicira.com, mst@redhat.com, alexander.h.duyck@intel.com,
        riel@redhat.com, sergei.shtylyov@cogentembedded.com,
        linux-kernel@vger.kernel.org
Date: Tue, 28 May 2013 09:29:37 -0700
In-Reply-To: <20130528161518.GC11614@optiplex.redhat.com>
References: <1369601101-23057-1-git-send-email-atomlin@redhat.com>
	 <20130527224149.GA4384@electric-eye.fr.zoreil.com>
	 <51A4D4AD.2010507@candelatech.com>
	 <20130528161518.GC11614@optiplex.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 13:15 -0300, Rafael Aquini wrote:

> The real problem seems to be that more and more the network stack (drivers, perhaps)
> is relying on chunks of contiguous page-blocks without a fallback mechanism to
> order-0 page allocations. When memory gets fragmented, these alloc failures
> start to pop up more often and they scare ordinary sysadmins out of their paints.
> 

Where do you see that ?

I see exactly the opposite trend. 

We have less and less buggy drivers, and we want to catch last
offenders.

> The big point of this change was to attempt to relief some of these warnings 
> which we believed as being useless, since the net stack would recover from it
> by re-transmissions.
> We might have misjudged the scenario, though. Perhaps a better approach would be
> making the warning less verbose for all page-alloc failures. We could, perhaps,
> only print a stack-dump out, if some debug flag is passed along, either as
> reference, or by some CONFIG_DEBUG_ preprocessor directive.


warn_alloc_failed() uses the standard DEFAULT_RATELIMIT_INTERVAL which
is very small (5 * HZ)

I would bump nopage_rs to somethin more reasonable, like one hour or one
day.




