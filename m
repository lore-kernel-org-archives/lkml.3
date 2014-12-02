Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049AbaLBTfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:35:44 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:54268 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179AbaLBTfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:35:41 -0500
Date: Tue, 2 Dec 2014 14:35:38 -0500
From: Tejun Heo <tj@kernel.org>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 3.10] cgroup: break infinite loop in __css_tryget()
Message-ID: <20141202193538.GO10918@htj.dyndns.org>
References: <1417193274-20679-1-git-send-email-klamm@yandex-team.ru>
 <20141202165553.GB10918@htj.dyndns.org>
 <119181417545645@webcorp02h.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <119181417545645@webcorp02h.yandex-team.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:40:45PM +0300, Roman Gushchin wrote:
> Hi, Tejun!
> 
> 02.12.2014, 19:56, "Tejun Heo" <tj@kernel.org>:
> > Hello, Roman.
> >
> > On Fri, Nov 28, 2014 at 07:47:54PM +0300, Roman Gushchin wrote:
> >>  If cgroup_destroy_locked() sets the css refcount to a negative value,
> >>  we get an infinite loop in __css_tryget().
> >>
> >>  In this case css_refcnt() returns modified (non-negative value), so
> >>  both (t == v) and (t < 0) conditions are always false.
> >
> > I don't follow.  The count is biased and modified by unbiasing iff the
> > value is negative.  Here, @v is the unbiased value and @t is the
> > verbatim value.  If @v is different from @t due to unbiasing, @t must
> > be negative satisfying the second condition and returning NULL, no?
> 
> Yep. I missed that we compare t with 0 (not v).

Hmm... what's up with the rcu stall message then?

-- 
tejun
