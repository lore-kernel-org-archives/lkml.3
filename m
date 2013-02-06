Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3BFC0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:26:55 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:53660 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3BFC0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:26:52 -0500
MIME-Version: 1.0
In-Reply-To: <20130205115722.GF21389@suse.de>
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com>
	<1359972248-8722-2-git-send-email-linfeng@cn.fujitsu.com>
	<20130204160624.5c20a8a0.akpm@linux-foundation.org>
	<20130205115722.GF21389@suse.de>
Date: Tue, 5 Feb 2013 18:26:51 -0800
Message-ID: <CANN689GVFYTqs0wxX3bKZtyBcWf6=gLvS8hFG-65htsnPDknSA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: hotplug: implement non-movable version of
 get_user_pages() called get_user_pages_non_movable()
From: Michel Lespinasse <walken@google.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lin Feng <linfeng@cn.fujitsu.com>, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com,
        rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just nitpicking, but:

On Tue, Feb 5, 2013 at 3:57 AM, Mel Gorman <mgorman@suse.de> wrote:
> +static inline bool zone_is_idx(struct zone *zone, enum zone_type idx)
> +{
> +       /* This mess avoids a potentially expensive pointer subtraction. */
> +       int zone_off = (char *)zone - (char *)zone->zone_pgdat->node_zones;
> +       return zone_off == idx * sizeof(*zone);
> +}

Maybe:
return zone == zone->zone_pgdat->node_zones + idx;
?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
