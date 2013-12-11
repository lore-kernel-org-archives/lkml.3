Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab3LKBDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:03:51 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:36130 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3LKBDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:03:48 -0500
Date: Tue, 10 Dec 2013 17:03:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
In-Reply-To: <20131210103827.GB20242@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com> <20131127163435.GA3556@cmpxchg.org> <20131202200221.GC5524@dhcp22.suse.cz> <20131202212500.GN22729@cmpxchg.org> <20131203120454.GA12758@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312031544530.5946@chino.kir.corp.google.com> <20131204111318.GE8410@dhcp22.suse.cz> <alpine.DEB.2.02.1312041606260.6329@chino.kir.corp.google.com> <20131209124840.GC3597@dhcp22.suse.cz> <alpine.DEB.2.02.1312091328550.11026@chino.kir.corp.google.com>
 <20131210103827.GB20242@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Michal Hocko wrote:

> > What exactly would you like to see?
> 
> How often do you see PF_EXITING tasks which haven't been killed causing
> a pointless notification? Because fatal_signal_pending and TIF_MEMDIE
> cases are already handled because we bypass charges in those cases (except
> for user OOM killer killed tasks which don't get TIF_MEMDIE and that
> should be fixed).
> 

Triggering a pointless notification with PF_EXITING is rare, yet one 
pointless notification can be avoided with the patch.  Additionally, it 
also avoids a pointless notification for a racing SIGKILL.
