Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaBDQGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:06:06 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:57228 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbaBDQGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:06:03 -0500
Date: Tue, 4 Feb 2014 11:05:58 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH -v2 3/6] memcg: mm == NULL is not allowed for
 mem_cgroup_try_charge_mm
Message-ID: <20140204160558.GO6963@cmpxchg.org>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
 <1391520540-17436-4-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391520540-17436-4-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 02:28:57PM +0100, Michal Hocko wrote:
> An ancient comment tries to explain that a given mm might be NULL when a
> task is migrated. It has been introduced by 8a9f3ccd (Memory controller:
> memory accounting) along with other bigger changes so it is not much
> more specific about the conditions.
> 
> Anyway, Even if the task is migrated to another memcg there is no way we
> can see NULL mm struct. So either this was not correct from the very
> beginning or it is not true anymore.
> The only remaining case would be seeing charges after exit_mm but that
> would be a bug on its own as the task doesn't have an address space
> anymore.
> 
> This patch replaces the check by VM_BUG_ON to make it obvious that we
> really expect non-NULL mm_struct.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
