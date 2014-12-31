Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaLaIqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:46:44 -0500
Received: from mailsec108.isp.belgacom.be ([195.238.20.104]:35837 "EHLO
	mailsec108.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818AbaLaIqm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:46:42 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=M25fSHNwW0AVyF8PBjdaZiLQS1FBtLFJFIDkHdlBKq0= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=drOt6m5kAAAA:8 a=xoD-21AcaPIrMz-WFBkA:9 a=QEXdDO2ut3YA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUHAKW2o1TD7hTR/2dsb2JhbAAbAUCDBoEqgwWwbwEBAQEBAQaYLQKBBhYBAQEBAX2EDAEBAQMBI1YFCwUEAhgCAhgOAgJXBgESEYgTDJRYU5xohlOOGQEBAQcBAQEBHoEhhGKJQTMHgmiBQQWoWCKDbz0xgkMBAQE
Date: Wed, 31 Dec 2014 09:46:40 +0100 (CET)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Evgeniy Dushistov <dushistov@mail.ru>
Message-ID: <1493200060.285968.1420015600342.open-xchange@webmail.nmp.proximus.be>
In-Reply-To: <20141228182158.GJ22149@ZenIV.linux.org.uk>
References: <1419780509-4582-1-git-send-email-fabf@skynet.be> <20141228153311.GI22149@ZenIV.linux.org.uk> <1419785144.20894.10.camel@perches.com> <20141228182158.GJ22149@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/1] fs/ufs/super.c: remove unnecessary casting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 28 December 2014 at 19:21 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
>
> On Sun, Dec 28, 2014 at 08:45:44AM -0800, Joe Perches wrote:
> > On Sun, 2014-12-28 at 15:33 +0000, Al Viro wrote:
> > > On Sun, Dec 28, 2014 at 04:28:29PM +0100, Fabian Frederick wrote:
> > > > Fix the following coccinelle warning:
> > > > fs/ufs/super.c:1418:7-28: WARNING: casting value returned by memory
> > > > allocation function to (struct ufs_inode_info *) is useless.
> > >
> > > ... except that it makes allocations harder to grep for.
> >
> > How does it do that?
>
> search for \<struct[  ]*$NAME[        ]*($|[^         *]|[*][         ]*[)])
> generally gives a lot of interesting information (variables of that type,
> members of anything having that type, sizeof, container_of, explicit casts)
> with relatively little noise.
>
> BTW, that's why I really don't like the stuff like
>       struct foo *p = kmalloc(sizeof(*p), GFP_KERNEL);
> It's bloody hard to spot.
>
> In case of UFS we still catch "sizeof(struct ufs_inode_info)" in
>         ufs_inode_cachep = kmem_cache_create("ufs_inode_cache",
>                                              sizeof(struct ufs_inode_info),
>                                              0, (SLAB_RECLAIM_ACCOUNT|
>                                                 SLAB_MEM_SPREAD),
>                                              init_once);
> which gives the obvious secondary search pattern, so it's not _that_ terrible,
> but in general it's not something to do without thinking - such a cast could
> be placed there exactly to make it stand out on grep.

Thanks a lot for taking the time to explain the problem Al.
I'll be more careful next time.

Regards,
Fabian
