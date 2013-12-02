Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3LBXHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:07:44 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:38742 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3LBXHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:07:42 -0500
Date: Mon, 2 Dec 2013 15:07:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: linux-mm@kvack.org, Greg Thelen <gthelen@google.com>,
        Glauber Costa <glommer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
In-Reply-To: <20131128115458.GK2761@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013, Michal Hocko wrote:

> > Agreed, and I think the big downside of doing it with the loadable module 
> > suggestion is that you can't implement such a wide variety of different 
> > policies in modules.  Each of our users who own a memcg tree on our 
> > systems may want to have their own policy and they can't load a module at 
> > runtime or ship with the kernel.
> 
> But those users care about their local (memcg) OOM, don't they? So they
> do not need any module and all they want is to get a notification.

Sure, but I think the question is more of the benefit of doing it in the 
kernel as opposed to userspace.  If we implement the necessary mechanisms 
that allow userspace to reliably handle these situations, I don't see much 
of a benefit to modules other than for separating code amongst multiple 
files in the source.  I don't think we want to ship multiple different oom 
policies because then userspace that cares about it has to figure out 
what's in effect and what it can do with what's available.  I'd argue that 
a the key functionality that I've already described (system oom 
notification, memcg reserves, timeout) allow for any policy to be defined 
reliably in userspace.
