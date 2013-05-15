Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3EOTie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:38:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51956 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3EOTid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:38:33 -0400
MIME-Version: 1.0
Message-ID: <57917f43-ab37-4e82-b659-522e427fda7f@default>
Date: Wed, 15 May 2013 12:35:58 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
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
In-Reply-To: <20130515185506.GA23342@phenom.dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Subject: Re: [PATCHv11 3/4] zswap: add to mm/
> 
> > Sorry, but I don't think that's appropriate for a patch in the MM subsystem.
> 
> I am heading to the airport shortly so this email is a bit hastily typed.
> 
> Perhaps a compromise can be reached where this code is merged as a driver
> not a core mm component. There is a high bar to be in the MM - it has to
> work with many many different configurations.
> 
> And drivers don't have such a high bar. They just need to work on a specific
> issue and that is it. If zswap ended up in say, drivers/mm that would make
> it more palpable I think.
> 
> Thoughts?

Hmmm...

To me, that sounds like a really good compromise.  Then anyone
who wants to experiment with compressed swap pages can do so by
enabling the zswap driver.  And the harder problem of deeply integrating
compression into the MM subsystem can proceed in parallel
by leveraging and building on the best of zswap and zcache
and zram.

Seth, if you want to re-post zswap as a driver... even a
previous zswap version with zsmalloc and without writeback...
I would be willing to ack it.  If I correctly understand
Mel's concerns, I suspect he might feel the same.
