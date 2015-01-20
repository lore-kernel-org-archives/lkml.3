Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbbATOaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:30:12 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:48627 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbbATOaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:30:10 -0500
Date: Tue, 20 Jan 2015 09:30:02 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - "none"
Message-ID: <20150120143002.GB11181@phnom.home.cmpxchg.org>
References: <1421508107-29377-1-git-send-email-hannes@cmpxchg.org>
 <20150120133711.GI25342@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120133711.GI25342@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 02:37:11PM +0100, Michal Hocko wrote:
> On Sat 17-01-15 10:21:47, Johannes Weiner wrote:
> > The "none" name for the low-boundary 0 and the high-boundary maximum
> > value can be confusing.
> > 
> > Just leave the low boundary at 0, and give the highest-possible
> > boundary value the name "max" that means the same for controls.
> 
> max might be confusing as well because it matches with the knob name.
> max_resource or max_memory sounds better to me.

These names are appalling in the same way that memory.limit_in_bytes
is.  They are too long, while their information density is low.  They
make you type out the unit that should be painfully obvious to anybody
doing the typing.  And they still overlap with the knob name!

$ cat memory.max
max_memory

Really?

Another possibility would be "infinity", but tbh I think "max" is just
fine.  It's descriptive, the potential for confusion is low and easily
eliminated with documentation, and it's short and easy to type.

> Btw. I would separate page_counter_memparse change out and
> replace the original 'mm: page_counter: pull "-1" handling out of
> page_counter_memparse()' by it.

Yeah, that would probably make sense, but we can't do it incrementally
anymore.  Andrew, want me to resend these two patches with all fixes
incorporated?

Thanks!
