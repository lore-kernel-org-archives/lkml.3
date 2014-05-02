Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaEBWFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:05:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaEBWFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:05:18 -0400
Date: Fri, 2 May 2014 15:05:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Jianyu Zhan <nasa4836@gmail.com>,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.com
Subject: Re: [PATCH 2/2] mm/memcontrol.c: introduce helper
 mem_cgroup_zoneinfo_zone()
Message-Id: <20140502150516.d42792bad53d86fb727816bd@linux-foundation.org>
In-Reply-To: <20140501125450.GA23420@cmpxchg.org>
References: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
	<20140422095923.GD29311@dhcp22.suse.cz>
	<20140428150426.GB24807@dhcp22.suse.cz>
	<20140501125450.GA23420@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014 08:54:50 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Mon, Apr 28, 2014 at 05:04:26PM +0200, Michal Hocko wrote:
> > On Tue 22-04-14 11:59:23, Michal Hocko wrote:
> > > On Sat 19-04-14 07:01:43, Jianyu Zhan wrote:
> > > > introduce helper mem_cgroup_zoneinfo_zone(). This will make
> > > > mem_cgroup_iter() code more compact.
> > > 
> > > I dunno. Helpers are usually nice but this one adds more code then it
> > > removes. It also doesn't help the generated code.
> > > 
> > > So I don't see any reason to merge it.
> > 
> > So should we drop it from mmotm?
> 
> Yes, please.
> 
> > > > Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> > > > ---
> > > >  mm/memcontrol.c | 15 +++++++++++----
> > > >  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> This helper adds no value, but more code and indirection.
> 
> Cc'd Andrew - this is about
> mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
> mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch

The patch seemed rather nice to me.  mem_cgroup_zoneinfo_zone()
encapsulates a particular concept and gives it a name.  That's better
than splattering the logic into callsites.

The patch makes no change to code size but that's because gcc is silly.
Mark mem_cgroup_zoneinfo_zone() as noinline and the patch shrinks
.text by 40 bytes.

