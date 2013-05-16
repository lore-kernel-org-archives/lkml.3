Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3EPQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:09:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:44169 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab3EPQJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:09:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,684,1363158000"; 
   d="scan'208";a="314714171"
Subject: Re: linux-next: Tree for May 15 (crypto /crct10dif)
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Xiong Zhou <jencce.kernel@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
References: <20130515132627.817585a3d9fb3a3e502eb586@canb.auug.org.au>
	 <5193CCEC.7070909@infradead.org>
	 <alpine.DEB.2.02.1305161152530.31865@M2420>
	 <CAMuHMdUmD2DMNeezetHNbe9DgQXpTN4BEfEmJSztyzCivQpyXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 May 2013 09:09:54 -0700
Message-ID: <1368720594.27102.273.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 09:22 +0200, Geert Uytterhoeven wrote:
> On Thu, May 16, 2013 at 5:57 AM, Xiong Zhou <jencce.kernel@gmail.com> wrote:
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -378,6 +378,7 @@ config CRYPTO_CRC32_PCLMUL
> >
> >  config CRYPTO_CRCT10DIF
> >         tristate "CRCT10DIF algorithm"
> > +       depends on CRC_T10DIF
> 
> This is a library symbol, so "select CRC_T10DIF"?
> 

I think "depends on" CRC_T10DIF is okay.  This generic transform is not
needed if we are not using the T10-DIF library.  It is meant for
wrapping the library call to t10-dif as a crypto transform.

> >         select CRYPTO_HASH
> >         help
> >           CRC T10 Data Integrity Field computation is being cast as
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


