Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaJPH7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:59:07 -0400
Received: from mailsec115.isp.belgacom.be ([195.238.20.111]:35976 "EHLO
	mailsec115.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbaJPH7F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:59:05 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=cGhLeOE9I35BcZRK2zxy3BlNJEt3JpyFGdx+8CmfgKw= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8 a=wB7cQFJJUG_CQzCQTDkA:9
 a=QEXdDO2ut3YA:10 a=K6kUPx8HyhEA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgYPAOt5P1TD7hTU/2dsb2JhbAAZAUGDDoErgwa1NAabHQKBEBYBfYQCAQEBAwEjVgULBQQCGAICGA4CAlcGExGIJQyXQjScT4Z/jhQBAQgCAR+BLIR2iXkzB4J3gVQFnwWLNIU5g36CNIFFOy+CSgEBAQ
Date: Thu, 16 Oct 2014 09:59:04 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Message-ID: <1884722160.6037.1413446344204.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1413305557.3269.21.camel@joe-AO725>
References: <1413305085-7318-1-git-send-email-fabf@skynet.be> <1413305557.3269.21.camel@joe-AO725>
Subject: Re: [PATCH 1/1 linux-next] fs/jffs2/nodelist.h: remove unnecessary
 __constant_ prefix
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 14 October 2014 at 18:52 Joe Perches <joe@perches.com> wrote:
>
>
> On Tue, 2014-10-14 at 18:44 +0200, Fabian Frederick wrote:
> > See commit fbdb8138cf0c
> > ("checkpatch: warn on uses of __constant_ functions")
>
> Perhaps it'd be better to use the same
> __builtin_constant_p test as swab.h and use
> just one pattern instead
>
> > diff --git a/fs/jffs2/nodelist.h b/fs/jffs2/nodelist.h
> > index fa35ff7..9f0d547 100644
> > --- a/fs/jffs2/nodelist.h
> > +++ b/fs/jffs2/nodelist.h
> > @@ -48,8 +48,8 @@
> >  #define cpu_to_je32(x) ((jint32_t){cpu_to_be32(x)})
> >  #define cpu_to_jemode(x) ((jmode_t){cpu_to_be32(os_to_jffs2_mode(x))})
> > 
> > -#define constant_cpu_to_je16(x) ((jint16_t){__constant_cpu_to_be16(x)})
> > -#define constant_cpu_to_je32(x) ((jint32_t){__constant_cpu_to_be32(x)})
> > +#define constant_cpu_to_je16(x) ((jint16_t){cpu_to_be16(x)})
> > +#define constant_cpu_to_je32(x) ((jint32_t){cpu_to_be32(x)})
>
> So none of these constant_ things would be here
> at all.

I guess you're talking about include/uapi/linux/swab.h eg       
#define __swab16(x)                             \
(__builtin_constant_p((__u16)(x)) ?     \
___constant_swab16(x) :                 \
__fswab16(x))

As your commit fbdb8138cf0c states

("Emit a warning when using any of these __constant_ forms:")

There's no need for __constant outside include/uapi.
So maybe we could just remove all #define constant_cpu_to_xxx
and always call cpu_to_xxx from jffs2 instead ?

Fabian
>
>
