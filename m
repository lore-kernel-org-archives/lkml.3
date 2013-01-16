Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3APPEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:04:30 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:43329 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753267Ab3APPEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:04:25 -0500
Date: Wed, 16 Jan 2013 15:04:23 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] slub: correct to calculate num of acquired objects
 in get_partial_node()
In-Reply-To: <20130116084114.GA13446@lge.com>
Message-ID: <0000013c43e3bb27-53587f7a-2c14-40a4-9ce9-a15dae10fc48-000000@email.amazonses.com>
References: <1358234402-2615-1-git-send-email-iamjoonsoo.kim@lge.com> <0000013c3ee3b69a-80cfdc68-a753-44e0-ba68-511060864128-000000@email.amazonses.com> <20130116084114.GA13446@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013, Joonsoo Kim wrote:

> In acquire_slab() with mode = 1, we always set new.inuse = page->objects.

Yes with that we signal that we have extracted the objects from the slab.

> So
>
> 		acquire_slab(s, n, page, object == NULL);
>
>                 if (!object) {
>                         c->page = page;
>                         stat(s, ALLOC_FROM_PARTIAL);
>                         object = t;
>                         available =  page->objects - page->inuse;
>
> 			!!!!!! available is always 0 !!!!!!

Correct. We should really count the objects that we extracted in
acquire_slab(). Please update the description to the patch and repost.

Also it would be nice if we had some way to avoid passing a pointer to an
integer to acquire_slab. If we cannot avoid that then ok but it would be
nicer without that.

