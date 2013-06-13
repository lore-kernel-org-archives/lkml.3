Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab3FMTHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:07:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37397 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3FMTHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:07:44 -0400
Date: Thu, 13 Jun 2013 14:06:17 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Bob Liu <bob.liu@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv13 0/4] zswap: compressed swap caching
Message-ID: <20130613190617.GB2967@medulla>
References: <1370291585-26102-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <51B9BC5E.6060407@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B9BC5E.6060407@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061319-3620-0000-0000-000003194958
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 08:34:38PM +0800, Bob Liu wrote:
> Hi Seth,
> 
> On 06/04/2013 04:33 AM, Seth Jennings wrote:
> > This is the latest version of the zswap patchset for compressed swap caching.
> > This is submitted for merging into linux-next and inclusion in v3.11.
> > 
> 
> Have you noticed that pool_pages >> stored_pages, like this:
> [root@ca-dev32 zswap]# cat *
> 0
> 424057
> 99538
> 0
> 2749448
> 0
> 24
> 60018
> 16837
> [root@ca-dev32 zswap]# cat pool_pages
> 97372
> [root@ca-dev32 zswap]# cat stored_pages
> 53701
> [root@ca-dev32 zswap]#
> 
> I think it's unreasonable to use more pool pages than stored pages!

Gah, in the moving of the zbud metadata for v13, I forgot to init the new
under_reclaim field of the zbud header.  Patch going out now.

Thanks for reporting!

Seth

