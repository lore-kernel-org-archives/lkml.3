Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbaJZSt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 14:49:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55416 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaJZSt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 14:49:28 -0400
Date: Sun, 26 Oct 2014 19:49:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141026184926.GB16309@amd>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
 <2156351.pWp6MNRoWm@vostro.rjw.lan>
 <20141021141159.GE9415@dhcp22.suse.cz>
 <4766859.KSKPTm3b0x@vostro.rjw.lan>
 <20141021142939.GG9415@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021142939.GG9415@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
>  
> +/*
> + * Number of OOM killer invocations (including memcg OOM killer).
> + * Primarily used by PM freezer to check for potential races with
> + * OOM killed frozen task.
> + */
> +static atomic_t oom_kills = ATOMIC_INIT(0);
> +
> +int oom_kills_count(void)
> +{
> +	return atomic_read(&oom_kills);
> +}
> +
> +void note_oom_kill(void)
> +{
> +	atomic_inc(&oom_kills);
> +}
> +

Do we need the extra abstraction here? Maybe oom_kills should be
exported directly?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
