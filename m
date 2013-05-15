Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab3EOUxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:53:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49264 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab3EOUxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:53:19 -0400
MIME-Version: 1.0
Message-ID: <234e96e5-93ca-4739-a6ca-043272357c78@default>
Date: Wed, 15 May 2013 13:52:42 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
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
 <20130515200942.GA17724@cerebellum>
In-Reply-To: <20130515200942.GA17724@cerebellum>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Wednesday, May 15, 2013 2:10 PM
> To: Konrad Rzeszutek Wilk
> Cc: Dan Magenheimer; Andrew Morton; Greg Kroah-Hartman; Nitin Gupta; Minchan Kim; Robert Jennings;
> Jenifer Hopper; Mel Gorman; Johannes Weiner; Rik van Riel; Larry Woodman; Benjamin Herrenschmidt; Dave
> Hansen; Joe Perches; Joonsoo Kim; Cody P Schafer; Hugh Dickens; Paul Mackerras; linux-mm@kvack.org;
> linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org
> Subject: Re: [PATCHv11 3/4] zswap: add to mm/
> 
> On Wed, May 15, 2013 at 02:55:06PM -0400, Konrad Rzeszutek Wilk wrote:
> > > Sorry, but I don't think that's appropriate for a patch in the MM subsystem.
> >
> > I am heading to the airport shortly so this email is a bit hastily typed.
> >
> > Perhaps a compromise can be reached where this code is merged as a driver
> > not a core mm component. There is a high bar to be in the MM - it has to
> > work with many many different configurations.
> >
> > And drivers don't have such a high bar. They just need to work on a specific
> > issue and that is it. If zswap ended up in say, drivers/mm that would make
> > it more palpable I think.
> >
> > Thoughts?
> 
> zswap, the writeback code particularly, depends on a number of non-exported
> kernel symbols, namely:
> 
> swapcache_free
> __swap_writepage
> __add_to_swap_cache
> swapcache_prepare
> swapper_spaces
> 
> So it can't currently be built as a module and I'm not sure what the MM
> folks would think about exporting them and making them part of the KABI.

It can be built as a module if writeback is disabled (or ifdef'd by
a CONFIG_ZSWAP_WRITEBACK which depends on CONFIG_ZSWAP=y).  The
folks at LSFMM who were planning to use zswap will be turning
off writeback anyway so an alternate is to pull writeback out
of zswap completely for now, since you don't really have a good
policy to manage it yet anyway.
