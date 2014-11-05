Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaKEPpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:45:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaKEPp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:45:28 -0500
Date: Wed, 5 Nov 2014 16:45:26 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141105154526.GG4527@dhcp22.suse.cz>
References: <2156351.pWp6MNRoWm@vostro.rjw.lan>
 <20141021141159.GE9415@dhcp22.suse.cz>
 <4766859.KSKPTm3b0x@vostro.rjw.lan>
 <20141021142939.GG9415@dhcp22.suse.cz>
 <20141104192705.GA22163@htj.dyndns.org>
 <20141105124620.GB4527@dhcp22.suse.cz>
 <20141105130247.GA14386@htj.dyndns.org>
 <20141105133100.GC4527@dhcp22.suse.cz>
 <20141105134219.GD4527@dhcp22.suse.cz>
 <20141105141458.GE4527@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105141458.GE4527@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ups, just noticed that I have a compile fix staged which didn't make it
into git format-patch. Will repost after/if you are OK with this
approach. But I guess this is much better outcome. Thanks for pushing
Tejun!

On Wed 05-11-14 15:14:58, Michal Hocko wrote:
[...]
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5340f6b91312..7fc75b4df837 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
[...]
> @@ -615,6 +598,28 @@ void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
>  	spin_unlock(&zone_scan_lock);
>  }
>  
> +static DECLARE_RWSEM(oom_sem);
> +
> +void oom_killer_disabled(void)

Should be oom_killer_disable(void)

-- 
Michal Hocko
SUSE Labs
