Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbaGCWG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:06:26 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:55419 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbaGCWGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:06:25 -0400
Message-ID: <1404425183.25480.7.camel@x220>
Subject: Re: commit message 8a5b20aebaa3 refers to non-existing commit ?
From: Paul Bolle <pebolle@tiscali.nl>
To: David Rientjes <rientjes@google.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org
Date: Fri, 04 Jul 2014 00:06:23 +0200
In-Reply-To: <alpine.DEB.2.02.1407031445390.10658@chino.kir.corp.google.com>
References: <53B5CDDD.8000009@gmx.de>
	 <alpine.DEB.2.02.1407031445390.10658@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Jul 2014 22:06:23.0328 (UTC) FILETIME=[06E72600:01CF970B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 14:48 -0700, David Rientjes wrote:
> On Thu, 3 Jul 2014, Toralf Förster wrote:
> 
> > in 
> > commit 8a5b20aebaa3d0ade5b8381e64d35fb777b7b355
> > Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Date:   Wed Jul 2 15:22:35 2014 -0700
> > 
> >     slub: fix off by one in number of slab tests
> > 
> > 
> > you stated:
> > 
> >     Fixes 91cb69620284 ("slub: make dead memcg caches discard free slabs
> >     immediately").
> > 
> > 
> > which I cannot find in main line currently. Pls could you point me to that commit ?
> > 
> 
> It hasn't been pushed to Linus yet, it's still sitting in the -mm tree:
> http://ozlabs.org/~akpm/mmotm/broken-out/slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
> 
> Not sure where the SHA1 came from, probably linux-next.

Correct:
$ git tag --contains 91cb69620284f793928045714575cc7f6285c7f1
next-20140620
next-20140623
next-20140624
next-20140625

>   So the fix made 
> it to Linus before the offending commit, but the code is still correct.
Note that in today's linux-next (next-20140703) it appears to have a
different SHA1:
$ git log --no-merges --grep "slub: make dead memcg caches discard free slabs immediately"
commit a879a7e8c64a8d5594acaf665c4135be31ca6570
Author: Vladimir Davydov <vdavydov@parallels.com>
Date:   Thu Jul 3 08:43:12 2014 +1000

    slub: make dead memcg caches discard free slabs immediately
    
    Since [...]

(Both commits appear to introduce identical changes. I have no idea what
those changes actually do.)


Paul Bolle

