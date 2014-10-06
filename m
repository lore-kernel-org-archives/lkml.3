Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbaJFGik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 02:38:40 -0400
Received: from mx2.parallels.com ([199.115.105.18]:48089 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJFGii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 02:38:38 -0400
Date: Mon, 6 Oct 2014 10:38:29 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Michal Hocko <mhocko@suse.cz>
CC: Johannes Weiner <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
        Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/3] mm: memcontrol: lockless page counters
Message-ID: <20141006063829.GB1162@esperanza>
References: <1411573390-9601-1-git-send-email-hannes@cmpxchg.org>
 <1411573390-9601-2-git-send-email-hannes@cmpxchg.org>
 <20140926103104.GE29445@esperanza>
 <20141002120748.GA1359@cmpxchg.org>
 <20141003153623.GA1162@esperanza>
 <20141003154134.GG4816@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141003154134.GG4816@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 05:41:34PM +0200, Michal Hocko wrote:
> On Fri 03-10-14 19:36:23, Vladimir Davydov wrote:
> > On Thu, Oct 02, 2014 at 08:07:48AM -0400, Johannes Weiner wrote:
> [...]
> > > The barriers are implied in change-return atomics, which is why there
> > > is an xchg.  But it's clear that this needs to be documented.  This?:
> > 
> > With the comments it looks correct to me, but I wonder if we can always
> > rely on implicit memory barriers issued by atomic ops. Are there any
> > archs where it doesn't hold?
> 
> xchg is explcitly mentioned in Documentation/memory-barriers.txt so it
> is expected to be barrier on all archs. Besides that not all atomic ops
> imply memory barriers. Only those that "modifies some state in memory
> and returns information about the state" do.

Thank you for the info, now it's clear to me.

Thanks,
Vladimir
