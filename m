Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaJTTWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:22:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaJTTWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:22:11 -0400
Date: Mon, 20 Oct 2014 21:21:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        namhyung@kernel.org, acme@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] tools, perf: Add asprintf replacement
Message-ID: <20141020192148.GF9913@krava.brq.redhat.com>
References: <1411774636-6870-1-git-send-email-andi@firstfloor.org>
 <1411774636-6870-9-git-send-email-andi@firstfloor.org>
 <20141020182818.GE9913@krava.brq.redhat.com>
 <CAMuHMdUdSK=ibgLowJcsduWykcfS7JacHO8wOcYb0hMLtKCwpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUdSK=ibgLowJcsduWykcfS7JacHO8wOcYb0hMLtKCwpQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 09:13:58PM +0200, Geert Uytterhoeven wrote:
> On Mon, Oct 20, 2014 at 8:28 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> >> +int vasprintf(char **str, const char *fmt, va_list ap)
> >> +{
> >> +     char buf[1024];
> >
> > could you please make it work for generic buf len?
> 
> The actual size above doesn't matter, except for stack usage.
> It could be 1 (are there any bugs triggered when using zero? ;-).
> The real buffer is allocated by malloc() below.
> 
> >> +     int len = vsnprintf(buf, sizeof buf, fmt, ap);

hum, really? the message is formated in here ^^^
into buffer on stack 'buf[1024]'

> >
> > WARNING: sizeof buf should be sizeof(buf)
> >
> >> +
> >> +     *str = malloc(len + 1);
> >> +     if (!*str)
> >> +             return -1;
> >> +     strcpy(*str, buf);

and copied into allocated buffer in here

the buf size 1024 limits the maximum formated string length to 1024,
which is probably not crossed by current perf usage.. but still making
it generic is not that hard

jirka

> >> +     return len;
> >> +}
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
