Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab3CNNVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:21:08 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35629 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3CNNVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:21:05 -0400
Date: Thu, 14 Mar 2013 08:20:46 -0500
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Bob <bob.liu@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, minchan@kernel.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Bob Liu <lliubbo@gmail.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: zsmalloc limitations and related topics
Message-ID: <20130314132046.GA3172@linux.vnet.ibm.com>
Mail-Followup-To: Bob <bob.liu@oracle.com>,
	Seth Jennings <sjenning@linux.vnet.ibm.com>,
	Dan Magenheimer <dan.magenheimer@oracle.com>, minchan@kernel.org,
	Nitin Gupta <nitingupta910@gmail.com>,
	Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Bob Liu <lliubbo@gmail.com>,
	Luigi Semenzato <semenzato@google.com>,
	Mel Gorman <mgorman@suse.de>
References: <0efe9610-1aa5-4aa9-bde9-227acfa969ca@default>
 <20130313151359.GA3130@linux.vnet.ibm.com>
 <4ab899f6-208c-4d61-833c-d1e5e8b1e761@default>
 <514104D5.9020700@linux.vnet.ibm.com>
 <5141BC5D.9050005@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5141BC5D.9050005@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031413-5490-0000-0000-0000031D94BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bob (bob.liu@oracle.com) wrote:
> On 03/14/2013 06:59 AM, Seth Jennings wrote:
> >On 03/13/2013 03:02 PM, Dan Magenheimer wrote:
> >>>From: Robert Jennings [mailto:rcj@linux.vnet.ibm.com]
> >>>Subject: Re: zsmalloc limitations and related topics
> >>
<snip>
> >>Yes.  And add pageframe-reclaim to this list of things that
> >>zsmalloc should do but currently cannot do.
> >
> >The real question is why is pageframe-reclaim a requirement?  What
> >operation needs this feature?
> >
> >AFAICT, the pageframe-reclaim requirements is derived from the
> >assumption that some external control path should be able to tell
> >zswap/zcache to evacuate a page, like the shrinker interface.  But this
> >introduces a new and complex problem in designing a policy that doesn't
> >shrink the zpage pool so aggressively that it is useless.
> >
> >Unless there is another reason for this functionality I'm missing.
> >
> 
> Perhaps it's needed if the user want to enable/disable the memory
> compression feature dynamically.
> Eg, use it as a module instead of recompile the kernel or even
> reboot the system.

To unload zswap all that is needed is to perform writeback on the pages
held in the cache, this can be done by extending the existing writeback
code.

