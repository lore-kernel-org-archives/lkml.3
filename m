Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3KETz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:55:56 -0500
Received: from smtp-out.abv.bg ([194.153.145.99]:35742 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570Ab3KETzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:55:53 -0500
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=hwF0wQWzgu71xsHcnfAzyO3iWH/U+B4x9JAxmySnlMy+YdtIgDt+/OVmzWc0sYGuc
	Mdx1AWZ1vrzwDerzdzvCxDI4+wEk6uzU35fCm3wC+q044fzdmjEKB7GbbYD8/15wUEt
	UOl9HNA2ys2tf+uUoQ1FAkeL1XTodh7wWeXzLks=
Date: Tue, 5 Nov 2013 21:55:51 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: minchan@kernel.org, pavel@ucw.cz, sre@debian.org, pali.rohar@gmail.com,
        pc+n900@asdf.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <1380566786.52844.1383681351015.JavaMail.apache@mail83.abv.bg>
Subject: Re: OMAPFB: CMA allocation failures
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 46.249.74.23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 




 >-------- Оригинално писмо --------
 >От:  Tomi Valkeinen 
 >Относно: Re: OMAPFB: CMA allocation failures
 >До: Ивайло Димитров
 >Изпратено на: Сряда, 2013, Октомври 30 14:19:32 EET
 >
 >I really dislike the idea of adding the omap vram allocator back. Then
 >again, if the CMA doesn't work, something has to be done.
 >

If I got Minchan Kim's explanation correctly, CMA simply can't be used
for allocation of framebuffer memory, because it is unreliable.

 >Pre-allocating is possible, but that won't work if there's any need to
 >re-allocating the framebuffers. Except if the omapfb would retain and
 >manage the pre-allocated buffers, but that would just be more or less
 >the old vram allocator again.
 >
 >So, as I see it, the best option would be to have the standard dma_alloc
 >functions get the memory for omapfb from a private pool, which is not
 >used for anything else.
 >
 >I wonder if that's possible already? It sounds quite trivial to me.
 
dma_alloc functions use either CMA or (iirc) get_pages_exact if CMA is
disabled. Both of those fail easily. AFAIK there are several 
implementations with similar functionality, like CMEM and ION but
(correct me if I am wrong) neither of them is upstreamed. In the 
current kernel I don't see anything that can be used for the purpose 
of reliable allocation of big chunks of contiguous memory.
So, something should be done, but honestly, I can't think of anything
but bringing VRAM allocator back. Not that I like the idea of bringing
back ~700 lines of code, but I see no other option if omapfb driver is
to be actually useful.

Regards,
Ivo
