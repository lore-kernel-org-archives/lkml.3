Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965956Ab3FTTqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:46:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965319Ab3FTTqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:46:53 -0400
Message-ID: <1371757608.30572.18.camel@ul30vt.home>
Subject: Re: [PATCH] amd_iommu: Fix leak in free_pagetable()
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 13:46:48 -0600
In-Reply-To: <20130620192638.GD11309@8bytes.org>
References: <20130618014459.20440.73844.stgit@bling.home>
	 <20130618015116.20711.90269.stgit@bling.home>
	 <20130620182808.GC11309@8bytes.org> <1371755280.30572.4.camel@ul30vt.home>
	 <20130620192638.GD11309@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 21:26 +0200, Joerg Roedel wrote:
> On Thu, Jun 20, 2013 at 01:08:00PM -0600, Alex Williamson wrote:
> > On Thu, 2013-06-20 at 20:28 +0200, Joerg Roedel wrote:
> > > Hmm, actually a recursive version would make more sense here. But since
> > > recursion is a bad idea in the kernel, how about this approach instead:
> > 
> > It's a fixed maximum depth of recursion though, is it really that taboo?
> 
> Well, a recursive version would be better here because it has lower icache
> impact than my patch. But the risk is if there is a bug in recursive
> code and it goes on forever it will overwrite random kernel memory, with
> undefined, potentially very bad, results (like data corruption, killed
> filesystems and so on).
> 
> So in my opinion it is better to not take that risk whenever possible.

But that's true of a bug in any kernel code.  I think the only danger
unique to recursion is using too much stack space, but I doubt that's
really an issue for a tiny function with a fixed depth like this.  In
case you didn't notice, I did send a recursive version along with the
flat version, but I stupidly used the same subject for both.  It's a
little less code and a tiny bit easier to understand than the macro
version.  Up to you though.  Thanks,

Alex

> > > The IOMMU pagetables can have up to 3 levels, but the code
> > 
> > s/3/6/
> 
> Right, thanks.
> 
> > Seems like it should do the right thing
> 
> Ok, I also gave it some testing (started a vm, assigned and de-assigned
> a device), so it should work as expected.
> 
> > Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Thanks,
> 
> 	Joerg
> 
> 



