Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaA3Af4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:35:56 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64603 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaA3Afk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:35:40 -0500
Date: Wed, 29 Jan 2014 16:35:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, oom: base root bonus on current usage
In-Reply-To: <20140129122813.59d32e5c5dad3efc2248bc60@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1401291628340.22974@chino.kir.corp.google.com>
References: <20140115234308.GB4407@cmpxchg.org> <alpine.DEB.2.02.1401151614480.15665@chino.kir.corp.google.com> <20140116070709.GM6963@cmpxchg.org> <alpine.DEB.2.02.1401212050340.8512@chino.kir.corp.google.com> <20140124040531.GF4407@cmpxchg.org>
 <alpine.DEB.2.02.1401251942510.3140@chino.kir.corp.google.com> <20140129122813.59d32e5c5dad3efc2248bc60@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014, Andrew Morton wrote:

> This changelog has deteriorated :( We should provide sufficient info so
> that people will be able to determine whether this patch will fix a
> problem they or their customers are observing.  And so that people who
> maintain -stable and its derivatives can decide whether to backport it.
> 
> I went back and stole some text from the v1 patch.  Please review the
> result.  The changelog would be even better if it were to describe the
> new behaviour under the problematic workloads.
> 

The new changelog looks fine with the exception of the mention of sshd 
which typically sets itself to be disabled from oom killing altogether.

> We don't think -stable needs this?
> 

Nobody has reported it in over three years as causing an issue, probably 
because people typically have enough memory that oom kills don't come from 
a ton of small processes allocating memory that can't be reclaimed, 
there's usually at least one large process to kill.
