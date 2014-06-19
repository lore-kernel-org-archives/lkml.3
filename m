Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaFSCD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:03:56 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:9250 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbaFSCDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:03:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcGALVDolN5LC2v/2dsb2JhbABagw2DSKd2AQIBAQaZJwGBDhd1hAMBAQUnExwzCAMYCSUPBSUDIQESiEHNbRcWhUyJG4RDAQOaQosxiCiDVCs
Date: Thu, 19 Jun 2014 12:03:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: XFS WARN_ON in xfs_vm_writepage
Message-ID: <20140619020340.GI4453@dastard>
References: <20140613051631.GA9394@redhat.com>
 <20140613062645.GZ9508@dastard>
 <20140613141925.GA24199@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613141925.GA24199@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:19:25AM -0400, Dave Jones wrote:
> On Fri, Jun 13, 2014 at 04:26:45PM +1000, Dave Chinner wrote:
> 
> > >  970         if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
> > >  971                         PF_MEMALLOC))
> >
> > What were you running at the time? The XFS warning is there to
> > indicate that memory reclaim is doing something it shouldn't (i.e.
> > dirty page writeback from direct reclaim), so this is one for the mm
> > folk to work out...
> 
> Trinity had driven the machine deeply into swap, and the oom killer was
> kicking in pretty often. Then this happened.

Yup, sounds like a problem somewhere in mm/vmscan.c....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
