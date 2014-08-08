Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbaHHPIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:08:40 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:35620 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaHHPIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:08:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1408080943280.16459@gentwo.org>
References: <1407481239-7572-1-git-send-email-iamjoonsoo.kim@lge.com>
	<alpine.DEB.2.11.1408080943280.16459@gentwo.org>
Date: Fri, 8 Aug 2014 17:08:37 +0200
X-Google-Sender-Auth: r9MVPYDBFQKB5q-QgfwNpsLxoLE
Message-ID: <CAMuHMdVZdaVeYY=A=eVEC67GGyQNq2XZ8wN3fk0+ywtkoa6EmA@mail.gmail.com>
Subject: Re: [PATCH for v3.17-rc1] Revert "slab: remove BAD_ALIEN_MAGIC"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 4:44 PM, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 8 Aug 2014, Joonsoo Kim wrote:
>
>> This reverts commit a640616822b2 ("slab: remove BAD_ALIEN_MAGIC").
>
> Lets hold off on this one. I am bit confused as to why a non NUMA system
> would have multiple NUMA nodes.

DISCONTIGMEM

mm/Kconfig:

#
# Both the NUMA code and DISCONTIGMEM use arrays of pg_data_t's
# to represent different areas of memory.  This variable allows
# those dependencies to exist individually.
#
config NEED_MULTIPLE_NODES
        def_bool y
        depends on DISCONTIGMEM || NUMA

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
