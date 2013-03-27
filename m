Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3C0W4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:56:06 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:50304 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3C0W4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:56:04 -0400
Date: Wed, 27 Mar 2013 23:55:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] memory-hotplug: enable memory hotplug to handle
 hugepage
Message-ID: <20130327225548.GA401@dhcp22.suse.cz>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-10-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130325150952.GA2154@dhcp22.suse.cz>
 <1364322204-ah777uqs-mutt-n-horiguchi@ah.jp.nec.com>
 <20130327141921.GJ16579@dhcp22.suse.cz>
 <1364419759-a5hijyn0-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364419759-a5hijyn0-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 27-03-13 17:29:19, Naoya Horiguchi wrote:
> On Wed, Mar 27, 2013 at 03:19:21PM +0100, Michal Hocko wrote:
[...]
> > If we made sure that all page on the hugepage_freelists have reference
> > 0 (which is now not the case and it is yet another source of confusion)
> > then the whole loop could be replaced by page_count check.
> 
> I think that free hugepages have refcount 0,

You are right. For some reason I totally missed that we drop
the reference from page allocator (put_page_testzero in
gather_surplus_pages).

Sorry about the stupit question.
-- 
Michal Hocko
SUSE Labs
