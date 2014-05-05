Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaEETQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:16:21 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:36110 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaEETQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:16:19 -0400
Date: Mon, 5 May 2014 21:16:03 +0200
From: =?UTF-8?B?Q2zDqW1lbnQ=?= Calmels <clement.calmels@free.fr>
To: Greg KH <greg@kroah.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: correct coding style issue
Message-ID: <20140505211603.4e3b6f42@gromit>
In-Reply-To: <20140504212658.GA28438@kroah.com>
References: <1399233129-13436-1-git-send-email-clement.calmels@free.fr>
	<20140504212658.GA28438@kroah.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2014 17:26:58 -0400
Greg KH <greg@kroah.com> wrote:

> On Sun, May 04, 2014 at 09:52:09PM +0200, Clément Calmels wrote:
> > Remove C99 comment and rewrite lines over 80 characters.
> > Warnings and error found by checkpatch.pl script.
> > 
> > Signed-off-by: Clément Calmels <clement.calmels@free.fr>
> > ---
> >  drivers/staging/vt6655/tmacro.h | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/vt6655/tmacro.h
> > b/drivers/staging/vt6655/tmacro.h index 59c6e72..264c6ed 100644
> > --- a/drivers/staging/vt6655/tmacro.h
> > +++ b/drivers/staging/vt6655/tmacro.h
> > @@ -44,17 +44,22 @@
> >  #define LOWORD(d)           ((unsigned short)(d))
> >  #endif
> >  #if !defined(HIWORD)
> > -#define HIWORD(d)           ((unsigned short)((((unsigned
> > long)(d)) >> 16) & 0xFFFF)) +#define
> > HIWORD(d)							\
> > +	((unsigned short)((((unsigned long)(d)) >> 16) & 0xFFFF))
> >  #endif
> >  
> >  #define LODWORD(q)          ((q).u.dwLowDword)
> >  #define HIDWORD(q)          ((q).u.dwHighDword)
> >  
> >  #if !defined(MAKEWORD)
> > -#define MAKEWORD(lb, hb)    ((unsigned short)(((unsigned
> > char)(lb)) | (((unsigned short)((unsigned char)(hb))) << 8)))
> > +#define MAKEWORD(lb, hb)\
> > +	((unsigned short)(((unsigned
> > char)(lb))				\
> > +			  | (((unsigned short)((unsigned
> > char)(hb))) << 8))) #endif
> >  #if !defined(MAKEDWORD)
> > -#define MAKEDWORD(lw, hw)   ((unsigned long)(((unsigned
> > short)(lw)) | (((unsigned long)((unsigned short)(hw))) << 16)))
> > +#define MAKEDWORD(lw, hw)\
> > +	((unsigned long)(((unsigned
> > short)(lw))				\
> > +			 | (((unsigned long)((unsigned
> > short)(hw))) << 16))) #endif
> >  
> > -#endif // __TMACRO_H__
> > +#endif /* __TMACRO_H__ */
> 
> Why not just switch to use the built-in macros the kernel provides for
> this?
> 
> greg k-h

Are you talking about changing types (unsigned char => u8) as used
there:
http://lxr.free-electrons.com/source/sound/isa/msnd/msnd.h#L182 or
there:
http://lxr.free-electrons.com/source/include/acpi/actypes.h#L481 ?

C.

