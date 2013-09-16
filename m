Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3IPImw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:42:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab3IPImv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:42:51 -0400
Date: Mon, 16 Sep 2013 11:44:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, torvalds@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why does test_bit() take a volatile addr?
Message-ID: <20130916084453.GA1222@redhat.com>
References: <87ioy11k8s.fsf@rustcorp.com.au>
 <1379320800.15916.15.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379320800.15916.15.camel@linux-fkkt.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 10:40:00AM +0200, Oliver Neukum wrote:
> On Mon, 2013-09-16 at 13:38 +0930, Rusty Russell wrote:
> > Predates git, does anyone remember the rationale?
> > 
> > ie:
> >         int test_bit(int nr, const volatile unsigned long *addr)
> > 
> > I noticed because gcc failed to elimiate some code in a patch I was
> > playing with.
> > 
> > I'm nervous about subtle bugs involved in ripping it out, even if noone
> > knows why.  Should I add __test_bit()?
> 
> It seems to me that if you do
> 
> b = *ptr & 0xf;
> c = b << 2;
> if (test_bit(1, ptr))
> 
> the compiler could optimize away the memory access on ptr without
> the volatile. We'd have to add a lot of mb().
> 
> 	Regards
> 		Oliver

What is this code supposed to do?
Any specific examples?

-- 
MST
