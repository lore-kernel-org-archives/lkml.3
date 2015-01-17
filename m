Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbbAQTsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 14:48:38 -0500
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:42665 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbbAQTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 14:48:37 -0500
Date: Sat, 17 Jan 2015 13:48:34 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vinayak Menon <vinmenon@codeaurora.org>
cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
In-Reply-To: <54BA7D3A.40100@codeaurora.org>
Message-ID: <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org> <20150114165036.GI4706@dhcp22.suse.cz> <54B7F7C4.2070105@codeaurora.org> <20150116154922.GB4650@dhcp22.suse.cz> <54BA7D3A.40100@codeaurora.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Jan 2015, Vinayak Menon wrote:

> which had not updated the vmstat_diff. This CPU was in idle for around 30
> secs. When I looked at the tvec base for this CPU, the timer associated with
> vmstat_update had its expiry time less than current jiffies. This timer had
> its deferrable flag set, and was tied to the next non-deferrable timer in the

We can remove the deferrrable flag now since the vmstat threads are only
activated as necessary with the recent changes. Looks like this could fix
your issue?

