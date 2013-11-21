Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3KUDjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:39:03 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:48677 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3KUDjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:39:00 -0500
Date: Wed, 20 Nov 2013 19:38:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Vladimir Murzin <murzin.v@gmail.com>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
In-Reply-To: <20131120173357.GC18809@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1311201937120.7167@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <20131120172119.GA1848@hp530> <20131120173357.GC18809@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013, Michal Hocko wrote:

> OK, I was a bit vague it seems. I meant to give zonelist, gfp_mask,
> allocation order and nodemask parameters to the modules. So they have a
> better picture of what is the OOM context.
> What everything ould modules need to do an effective work is a matter
> for discussion.
> 

It's an interesting idea but unfortunately a non-starter for us because 
our users don't have root, we create their memcg tree and then chown it to 
the user.  They can freely register for oom notifications but cannot load 
their own kernel modules for their own specific policy.
