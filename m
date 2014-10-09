Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbaJIEmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 00:42:52 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:49092 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaJIEmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 00:42:43 -0400
MIME-Version: 1.0
In-Reply-To: <1412777266-8251-1-git-send-email-mhocko@suse.cz>
References: <1412777266-8251-1-git-send-email-mhocko@suse.cz>
Date: Wed, 8 Oct 2014 21:42:43 -0700
Message-ID: <CAM_iQpVotwZ50ntff8wvoXFeq3i9k_0xw+pDkrBc0hRDF7qPTA@mail.gmail.com>
Subject: Re: [PATCH 0/3] OOM vs. freezer interaction fixes
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "\\Rafael J. Wysocki\\" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Michal

On Wed, Oct 8, 2014 at 7:07 AM, Michal Hocko <mhocko@suse.cz> wrote:
> Hi Andrew, Rafael,
>
> this has been originally discussed here [1] but didn't lead anywhere AFAICS
> so I would like to resurrect them.
>

Thanks a lot for taking them for me! I was busy with some networking
stuffs and also actually waiting for Rafael's response to your patch.


> The first and third patch are regression fixes and they are a stable
> material IMO. The second patch is a simple cleanup.
>
> The 1st patch is fixing a regression introduced in 3.3 since when OOM
> killer is not able to kill any frozen task and live lock as a result.
> The fix gets us back to the 3.2. As it turned out during the discussion [2]
> this was still not 100% sufficient and that's why we need the 3rd patch.
>
> I was thinking about the proper 1st vs. 3rd patch ordering because
> the 1st patch basically opens a race window fixed by the later patch.
> Original patch from Cong Wang has covered this by cgroup_freezing(current)
> check in should_thaw_current(). But this approach still suffers from OOM
> vs. PM freezer interaction (OOM killer would still live lock waiting for a
> PM frozen task this time).


It should be very rare OOM happens during PM frozen.

>
> So I think the most straight forward way is to address only OOM vs.
> frozen task interaction in the first patch, mark it for stable 3.3+ and
> leave the race to a separate follow up patch which is applicable to
> stable 3.2+ (before a3201227f803 made it inefficient).
>
> Switching 1st and 3rd patches would make some sense as well but then
> it might end up even more confusing because we would be fixing a
> non-existent issue in upstream first...
>

Agreed. Up to you, I have no strong opinions here. :)


Again, thanks!
