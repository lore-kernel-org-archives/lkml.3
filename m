Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbaAPWtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:49:31 -0500
Received: from mail-gg0-f170.google.com ([209.85.161.170]:55553 "EHLO
	mail-gg0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaAPWt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:49:29 -0500
Date: Thu, 16 Jan 2014 14:49:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2 -mm] mm, oom: prefer thread group leaders for display
 purposes
In-Reply-To: <20140116142141.GF28157@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1401161447510.31228@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com> <20140116070549.GL6963@cmpxchg.org> <alpine.DEB.2.02.1401152344560.14407@chino.kir.corp.google.com> <alpine.DEB.2.02.1401152345330.14407@chino.kir.corp.google.com>
 <20140116142141.GF28157@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Michal Hocko wrote:

> > When two threads have the same badness score, it's preferable to kill the 
> > thread group leader so that the actual process name is printed to the 
> > kernel log rather than the thread group name which may be shared amongst 
> > several processes.
> 
> I am not sure I understand this. Is this about ->comm? If yes then why
> couldn't the group leader do PR_SET_NAME?
> 

Both comm and pid, we only display thread group leaders in the tasklist 
dump of eligible processes, we want the killed message to specify from 
which process.

You're suggesting a thread group leader do PR_SET_NAME of all its threads 
for readable oom killer output?  Lol.
