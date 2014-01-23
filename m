Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaAWCWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:22:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbaAWCWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:22:05 -0500
Date: Wed, 22 Jan 2014 21:21:47 -0500
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: David Rientjes <rientjes@google.com>, khlebnikov@openvz.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: BUG: Bad rss-counter state
Message-ID: <20140123022147.GA3221@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	David Rientjes <rientjes@google.com>, khlebnikov@openvz.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <52E06B6F.90808@oracle.com>
 <alpine.DEB.2.02.1401221735450.26172@chino.kir.corp.google.com>
 <20140123015241.GA947@redhat.com>
 <52E07B63.1070400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E07B63.1070400@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 09:16:03PM -0500, Sasha Levin wrote:
 > On 01/22/2014 08:52 PM, Dave Jones wrote:
 > > Sasha, is this the current git tree version of Trinity ?
 > > (I'm wondering if yesterdays munmap changes might be tickling this bug).
 > 
 > Ah yes, my tree has the munmap patch from yesterday, which would explain why we
 > started seeing this issue just now.

So that change is basically allowing trinity to munmap just part of a prior mmap.
So it may do things like..

mmap   |--------------|

munmap |----XXX-------|

munmap |------XXX-----|

ie, it might try unmapping some pages more than once, and may even overlap prior munmaps.

until yesterdays change, it would only munmap the entire mmap.

There's no easy way to tell exactly what happened without a trinity log of course.

	Dave

