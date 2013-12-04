Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab3LDNAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:00:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab3LDNAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:00:43 -0500
Date: Wed, 4 Dec 2013 13:00:38 +0000
From: Mel Gorman <mgorman@suse.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mhocko@suse.cz, hannes@cmpxchg.org, riel@redhat.com,
        linux-mm@kvack.org, m.szyprowski@samsung.com, marc.ceeeee@gmail.com
Subject: Re: high kswapd CPU usage when executing binaries from NFS w/ CMA
 and COMPACTION
Message-ID: <20131204130038.GY11295@suse.de>
References: <CAGVrzcZidrUV93x9t_BwPaDuzgxs-88HoF-HUDRrSEYcfJB_rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAGVrzcZidrUV93x9t_BwPaDuzgxs-88HoF-HUDRrSEYcfJB_rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 06:30:28PM -0800, Florian Fainelli wrote:
> Hi all,
> 
> I am experiencing high kswapd CPU usage on an ARMv7 system running
> 3.8.13 when executing relatively large binaries from NFS. When this
> happens kswapd consumes around 55-60% CPU usage and the applications
> takes a huge time to load.
> 

There were a number of changes made related to how and when kswapd
stalls, particularly when pages are dirty. Brief check confirms that

git log v3.8..v3.12 --pretty=one --author "Mel Gorman" mm/vmscan.c

NFS dirty pages are problematic for compaction as dirty pages cannot be
migrated until cleaned. I'd suggest checking if current mainline suffers
the same problem and if not, focus on patches related to dirty page
handling and kswapd throttling in mm/vmscan.c as backport candidates.

-- 
Mel Gorman
SUSE Labs
