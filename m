Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3EOUJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:09:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36127 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab3EOUJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:09:53 -0400
Date: Wed, 15 May 2013 15:09:42 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCHv11 3/4] zswap: add to mm/
Message-ID: <20130515200942.GA17724@cerebellum>
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <15c5b1da-132a-4c9e-9f24-bc272d3865d5@default>
 <20130514163541.GC4024@medulla>
 <f0272a06-141a-4d33-9976-ee99467f3aa2@default>
 <20130514225501.GA11956@cerebellum>
 <4d74f5db-11c1-4f58-97f4-8d96bbe601ac@default>
 <20130515185506.GA23342@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515185506.GA23342@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051520-5806-0000-0000-0000212C2B6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 02:55:06PM -0400, Konrad Rzeszutek Wilk wrote:
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

zswap, the writeback code particularly, depends on a number of non-exported
kernel symbols, namely:

swapcache_free
__swap_writepage
__add_to_swap_cache
swapcache_prepare
swapper_spaces

So it can't currently be built as a module and I'm not sure what the MM
folks would think about exporting them and making them part of the KABI.

Seth

