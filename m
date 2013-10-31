Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3JaLaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:30:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab3JaLa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:30:29 -0400
Date: Thu, 31 Oct 2013 13:32:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, gleb@redhat.com
Subject: Re: [PATCH RFC] kvm: optimize out smp_mb using srcu_read_unlock
Message-ID: <20131031113259.GA8976@redhat.com>
References: <20131030190929.GA7153@redhat.com>
 <52723B87.1050609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52723B87.1050609@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 12:14:15PM +0100, Paolo Bonzini wrote:
> Il 30/10/2013 20:09, Michael S. Tsirkin ha scritto:
> > I noticed that srcu_read_lock/unlock both have a memory barrier,
> > so just by moving srcu_read_unlock earlier we can get rid of
> > one call to smp_mb().
> > 
> > Unsurprisingly, the gain is small but measureable using the unit test
> > microbenchmark:
> > before
> > 	vmcall 1407
> > after
> > 	vmcall 1357
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Across how many runs?


It's the experiment that vmexit test does:
it runs for 2^30 cycles, then divides the number of cycles by the
number of iterations.
You get in the ballpark of 1300000 iterations normally.

> Best or average or "all runs were in that
> ballpark", :) and what's the minimum/maximum before and after the patch?
> 
> As you say the benefit is not surprising, but the experiments should be
> documented properly.
> 
> Paolo

"All runs in that ballpark".

-- 
MST
