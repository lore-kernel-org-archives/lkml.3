Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab3EHSdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:33:15 -0400
Received: from a9-54.smtp-out.amazonses.com ([54.240.9.54]:59434 "EHLO
	a9-54.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757816Ab3EHSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:33:14 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2013 14:33:13 EDT
Date: Wed, 8 May 2013 18:25:49 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Chris Mason <chris.mason@fusionio.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [GIT PULL] SLAB changes for v3.10
In-Reply-To: <20130508181353.23991.17852@localhost.localdomain>
Message-ID: <0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org> <20130508003022.GS28721@atomide.com> <20130508042422.GU28721@atomide.com> <20130508181353.23991.17852@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.08-54.240.9.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013, Chris Mason wrote:

> This patch fixes things for me, but to maintain the rules from
> Christoph's patch,  kmalloc_caches[2] should have been created whenever
> kmalloc_caches[7] was done.

Not necessary. The early slab bootstrap must create some slab caches of
specific sizes, it will only use those during very early bootstrap.

The later creation of the array must skip those.

You correctly moved the checks out of the if (!kmalloc_cacheS())
condition so that the caches are created properly.

Acked-by: Christoph Lameter <cl@linux.com>

