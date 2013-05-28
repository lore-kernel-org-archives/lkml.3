Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823Ab3E1R3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:29:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45241 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964786Ab3E1R3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:29:45 -0400
Message-ID: <1369762185.22004.54.camel@joe-AO722>
Subject: Re: [Patch v2] skbuff: Hide GFP_ATOMIC page allocation failures for
 dropped packets
From: Joe Perches <joe@perches.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>, atomlin@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pshelar@nicira.com, mst@redhat.com, alexander.h.duyck@intel.com,
        riel@redhat.com, aquini@redhat.com, sergei.shtylyov@cogentembedded.com,
        linux-kernel@vger.kernel.org
Date: Tue, 28 May 2013 10:29:45 -0700
In-Reply-To: <51A4D4AD.2010507@candelatech.com>
References: <1369601101-23057-1-git-send-email-atomlin@redhat.com>
	 <20130527224149.GA4384@electric-eye.fr.zoreil.com>
	 <51A4D4AD.2010507@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 09:00 -0700, Ben Greear wrote:
> On 05/27/2013 03:41 PM, Francois Romieu wrote:
> > atomlin@redhat.com <atomlin@redhat.com> :
> > [...]
> >> Failed GFP_ATOMIC allocations by the network stack result in dropped
> >> packets, which will be received on a subsequent retransmit, and an
> >> unnecessary, noisy warning with a kernel backtrace.
[]
> > Please don't paper over it just because some shit ends in your backyard.
> We should rate-limit these messages at least.

Already done.
Look in mm/page_alloc:warn_alloc_failed()

void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
{
	unsigned int filter = SHOW_MEM_FILTER_NODES;

	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs) ||
	    debug_guardpage_minorder() > 0)
		return;


