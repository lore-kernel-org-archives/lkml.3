Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbbASE1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:27:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36570 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbbASE1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:27:16 -0500
Message-ID: <54BC879C.90505@codeaurora.org>
Date: Mon, 19 Jan 2015 09:57:08 +0530
From: Vinayak Menon <vinmenon@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in too_many_isolated
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org> <20150114165036.GI4706@dhcp22.suse.cz> <54B7F7C4.2070105@codeaurora.org> <20150116154922.GB4650@dhcp22.suse.cz> <54BA7D3A.40100@codeaurora.org> <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2015 01:18 AM, Christoph Lameter wrote:
> On Sat, 17 Jan 2015, Vinayak Menon wrote:
>
>> which had not updated the vmstat_diff. This CPU was in idle for around 30
>> secs. When I looked at the tvec base for this CPU, the timer associated with
>> vmstat_update had its expiry time less than current jiffies. This timer had
>> its deferrable flag set, and was tied to the next non-deferrable timer in the
>
> We can remove the deferrrable flag now since the vmstat threads are only
> activated as necessary with the recent changes. Looks like this could fix
> your issue?
>

Yes, this should fix my issue.
But I think we may need the fix in too_many_isolated, since there can 
still be a delay of few seconds (HZ by default and even more because of 
reasons pointed out by Michal) which will result in reclaimers 
unnecessarily entering congestion_wait. No ?


-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
