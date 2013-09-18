Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab3IRLec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:34:32 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:32915 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3IRLeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:34:31 -0400
Message-ID: <52398FBF.5060102@t-online.de>
Date: Wed, 18 Sep 2013 13:34:23 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linux MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH] [RFC] mm/shrinker: Add a shrinker flag to
 always shrink a bit
References: <1379495401-18279-1-git-send-email-daniel.vetter@ffwll.ch> <5239829F.4080601@t-online.de> <20130918105631.GS32145@phenom.ffwll.local>
In-Reply-To: <20130918105631.GS32145@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: ExGChZZGQhlakVmLRNz5OtQvpLLv1f1ZriDZgUD5-GDJs39OQ7MYn1quvyhIO4xgdF
X-TOI-MSGID: d653204d-15b2-40a8-bcb7-b9304ed02c9d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Looking at the patch which introduced these error message for you, which
> changed the ->count_objects return value from 0 to SHRINK_STOP your patch
> below to treat 0 and SHRINK_STOP equally simply reverts the functional
> change.

Yes, for i915* it de facto restores the old behaviour.

> I don't think that's the intention behind SHRINK_STOP. But if it's the
> right think to do we better revert the offending commit directly.
But there is other code that also returns SHRINK_STOP. So i believe it´s better to
adapt shrink_slab_node() to handle SHRINK_STOP properly than to revert 81e49f.

>   And since I lack clue I think that's a call for core mm guys to make.

I agree. They´ll probably have to apply some additional changes to
shrink_slab_node(). It really doesn´t look right to me, but they certainly
know better what the code is supposed to do ;-)


cu,
  Knut
