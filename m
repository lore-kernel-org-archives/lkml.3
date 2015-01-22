Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbbAVQLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:11:37 -0500
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:44376 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbbAVQLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:11:34 -0500
Date: Thu, 22 Jan 2015 10:11:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Michal Hocko <mhocko@suse.cz>
cc: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
In-Reply-To: <20150121143920.GD23700@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.11.1501221010510.3937@gentwo.org>
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org> <20150114165036.GI4706@dhcp22.suse.cz> <54B7F7C4.2070105@codeaurora.org> <20150116154922.GB4650@dhcp22.suse.cz> <54BA7D3A.40100@codeaurora.org> <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
 <54BC879C.90505@codeaurora.org> <20150121143920.GD23700@dhcp22.suse.cz>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Michal Hocko wrote:

> I think we can solve this as well. We can stick vmstat_shepherd into a
> kernel thread with a loop with the configured timeout and then create a
> mask of CPUs which need the update and run vmstat_update from
> IPI context (smp_call_function_many).

Please do not run the vmstat_updates concurrently. They update shared
cachelines and therefore can cause bouncing cachelines if run concurrently
on multiple cpus.
