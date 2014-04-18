Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaDRR0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:26:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaDRR0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:26:50 -0400
Date: Fri, 18 Apr 2014 19:26:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] memcg: mm_update_next_owner() should skip kthreads
Message-ID: <20140418172631.GA13323@redhat.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com> <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com> <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com> <20140416135741.GA9407@redhat.com> <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com> <20140418162359.GA4398@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418162359.GA4398@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18, Oleg Nesterov wrote:
>
> Hmm. I seem to see a bug in this function, it can be fulled by use_mm,
> but I am not sure this can explain the problem. I'll send a patch.

Untested, please review. But it really looks "obviously wrong", and note
that unuse_mm() doesn't do mm_update_next_owner(). (just in case, do not
confuse it with unuse_mm() in mm/swapfile.c).

Oleg.

