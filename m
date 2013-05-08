Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3EHSsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:48:21 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:37483 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3EHSsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:48:20 -0400
X-ASG-Debug-ID: 1368038899-0421b536855cf50001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Christoph Lameter <cl@linux.com>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
 <20130508003022.GS28721@atomide.com> <20130508042422.GU28721@atomide.com>
 <20130508181353.23991.17852@localhost.localdomain>
 <0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
Message-ID: <20130508184817.4271.72594@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [GIT PULL] SLAB changes for v3.10
Date: Wed, 8 May 2013 14:48:17 -0400
X-ASG-Orig-Subj: Re: [GIT PULL] SLAB changes for v3.10
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1368038899
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.130384
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Christoph Lameter (2013-05-08 14:25:49)
> On Wed, 8 May 2013, Chris Mason wrote:
> 
> > This patch fixes things for me, but to maintain the rules from
> > Christoph's patch,  kmalloc_caches[2] should have been created whenever
> > kmalloc_caches[7] was done.
> 
> Not necessary. The early slab bootstrap must create some slab caches of
> specific sizes, it will only use those during very early bootstrap.
> 
> The later creation of the array must skip those.
> 
> You correctly moved the checks out of the if (!kmalloc_cacheS())
> condition so that the caches are created properly.

But if the ordering is required at all, why is it ok to create cache 2
after cache 6 instead of after cache 7?

IOW if we can safely do cache 2 after cache 6, why can't we just do both
cache 1 and cache 2 after the loop?

-chris
