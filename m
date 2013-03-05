Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3CEFvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:51:31 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:65058 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab3CEFv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:51:29 -0500
Date: Tue, 5 Mar 2013 09:51:26 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Raphael S Carvalho <raphael.scarv@gmail.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kernel/pid_namespace.c: Fixing a lack of cleanup
 (Probable resources leak).
Message-ID: <20130305055126.GE11231@moon>
References: <1362454007-353-1-git-send-email-ebiederm@xmission.com>
 <51356BD8.4040408@cn.fujitsu.com>
 <CACz=WeetSxr5hb3BAKn7ks-yrMyCtgZ5HZjE+V14trmnoH+61g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACz=WeetSxr5hb3BAKn7ks-yrMyCtgZ5HZjE+V14trmnoH+61g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 02:04:45AM -0300, Raphael S Carvalho wrote:
> >
> > Actually I noticed this problem and I think it is not a BUG.
> > Since the pid_cache is created for all pid namespace which have the same level.
> > Even this pid namespace is failed to create, the pid_cache will not be leaked, Other
> > pid namespace which has the same level will use the pid_cache and no need to
> > allocate it again. In other words, the pid_cache for every level pid namespace will
> > only be created once.
> >
> > I also think this patch add a bug,because there may be other pid namespace's pid_cachep
> > points to the same pid_cache which will be free at the by label out_free_cachep.
> >

Yup, drop this patch.

> 
> Yeah, I found the snippet of code which searches for the pcache with
> the same level.
>  46        list_for_each_entry(pcache, &pid_caches_lh, list)
>  47                if (pcache->nr_ids == nr_ids)
>  48                        goto out;
