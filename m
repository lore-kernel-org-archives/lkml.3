Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbaHHOLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:11:23 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:58872
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535AbaHHOLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:11:21 -0400
Date: Fri, 8 Aug 2014 09:11:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: BUG: enable_cpucache failed for radix_tree_node, error 12 (was:
 Re: [PATCH v3 9/9] slab: remove BAD_ALIEN_MAGIC)
In-Reply-To: <CAMuHMdWNNuPgDsjM1eM0uo2090-6OxAX8Kfw8Pcd2zo5G6zPkw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1408080909480.16459@gentwo.org>
References: <CAMuHMdW2kb=EF-Nmem_gyUu=p7hFOTe+Q2ekHh41SaHHiWDGeg@mail.gmail.com> <CAAmzW4MX2birtCOUxjDdQ7c3Y+RyVkBt383HEQ=XFgnhhOsQPw@mail.gmail.com> <CAMuHMdVC8aYwDEHnntshdVA24Nx3qAUXZfeRQNGqj=J6eExU-Q@mail.gmail.com> <CAAmzW4NWnMeO+Z3CQ=9Z7rUFLaPmR-w0iMhxzjO+PVgVu7OMuQ@mail.gmail.com>
 <20140808071903.GD6150@js1304-P5Q-DELUXE> <CAMuHMdVHmmct=BC=WXFJWeizYp+S706WjvNi=powYsJkarKUhw@mail.gmail.com> <alpine.DEB.2.11.1408080649430.14841@gentwo.org> <CAMuHMdWNNuPgDsjM1eM0uo2090-6OxAX8Kfw8Pcd2zo5G6zPkw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2014, Geert Uytterhoeven wrote:

> > Ok this is broken on m68k. CONFIG_NUMA is required for this to work. If
> > the arch code does this despite !CONFIG_NUMA then lots of things should
> > break.
>
> Can you please elaborate? We've been using for years...

!CONFIG_NUMA leads to the assumption of a system with a single node in
numerous places.

F.e. in include/linux/mm.h:


static inline int zone_to_nid(struct zone *zone)
{
#ifdef CONFIG_NUMA
        return zone->node;
#else
        return 0;
#endif
}


