Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbbAPTRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:17:51 -0500
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:38298 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756982AbbAPTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:17:49 -0500
Date: Fri, 16 Jan 2015 13:17:46 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
In-Reply-To: <20150116175745.GA22136@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.11.1501161317001.19117@gentwo.org>
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org> <20150114165036.GI4706@dhcp22.suse.cz> <54B7F7C4.2070105@codeaurora.org> <20150116154922.GB4650@dhcp22.suse.cz> <20150116175745.GA22136@dhcp22.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Michal Hocko wrote:

> On Fri 16-01-15 16:49:22, Michal Hocko wrote:
> [...]
> > Why cannot we simply update the global counters from vmstat_shepherd
> > directly?
>
> OK, I should have checked the updating paths... This would be racy, so
> update from remote is not an option without additional trickery (like
> retries etc.) :/

You can do that if you have a way to ensure that the other cpu does not
access the counter. F.e. if the other cpu is staying in user space all the
time or it is guaranteed to be idle.


