Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbaDHO0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:26:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605AbaDHO0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:26:51 -0400
Date: Tue, 8 Apr 2014 16:26:42 +0200
From: Andres Freund <andres@2ndquadrant.com>
To: Christoph Lameter <cl@linux.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        sivanich@sgi.com
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
Message-ID: <20140408142642.GU4161@awork2.anarazel.de>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
 <5343A494.9070707@suse.cz>
 <alpine.DEB.2.10.1404080914280.8782@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404080914280.8782@nuc>
X-Provags-ID: V02:K0:oWQZg+uCGw3khjqNFVtzcZeCbforjZDOia/Ij3/TJHr
 8BL249u78BmFc37Uxz3P+TPPgViu4TpUq/5EIKayPoDxMLzhLl
 oNUBdwg0zCHhnCLGa4fVJVXs3mPodj9nk2wEoC82Exi0MaW7h4
 gXSQpwzdiITOpsjBAP03aW40lb6L24j8bC9JezXzjBfNl9JKjS
 wjl5evhVfckhGKRihw5PfxwkrFb729jZUS1Af0YoGQ6b6tVz6W
 OrTnigo9d/C4wupZWEdiLdn1DWQ6RZ9YbdCeniN77kyDnPGtbO
 4y1/7IXCdA1hHZNtmYyeIz89d6t6JSczHRHaf/FS37LfBmfRq3
 Su4dk3tke/+bsyhgtRu+s0ZRHGcd2fSp5KoYhKs21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-08 09:17:04 -0500, Christoph Lameter wrote:
> On Tue, 8 Apr 2014, Vlastimil Babka wrote:
> 
> > On 04/08/2014 12:34 AM, Mel Gorman wrote:
> > > When it was introduced, zone_reclaim_mode made sense as NUMA distances
> > > punished and workloads were generally partitioned to fit into a NUMA
> > > node. NUMA machines are now common but few of the workloads are NUMA-aware
> > > and it's routine to see major performance due to zone_reclaim_mode being
> > > disabled but relatively few can identify the problem.
> >     ^ I think you meant "enabled" here?
> >
> > Just in case the cover letter goes to the changelog...
> 
> Correct.
> 
> Another solution here would be to increase the threshhold so that
> 4 socket machines do not enable zone reclaim by default. The larger the
> NUMA system is the more memory is off node from the perspective of a
> processor and the larger the hit from remote memory.

FWIW, I've the problem hit majorly on 8 socket machines. Those are the
largest I have seen so far in postgres scenarios. Everything larger is
far less likely to be used as single node database server, so that's
possibly a sensible cutoff.
But then, I'd think that special many-socket machines are setup by
specialists, that'd know to enable if it makes sense...

Greetings,

Andres Freund

-- 
 Andres Freund	                   http://www.2ndQuadrant.com/
 PostgreSQL Development, 24x7 Support, Training & Services
