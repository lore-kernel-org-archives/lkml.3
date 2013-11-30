Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3K3KA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 05:00:29 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:42423 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3K3KA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 05:00:28 -0500
Message-ID: <A5506022381E423385022F79B40C6FAB@ivogl>
From: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: "Tomi Valkeinen" <tomi.valkeinen@ti.com>
Cc: <minchan@kernel.org>, <pavel@ucw.cz>, <sre@debian.org>,
        <pali.rohar@gmail.com>, <pc+n900@asdf.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <1847426616.52843.1383681351015.JavaMail.apache@mail83.abv.bg>
Subject: Re: OMAPFB: CMA allocation failures
Date: Sat, 30 Nov 2013 12:00:25 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

----- Original Message ----- 
From: "Ивайло Димитров" <freemangordon@abv.bg>
To: "Tomi Valkeinen" <tomi.valkeinen@ti.com>
Cc: <minchan@kernel.org>; <pavel@ucw.cz>; <sre@debian.org>; 
<pali.rohar@gmail.com>; <pc+n900@asdf.org>; <linux-kernel@vger.kernel.org>; 
<linux-mm@kvack.org>
Sent: Tuesday, November 05, 2013 9:55 PM
Subject: Re: OMAPFB: CMA allocation failures


>
>
>
>
>
> >-------- Оригинално писмо --------
> >От:  Tomi Valkeinen
> >Относно: Re: OMAPFB: CMA allocation failures
> >До: Ивайло Димитров
> >Изпратено на: Сряда, 2013, Октомври 30 14:19:32 EET
> >
> >I really dislike the idea of adding the omap vram allocator back. Then
> >again, if the CMA doesn't work, something has to be done.
> >
>
> If I got Minchan Kim's explanation correctly, CMA simply can't be used
> for allocation of framebuffer memory, because it is unreliable.
>
> >Pre-allocating is possible, but that won't work if there's any need to
> >re-allocating the framebuffers. Except if the omapfb would retain and
> >manage the pre-allocated buffers, but that would just be more or less
> >the old vram allocator again.
> >
> >So, as I see it, the best option would be to have the standard dma_alloc
> >functions get the memory for omapfb from a private pool, which is not
> >used for anything else.
> >
> >I wonder if that's possible already? It sounds quite trivial to me.
>
> dma_alloc functions use either CMA or (iirc) get_pages_exact if CMA is
> disabled. Both of those fail easily. AFAIK there are several
> implementations with similar functionality, like CMEM and ION but
> (correct me if I am wrong) neither of them is upstreamed. In the
> current kernel I don't see anything that can be used for the purpose
> of reliable allocation of big chunks of contiguous memory.
> So, something should be done, but honestly, I can't think of anything
> but bringing VRAM allocator back. Not that I like the idea of bringing
> back ~700 lines of code, but I see no other option if omapfb driver is
> to be actually useful.
>
> Regards,
> Ivo 

