Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3JBXjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 19:39:19 -0400
Received: from mout.web.de ([212.227.15.4]:58885 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab3JBXjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:39:17 -0400
From: Martin Walch <walch.martin@web.de>
To: David Rientjes <rientjes@google.com>, linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] kconfig: add short explanation to SYMBOL_WRITE
Date: Thu, 03 Oct 2013 01:39:13 +0200
Message-ID: <2034014.asIXrEbcsn@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
In-Reply-To: <alpine.DEB.2.02.1310012236360.5682@chino.kir.corp.google.com>
References: <4542076.yVG8YKgu5r@tacticalops> <alpine.DEB.2.02.1310012236360.5682@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:u/Zd4mXTmIR0KDoc+LJfYw6v9paOzs1eN2WGnYCUJXJ7P/kr4FU
 etxxrLvVG0GxgcSdNivo4Nb/wELqDOgmeOC9EIIJ8WcCPc6LQxW7D+aRhS/ASJ61Ktxa3Jh
 r5QPwkNJ9dF//Twp9JbAEPH5DfxhmL/ZqKGEpomZEYRwQnQN8IueQPma98EAgoy9hL1ziAb
 0j0YXL+9f1ZF96pFA3xUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
> > index df198a5..ba663e1 100644
> > --- a/scripts/kconfig/expr.h
> > +++ b/scripts/kconfig/expr.h
> > @@ -93,7 +93,7 @@ struct symbol {
> >  #define SYMBOL_CHOICEVAL  0x0020  /* used as a value in a choice block */
> >  #define SYMBOL_VALID      0x0080  /* set when symbol.curr is calculated */
> >  #define SYMBOL_OPTIONAL   0x0100  /* choice is optional - values can be 'n' */
> > -#define SYMBOL_WRITE      0x0200  /* ? */
> > +#define SYMBOL_WRITE      0x0200  /* write symbol to file (KCONFIG_CONFIG) */
> >  #define SYMBOL_CHANGED    0x0400  /* ? */
> >  #define SYMBOL_AUTO       0x1000  /* value from environment variable */
> >  #define SYMBOL_CHECKED    0x2000  /* used during dependency checking */
> 
> Perhaps stating that the choice is writable by the user?

As far as I understand SYMBOL_WRITE, its main purpose is in the function
conf_write in confdata.c:

>if (!(sym->flags & SYMBOL_WRITE))
>	goto next;
>sym->flags &= ~SYMBOL_WRITE;
>
>conf_write_symbol(out, sym, &kconfig_printer_cb, NULL);

So, if I have not missed anything, SYMBOL_WRITE decides whether to write a symbol
to .config or not. This does not necessarily mean that the user can change the value.
SYMBOL_WRITE may be set and the symbol may be written to .config while the user
does not even see the corresponding prompt.
