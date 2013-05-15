Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3EOVg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:36:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33294 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3EOVgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:36:55 -0400
MIME-Version: 1.0
Message-ID: <9a2b2fe9-4694-4cee-9131-a159b58e8bf5@default>
Date: Wed, 15 May 2013 14:36:04 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: RE: [PATCHv11 3/4] zswap: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <15c5b1da-132a-4c9e-9f24-bc272d3865d5@default>
 <20130514163541.GC4024@medulla>
 <f0272a06-141a-4d33-9976-ee99467f3aa2@default>
 <20130514225501.GA11956@cerebellum>
 <4d74f5db-11c1-4f58-97f4-8d96bbe601ac@default>
 <20130515185506.GA23342@phenom.dumpdata.com>
 <57917f43-ab37-4e82-b659-522e427fda7f@default> <5193F3CC.8020205@redhat.com>
In-Reply-To: <5193F3CC.8020205@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rik van Riel [mailto:riel@redhat.com]
> Subject: Re: [PATCHv11 3/4] zswap: add to mm/
> 
> On 05/15/2013 03:35 PM, Dan Magenheimer wrote:
> >> From: Konrad Rzeszutek Wilk
> >> Subject: Re: [PATCHv11 3/4] zswap: add to mm/
> >>
> >>> Sorry, but I don't think that's appropriate for a patch in the MM subsystem.
> >>
> >> I am heading to the airport shortly so this email is a bit hastily typed.
> >>
> >> Perhaps a compromise can be reached where this code is merged as a driver
> >> not a core mm component. There is a high bar to be in the MM - it has to
> >> work with many many different configurations.
> >>
> >> And drivers don't have such a high bar. They just need to work on a specific
> >> issue and that is it. If zswap ended up in say, drivers/mm that would make
> >> it more palpable I think.
> >>
> >> Thoughts?
> >
> > Hmmm...
> >
> > To me, that sounds like a really good compromise.
> 
> Come on, we all know that is nonsense.
> 
> Sure, the zswap and zbud code may not be in their final state yet,
> but they belong in the mm/ directory, together with the cleancache
> code and all the other related bits of code.
> 
> Lets put them in their final destination, and hope the code attracts
> attention by as many MM developers as can spare the time to help
> improve it.

Hi Rik --

Seth has been hell-bent on getting SOME code into the kernel
for over a year, since he found out that enabling zcache, a staging
driver, resulted in a tainted kernel.  First it was promoting
zcache+zsmalloc out of staging.  Then it was zswap+zsmalloc without
writeback, then zswap+zsmalloc with writeback, and now zswap+zbud
with writeback but without a sane policy for writeback.  All of
that time, I've been arguing and trying to integrate compression more
deeply and sensibly into MM, rather than just enabling compression as
a toy that happens to speed up a few benchmarks.  (This,
in a nutshell, was the feedback I got at LSFMM12 from Andrea and
Mel... and I think also from you.)  Seth has resisted every
step of the way, then integrated the functionality in question,
adapted my code (or Nitin's), and called it his own.

If you disagree with any of my arguments earlier in this thread,
please say so.  Else, please reinforce that the MM subsystem
needs to dynamically adapt to a broad range of workloads,
which zswap does not (yet) do.  Zswap is not simple, it is
simplistic*.

IMHO, it may be OK for a driver to be ham-handed in its memory
use, but that's not OK for something in mm/.  So I think merging
zswap as a driver is a perfectly sensible compromise which lets
Seth get his code upstream, allows users (and leading-edge distros)
to experiment with compression, avoids these endless arguments,
and allows those who care to move forward on how to deeply
integrate compression into MM.

Dan

* simplistic, n., The tendency to oversimplify an issue or a problem
  by ignoring complexities or complications.
