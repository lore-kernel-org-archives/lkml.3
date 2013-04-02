Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3DBLPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:15:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760990Ab3DBLPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:15:10 -0400
Date: Tue, 2 Apr 2013 12:15:05 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>, Linux-MM <linux-mm@kvack.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd
 reclaims at each priority
Message-ID: <20130402111505.GF32241@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-2-git-send-email-mgorman@suse.de>
 <20130325090758.GO2154@dhcp22.suse.cz>
 <51501545.50908@suse.cz>
 <5154C4B6.102@suse.cz>
 <20130329082257.GB21227@dhcp22.suse.cz>
 <51576207.4090607@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <51576207.4090607@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 30, 2013 at 11:07:03PM +0100, Jiri Slaby wrote:
> On 03/29/2013 09:22 AM, Michal Hocko wrote:
> > On Thu 28-03-13 23:31:18, Jiri Slaby wrote:
> >> On 03/25/2013 10:13 AM, Jiri Slaby wrote:
> >>> BTW I very pray this will fix also the issue I have when I run ltp tests
> >>> (highly I/O intensive, esp. `growfiles') in a VM while playing a movie
> >>> on the host resulting in a stuttered playback ;).
> >>
> >> No, this is still terrible. I was now updating a kernel in a VM and had
> >> problems to even move with cursor.
> > 
> > :/
> > 
> >> There was still 1.2G used by I/O cache.
> > 
> > Could you collect /proc/zoneinfo and /proc/vmstat (say in 1 or 2s
> > intervals)?
> 
> Sure:
> http://www.fi.muni.cz/~xslaby/sklad/zoneinfos.tar.xz
> 

There is no vmstat snapshots so we cannot see reclaim activity. However,
based on the zoneinfo I suspect there is little. The anon and file pages
are growing, there is no nr_vmscan_write or nr_vmscan_immediate_reclaim
activity. nr_islated_* occasionally has a few entries so there is some
reclaim activity but I'm not sure there is enough for this series to
make a difference.

nr_writeback is high during the window you record so there is IO
activity but I wonder if the source of the stalls in this case are an
IO change in the 3.9-rc window or a scheduler change.

There still is a reclaim-related problem but in this particular case I
think you might be triggering a different problem, one that the series
is not going to address.

Can you check vmstat and  make sure reclaim is actually active when
mplayer performance goes to hell please?

-- 
Mel Gorman
SUSE Labs
