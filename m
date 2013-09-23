Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3IWPGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:06:32 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:58765 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3IWPGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:06:31 -0400
Date: Mon, 23 Sep 2013 11:06:25 -0400
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info' in
 all related extern functions
Message-ID: <20130923150625.GB14547@htj.dyndns.org>
References: <5212DBFA.8030805@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5212DBFA.8030805@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(I have no idea about this but Andrew tagged me, probably thinking it
was related to cgroups, so here it goes ;)

On Tue, Aug 20, 2013 at 11:01:14AM +0800, Chen Gang wrote:
> groups_alloc() can return NULL for 'group_info', also group_search()
> already considers about NULL for 'group_info', so can assume the caller
> has right to use all related extern functions when 'group_info' is NULL.
> 
> For groups_free(), need check NULL to match groups_alloc(), just like
> kmalloc/free().

While it is somewhat customary to make free routines handle NULL
inputs, the convention isn't a very strong one and given that the
above change doesn't actually benefit any of the existing use cases,
it seems gratuituous.

> For set_groups(), can allow the caller to set NULL parameter to new
> 'cred'.
> 
> For system call getgroups(), if 'cred->group_info' is NULL, need return
> the related error code (no related data), also need change the related
> man page ("man 2 getgroups") to complete the return value.

How can cred->group_info be NULL?  Can you please describe what issue
this patch is trying to solve / improve?  The patch description
explains what's being changed but doesn't really offer why such
changes are being made.  Can you please explain why this change is
beneficial?

Thanks.

-- 
tejun
