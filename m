Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3GKW1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:27:51 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:42459 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3GKW1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:27:48 -0400
Date: Thu, 11 Jul 2013 15:27:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: mempolicy: turn vma_set_policy() into
 vma_dup_policy()
In-Reply-To: <20130711152006.de0900cfcd784f2833285ee4@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1307111524400.2458@chino.kir.corp.google.com>
References: <20130710170205.GA26425@redhat.com> <alpine.DEB.2.02.1307111509000.2458@chino.kir.corp.google.com> <20130711152006.de0900cfcd784f2833285ee4@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Andrew Morton wrote:

> On Thu, 11 Jul 2013 15:13:03 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
> > > +int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
> > > +{
> > > +	struct mempolicy *pol = mpol_dup(vma_policy(src));
> > > +
> > > +	if (IS_ERR(pol))
> > > +		return PTR_ERR(pol);
> > 
> > PTR_ERR() returns long, so vma_dup_policy() needs to return long.
> 
> hm, really?  vma_dup_policy() returns an errno and errnos have type "int".
> 
> Arguably it is PTR_ERR() which returns the wrong type...
> 

PTR_ERR() may not imply IS_ERR(), which I believe Rusty is trying to fix 
with his series that fixes up abuses of PTR_ERR().  But I agree that 
vma_dup_policy() can return int because of the IS_ERR() check as written.  

For complete correctness there should probably be a build error if 
MAX_ERRNO cannot fit in an int and then this should do 
return (int)PTR_ERR(pol) to make it clear.
