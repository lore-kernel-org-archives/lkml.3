Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaDVNVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:21:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844AbaDVNVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:21:05 -0400
Date: Tue, 22 Apr 2014 15:21:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] memcg: mm_update_next_owner() should skip kthreads
Message-ID: <20140422132102.GN29311@dhcp22.suse.cz>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com>
 <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com>
 <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com>
 <20140416135741.GA9407@redhat.com>
 <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com>
 <20140418162359.GA4398@redhat.com>
 <20140418172631.GA13323@redhat.com>
 <20140418182444.GB22235@dhcp22.suse.cz>
 <20140418184441.GA26046@redhat.com>
 <20140422105228.GJ29311@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422105228.GJ29311@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-04-14 12:52:28, Michal Hocko wrote:
> On Fri 18-04-14 20:44:41, Oleg Nesterov wrote:
[...]
> > I do not even understand why do we have CONFIG_MM_OWNER, perhaps it should
> > die?
> 
> I have to dig into history to check why it has been introduced in the
> first place. It might be possible it is not relevant anymore.

There didn't seem to be any other user of CONFIG_MM_OWNER outside of
MEMCG so it seems that a separate config option seems like an overkill.
Regarding the mm->owner itself it is hard to live without it at the
moment. Most of the charging places do charge the current task_struct
but there are some that rely on mm and we would need mm->task mapping.
The last obstacle would be threads migration but that one should go away
with unified hierarchy AFAIR.
-- 
Michal Hocko
SUSE Labs
