Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaFMOTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:19:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaFMOTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:19:44 -0400
Date: Fri, 13 Jun 2014 10:19:25 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: XFS WARN_ON in xfs_vm_writepage
Message-ID: <20140613141925.GA24199@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <20140613051631.GA9394@redhat.com>
 <20140613062645.GZ9508@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613062645.GZ9508@dastard>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:26:45PM +1000, Dave Chinner wrote:

> >  970         if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
> >  971                         PF_MEMALLOC))
>
> What were you running at the time? The XFS warning is there to
> indicate that memory reclaim is doing something it shouldn't (i.e.
> dirty page writeback from direct reclaim), so this is one for the mm
> folk to work out...

Trinity had driven the machine deeply into swap, and the oom killer was
kicking in pretty often. Then this happened.

	Dave

