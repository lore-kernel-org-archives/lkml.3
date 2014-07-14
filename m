Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaGNPPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:15:15 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:49705
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756376AbaGNPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:14:00 -0400
Date: Mon, 14 Jul 2014 10:13:56 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <a.ryabinin@samsung.com>,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH -next 00/21] Address sanitizer for kernel (kasan) -
 dynamic memory error detector.
In-Reply-To: <CAPAsAGwb2sLmu0o_o-pFP5pXhMs-1sZSJbA3ji=W+JPOZRepgg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1407141012520.25405@gentwo.org>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com> <53C08876.10209@zytor.com> <CAPAsAGwb2sLmu0o_o-pFP5pXhMs-1sZSJbA3ji=W+JPOZRepgg@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2014, Andrey Ryabinin wrote:

> > How does that work when memory is sparsely populated?
> >
>
> Sparsemem configurations currently may not work with kasan.
> I suppose I will have to move shadow area to vmalloc address space and
> make it (shadow) sparse too if needed.

Well it seems to work with sparsemem / vmemmap? So non vmmemmapped configs
of sparsemem only. vmemmmap can also handle holes in memory.

