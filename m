Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab3BBBuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 20:50:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3BBBuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 20:50:12 -0500
Date: Fri, 1 Feb 2013 17:49:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Michel Lespinasse <walken@google.com>, Amit Kale <akale@stec-inc.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jason Warr <jason@warr.net>, thornber@redhat.com
Subject: Re: [RFC] [DONOTAPPLY] [PATCH] enhanceio: STEC EnhanceIO SSD caching
 software for Linux kernel
Message-ID: <20130202014931.GG4761@blackbox.djwong.org>
References: <20130202004459.GA4760@blackbox.djwong.org>
 <CANN689ExTyhZBiQ-pg3jw+sA4X459qcy3kpt82n3obJ=9AVceQ@mail.gmail.com>
 <CAH+dOxLDVsrmuh2b+RVxwOd0+JOQ+LsbuRYB5zqTE7DnoA+XTA@mail.gmail.com>
 <CAH+dOxKUdxF1Ds9ogncBF1K-A979j46SqGq1rVeqii8LtgHxQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH+dOxKUdxF1Ds9ogncBF1K-A979j46SqGq1rVeqii8LtgHxQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 05:25:29PM -0800, Kent Overstreet wrote:
> Also, where's the end user documentation?

I was trying not to explode this patch's size, since the doc can go straight
into Documentation/ without as much fuss as, say, the ~1600 checkpatch
warnings and all the other comments we'll have about the source code.

> On Fri, Feb 1, 2013 at 5:23 PM, Kent Overstreet <koverstreet@google.com> wrote:
> > On Fri, Feb 1, 2013 at 4:57 PM, Michel Lespinasse <walken@google.com> wrote:
> >> On Fri, Feb 1, 2013 at 4:44 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >>> This is a patch to migrate STEC's enhanceio driver out of their github
> >>> repository and into the staging tree.  From their README:
> >>>
> >>> "EnhanceIO driver is based on EnhanceIO SSD caching software product developed
> >>> by STEC Inc. EnhanceIO was derived from Facebook's open source Flashcache
> >>> project. EnhanceIO uses SSDs as cache devices for traditional rotating hard
> >>> disk drives (referred to as source volumes throughout this document).
> >>> EnhanceIO can work with any block device, be it an entire physical disk, an
> >>> individual disk partition,  a RAIDed DAS device, a SAN volume, a device mapper
> >>> volume or a software RAID (md) device."
> >>
> >> What's your take on the benefits of this vs bcache ?
> >
> > I've been trying to review it it for cache coherency and consistency
> > wrt. power failures, but the complete lack of high level documentation
> > is making that difficult.

Agreed. :/

> > I saw some benchmarks the other day where on writes EIO was faster
> > than the raw device, which was... suspicious.

Hmm, I haven't seen /that/, but then I wasn't specifically looking for it
either.

--D
