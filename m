Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab3BFBX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:23:59 -0500
Received: from kanga.kvack.org ([205.233.56.17]:39613 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372Ab3BFBX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:23:56 -0500
X-Greylist: delayed 1899 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2013 20:23:56 EST
Date: Tue, 5 Feb 2013 19:52:17 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Lin Feng <linfeng@cn.fujitsu.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        jmoyer@redhat.com, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of get_user_pages() called get_user_pages_non_movable()
Message-ID: <20130206005217.GJ20842@kvack.org>
References: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com> <1360056113-14294-2-git-send-email-linfeng@cn.fujitsu.com> <20130205120137.GG21389@suse.de> <20130206004234.GD11197@blaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206004234.GD11197@blaptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 09:42:34AM +0900, Minchan Kim wrote:
> THP degradation by increasing MIGRATE_UNMOVABLE?
> Lin said most of GUP pages release the page in short so is it really problem?
> Even in embedded, we don't use THP yet but CMA and GUP call would be not too often
> but failing of CMA would be critical.
> 
> I'd like to hear opinions.

If aio was given a callback to migrate the pages on, it could just migrate 
the pages as needed.  There's nothing fundamental preventing that approach.

		-ben
-- 
"Thought is the essence of where you are now."
