Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaFYApR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 20:45:17 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:40716 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaFYApP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 20:45:15 -0400
Date: Tue, 24 Jun 2014 17:45:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Hunt <johunt@akamai.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Baron, Jason" <jbaron@akamai.com>
Subject: Re: [PATCH] panic: add TAINT_SOFTLOCKUP
In-Reply-To: <53A9899C.9040005@akamai.com>
Message-ID: <alpine.DEB.2.02.1406241740330.22030@chino.kir.corp.google.com>
References: <1401847955-3345-1-git-send-email-johunt@akamai.com> <20140623151121.44f17779004e94ab620b837c@linux-foundation.org> <53A8ADEC.6070406@akamai.com> <20140623155118.e2446a6110a9889454db2386@linux-foundation.org> <53A9899C.9040005@akamai.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Josh Hunt wrote:

> Anyone you'd suggest adding to this thread to get other feedback about
> tracking page allocation failures? I could also spin up a patch and cc them.
> 

Page allocation failures happen all the time, mostly because of 
large-order allocations (more than PAGE_ALLOC_COSTLY_ORDER) or allocations 
done with GFP_ATOMIC where it's impossible to reclaim or compact memory to 
allocate.  Because of this, they are fairly easy to trigger from userspace 
without having to do much.

Why would this qualify for a taint?  I have never debugged a kernel crash 
that I traced back to an earlier page allocation failure and said "oh, if 
I had only known about that page allocation failure earlier!".  If one of 
them is going to cause an issue, it probably is at the point of the crash 
and you shouldn't have to "investigate" much.
