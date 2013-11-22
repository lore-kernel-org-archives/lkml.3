Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3KVCKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:10:45 -0500
Received: from longford.logfs.org ([213.229.74.203]:53198 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3KVCKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:10:43 -0500
X-Greylist: delayed 1856 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2013 21:10:43 EST
Date: Thu, 21 Nov 2013 19:19:00 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
Message-ID: <20131122001859.GA9510@logfs.org>
References: <20131119131400.GC20655@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131119131400.GC20655@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 November 2013 14:14:00 +0100, Michal Hocko wrote:
> 
> We have basically ended up with 3 options AFAIR:
> 	1) allow memcg approach (memcg.oom_control) on the root level
>            for both OOM notification and blocking OOM killer and handle
>            the situation from the userspace same as we can for other
> 	   memcgs.
> 	2) allow modules to hook into OOM killer path and take the
> 	   appropriate action.
> 	3) create a generic filtering mechanism which could be
> 	   controlled from the userspace by a set of rules (e.g.
> 	   something analogous to packet filtering).

One ancient option I sometime miss was this:
	- Kill the biggest process.

Doesn't always make the optimal choice, but neither did any of the
refinements.  But it had the nice advantage that even I could predict
which bad choice it would make and why.  Every bit of sophistication
means that you still get it wrong sometimes, but in less obvious and
more annoying ways.

Then again, an alternative I actually use in production is to reboot
the machine on OOM.  Again, very simple, very blunt and very
predictable.

Jörn

--
No art, however minor, demands less than total dedication if you want
to excel in it.
-- Leon Battista Alberti
