Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3JWV7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 17:59:46 -0400
Received: from smtp-out.abv.bg ([194.153.145.99]:37761 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab3JWV7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 17:59:45 -0400
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=fpVu/oFdExQOJVeQDjnOp1fuHGz+3Ds6DI48SxRrzKz1KaY+FBLnPTmXwFFm4NUb6
	HBb61bxiajIGIMmeJ4aGi8HO03knCd5h0x6XLlekBYqqvE8WoFxS3yC2KleGTYCc1C8
	6g/K8eJAq/M/63i9AOeU171jo1FPTeWsXZKnwsw=
Date: Thu, 24 Oct 2013 00:59:42 +0300 (EEST)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: tomi.valkeinen@ti.com
Cc: sre@debian.org, tony@atomide.com, pali.rohar@gmail.com, pc+n900@asdf.org,
        pavel@ucw.cz, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <1296360712.2526.1382565582863.JavaMail.apache@mail82.abv.bg>
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

 Hi,

I wonder if there is any progress on the issue? Do you need me to send more data? Or
should I raise the issue with the CMA maintainer?

Regards,
Ivo

 >-------- Оригинално писмо --------
 >От:  Ивайло Димитров 
 >Относно: Re: OMAPFB: CMA allocation failures
 >До: Tomi Valkeinen 
 >Изпратено на: Сряда, 2013, Октомври 16 09:33:51 EEST
 >
 >
 > Hi Tomi,
 >
 >>I think we should somehow find out what the pages are that cannot be
 >>migrated, and where they come from.
 >>
 >>So there are &amp;quot;anonymous pages without mapping&amp;quot; with page_count(page) !=
 >>1. I have to say I don't know what that means =). I need to find some
 >>time to study the mm.
 >
 >I put some more traces in the point of failure, the result:
 >page_count(page) == 2, page->flags == 0x0008025D, which is:
 >PG_locked, PG_referenced, PG_uptodate, PG_dirty, PG_active, PG_arch_1, PG_unevictable
 >Whatever those mean :). I have no idea how to identify where those pages come from.
 >
 >>Well, as I said, you're the first one to report any errors, after the
 >>change being in use for a year. Maybe people just haven't used recent
 >>enough kernels, and the issue is only now starting to emerge, but I
 >>wouldn't draw any conclusions yet.
 >
 >I am (almost) sure I am the first one to test video playback on OMAP3 with DSP video
 >acceleration, using recent kernel and Maemo5 on n900 :). So there is high probability the
 >issue was not reported earlier because noone have tested it thoroughly after the change.
 >
 >>If the CMA would have big generic issues, I think we would've seen
 >>issues earlier. So I'm guessing it's some driver or app in your setup
 >>that's causing the issues. Maybe the driver/app is broken, or maybe that
 >>specific behavior is not handled well by CMA. In both case I think we
 >>need to identify what that driver/app is.
 >
 >What I know is going on, is that there is heavy fs I/O at the same time - there is
 >a thumbnailer process running in background which tries to extract thumbnails of all video
 >files in the system. Also, there are other processes doing various jobs (e-mail fetching, IM
 >accounts login, whatnot). And in addition Xorg mlocks parts of its address space. Of course
 >all this happens with lots of memory being swapped in and out. I guess all this is related.
 >
 >However, even after the system has settled, the CMA failures continue to happen. It looks like
 >some pages are allocated from CMA which should not be.
 >
 >>I wonder how I could try to reproduce this with a generic omap3 board...
 >
 >I can always reproduce it here (well, not on generic board, but I guess it is even better to
 >test in real-life conditions), so if you need some specific tests or traces or whatever, I
 >can do them for you.
 >
 >Regards,
 >Ivo
 >
