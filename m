Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3F0UlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:41:24 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39818 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3F0UlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:41:23 -0400
Date: Thu, 27 Jun 2013 13:41:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Roman Gushchin <klamm@yandex-team.ru>
cc: Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        penberg@kernel.org, mpm@selenic.com, akpm@linux-foundation.org,
        mgorman@suse.de, glommer@parallels.com, hannes@cmpxchg.org,
        minchan@kernel.org, jiang.liu@huawei.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: Avoid direct compaction if possible
In-Reply-To: <51CBFC95.9070002@yandex-team.ru>
Message-ID: <alpine.DEB.2.02.1306271340240.17334@chino.kir.corp.google.com>
References: <51BB1802.8050108@yandex-team.ru> <0000013f4319cb46-a5a3de58-1207-4037-ae39-574b58135ea2-000000@email.amazonses.com> <alpine.DEB.2.02.1306141322490.17237@chino.kir.corp.google.com> <51BF024F.2080609@yandex-team.ru> <20130617142715.GB8853@dhcp22.suse.cz>
 <51BF230E.8050904@yandex-team.ru> <alpine.DEB.2.02.1306171441510.20631@chino.kir.corp.google.com> <51CBFC95.9070002@yandex-team.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, Roman Gushchin wrote:

> > They certainly aren't enough, the kernel you're running suffers from a
> > couple different memory compaction issues that were fixed in 3.7.  I
> > couldn't sympathize with your situation more, I faced the same issue
> > because of thp and not slub (we use slab).
> > 
> > > I'll try to reproduce the issue on raw 3.9.
> > > 
> 
> I can't reproduce the issue on 3.9.
> It seems that compaction fixes in 3.7 solve the problem.
> 

Yeah, we had significant problems with memory compaction in 3.3 and 3.4 
kernels, so if you need to run with such a kernel you'll want to backport 
the listed commits.  I'm not sure we could get such invasive changes into 
a stable release, unfortunately.
