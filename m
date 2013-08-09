Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967041Ab3HIAud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:50:33 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:38495 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966966Ab3HIAub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:50:31 -0400
Date: Thu, 8 Aug 2013 20:50:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH 1/3] memcg: limit the number of thresholds per-memcg
Message-ID: <20130809005026.GE13427@mtj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <20130807132210.GD27006@htj.dyndns.org>
 <20130807134654.GJ8184@dhcp22.suse.cz>
 <20130807135818.GG27006@htj.dyndns.org>
 <20130807143727.GA13279@dhcp22.suse.cz>
 <20130807220513.GA8068@shutemov.name>
 <20130808144351.GD3189@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808144351.GD3189@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 08, 2013 at 04:43:51PM +0200, Michal Hocko wrote:
> > Is it correct that you fix one local DoS by introducing a new one?
> > With the page the !priv user can block root from registering a threshold.
> > Is it really the way we want to fix it?
> 
> OK, I will think about it some more.

The only thing the patch does is replacing implicit global resource
limit with an explicit one.  Whether that's useful or not, I don't
know, but it doesn't really change the nature of the problem or
actually fix anything.  The only way to fix it is rewriting the whole
thing so that allocations are broken up per source, which I don't
think is a good idea at this point.  I'd just add a comment noting why
it's broken.  Given that delegating to !priv users is horribly broken
anyway, I don't think this worsens the situation by too much anyway.

Thanks.

-- 
tejun
