Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3B0WQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:16:14 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60375 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3B0WQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:16:10 -0500
Date: Wed, 27 Feb 2013 14:16:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, show_mem: suppress page counts in non-blockable
 contexts
In-Reply-To: <20130227100024.GA16724@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1302271413460.7155@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1302261642520.11109@chino.kir.corp.google.com> <20130227100024.GA16724@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013, Michal Hocko wrote:

> But we are trying to prevent from soft lockups by calling
> touch_nmi_watchdog every now when iterating over pages so the lock up
> detector shouldn't trigger.
> 
> Anyway, I think that the additional information (which can be really
> costly as you are describing) is not that useful. Most of the useful
> information is already printed by show_free_areas. Or does it help when
> we know how much memory is shared/reserved/etc. when the allocation
> fails?
> 

I do not think it is helpful since show_free_areas() already shows all 
pertinent information, and hence I'm suppressing it in atomic contexts in 
this patch.

> So I do agree with the dropping the additional information for the
> allocation failure path (sysrq+m might still show it) but I fail to see
> how the lockup detector plays any role here. Can we just drop it because
> it is not that interesting and it is costly so it is not worth
> bothering?
>  

I would agree it is not interesting to debugging VM issues and is 
obviously very expensive.
