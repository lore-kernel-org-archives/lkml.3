Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966960Ab3E2Uph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:45:37 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38487 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966734Ab3E2Upc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:45:32 -0400
Date: Wed, 29 May 2013 15:45:03 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        Heesub Shin <heesub.shin@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv12 2/4] zbud: add to mm/
Message-ID: <20130529204503.GE428@cerebellum>
References: <1369067168-12291-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1369067168-12291-3-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130528145911.bd484cbb0bb7a27c1623c520@linux-foundation.org>
 <20130529154500.GB428@cerebellum>
 <20130529113434.b2ced4cc1e66c7a0a520d908@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529113434.b2ced4cc1e66c7a0a520d908@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052920-3620-0000-0000-000002C6EDE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 11:34:34AM -0700, Andrew Morton wrote:
> > > > +	if (size <= 0 || gfp & __GFP_HIGHMEM)
> > > > +		return -EINVAL;
> > > > +	if (size > PAGE_SIZE)
> > > > +		return -E2BIG;
> > > 
> > > Means "Argument list too long" and isn't appropriate here.
> > 
> > Ok, I need a return value other than -EINVAL to convey to the user that the
> > allocation is larger than what the allocator can hold. I don't see an existing
> > errno that would be more suited for that.  Do you have a suggestion?
> 
> ENOMEM perhaps.  That's also somewhat misleading, but I guess there's
> precedent for ENOMEM meaning "allocation too large" as well as "out
> of memory".

Ah, spoke to soon. ENOMEM is already being used to indicate that an allocation
to grow the pool failed.

Seth

