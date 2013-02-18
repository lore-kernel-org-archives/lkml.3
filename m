Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab3BRUCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:02:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24651 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3BRUCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:02:17 -0500
MIME-Version: 1.0
Message-ID: <0fb2af92-575f-4f5d-a115-829a3cf035e5@default>
Date: Mon, 18 Feb 2013 11:55:50 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Ric Mason <ric.masonn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: RE: [PATCHv5 4/8] zswap: add to mm/
References: <1360780731-11708-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1360780731-11708-5-git-send-email-sjenning@linux.vnet.ibm.com>
 <511F0536.5030802@gmail.com> <51227FDA.7040000@linux.vnet.ibm.com>
In-Reply-To: <51227FDA.7040000@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCHv5 4/8] zswap: add to mm/
> 
> On 02/15/2013 10:04 PM, Ric Mason wrote:
> > On 02/14/2013 02:38 AM, Seth Jennings wrote:
> <snip>
> >> + * The statistics below are not protected from concurrent access for
> >> + * performance reasons so they may not be a 100% accurate.  However,
> >> + * the do provide useful information on roughly how many times a
> >
> > s/the/they
> 
> Ah yes, thanks :)
> 
> >
> >> + * certain event is occurring.
> >> +*/
> >> +static u64 zswap_pool_limit_hit;
> >> +static u64 zswap_reject_compress_poor;
> >> +static u64 zswap_reject_zsmalloc_fail;
> >> +static u64 zswap_reject_kmemcache_fail;
> >> +static u64 zswap_duplicate_entry;
> >> +
> >> +/*********************************
> >> +* tunables
> >> +**********************************/
> >> +/* Enable/disable zswap (disabled by default, fixed at boot for
> >> now) */
> >> +static bool zswap_enabled;
> >> +module_param_named(enabled, zswap_enabled, bool, 0);
> >
> > please document in Documentation/kernel-parameters.txt.
> 
> Will do.

Is that a good idea?  Konrad's frontswap/cleancache patches
to fix frontswap/cleancache initialization so that backends
can be built/loaded as modules may be merged for 3.9.
AFAIK, module parameters are not included in kernel-parameters.txt.

Dan
