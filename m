Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab3EQRBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:01:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336Ab3EQRA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:00:59 -0400
Date: Fri, 17 May 2013 18:00:53 +0100
From: Mel Gorman <mgorman@suse.de>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>,
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
Message-ID: <20130517170053.GQ11497@suse.de>
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <51920197.9070105@oracle.com>
 <20130514160040.GB4024@medulla>
 <b9131728-5cf8-4979-a6de-ac14cc409b28@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <b9131728-5cf8-4979-a6de-ac14cc409b28@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 09:37:08AM -0700, Dan Magenheimer wrote:
> > Can I get your ack on this pending the other changes?
> 
> I'd like to hear Mel's feedback about this, but perhaps
> a compromise to allow for zswap merging would be to add
> something like the following to zswap's Kconfig comment:
> 

I think there is a lot of ugly in there and potential for weird performance
bugs. I ran out of beans complaining about different parts during the
review but fixing it out of tree or in staging like it's been happening to
date has clearly not worked out at all. As starting points go, it could be
a hell of a lot worse. I do agree that it needs a big fat warning until
some of the ugly is beaten out of it.  Requiring that it address all the
issues such as automatic pool sizing, NUMA issues, proper allocation prior
to merging will just end up with an unreviewable set of patches again so
lets just bite the bullet because at least there is a chance reviewers
can follow the incremental developments. Merging it to drivers will not
address anything IMO.

-- 
Mel Gorman
SUSE Labs
