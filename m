Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbbAGR5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:57:37 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45228 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbbAGR5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:57:35 -0500
Date: Wed, 7 Jan 2015 12:57:31 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v2 1/5] oom: add helpers for setting and clearing
 TIF_MEMDIE
Message-ID: <20150107175731.GG4395@htj.dyndns.org>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
 <1417797707-31699-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417797707-31699-2-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 05:41:43PM +0100, Michal Hocko wrote:
> +/**
> + * Unmarks the current task as OOM victim.
> + */
> +void unmark_tsk_oom_victim(void)
> +{
> +	clear_thread_flag(TIF_MEMDIE);
> +}

This prolly should be unmark_current_oom_victim()?  Also, can we
please use full "task" at least in global symbols?  I don't think tsk
abbreviation is that popular in function names.

Thanks.

-- 
tejun
