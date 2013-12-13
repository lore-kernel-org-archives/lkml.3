Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3LMQqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:46:17 -0500
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:59421 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab3LMQqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:46:16 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Dec 2013 11:46:16 EST
Date: Fri, 13 Dec 2013 16:40:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        azurIt <azurit@pobox.sk>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Casteyde <casteyde.christian@free.fr>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the
 allocator
In-Reply-To: <20131213065805.GC8845@lge.com>
Message-ID: <00000142ecd51cc6-b987e565-7b4f-4945-89ba-731f1d1376fb-000000@email.amazonses.com>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org> <1381265890-11333-2-git-send-email-hannes@cmpxchg.org> <20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org> <20131204015218.GA19709@lge.com> <20131213065805.GC8845@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.13-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Joonsoo Kim wrote:

> Could you review this patch?
> I think that we should merge it to fix the problem reported by Christian.

I'd be fine with clearing __GFP_NOFAIL but not with using the same flags
as for a higher order alloc. __GFP_NORETRY and __GFP_NOWARN should be left
untouched for the minimal alloc.

