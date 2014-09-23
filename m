Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbaIWVsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:48:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:50257 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbaIWVsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:48:04 -0400
Date: Tue, 23 Sep 2014 23:47:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "LF.Tan" <lftan.linux@gmail.com>
cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for
 !CONFIG_SMP
In-Reply-To: <CAFiDJ5-b_P7aWFXYP4GcgTUb3t_j6dZCsjeGZwVUs+7qo0v-GA@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1409232335500.4604@nanos>
References: <1410168160-3624-1-git-send-email-lftan@altera.com> <1410168160-3624-2-git-send-email-lftan@altera.com> <CAFiDJ5-b_P7aWFXYP4GcgTUb3t_j6dZCsjeGZwVUs+7qo0v-GA@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, LF.Tan wrote:
> On Mon, Sep 8, 2014 at 5:22 PM, Ley Foon Tan <lftan@altera.com> wrote:
> > Follow m68k futex implementation for !CONFIG_SMP.

Great. Follow arch/random implementation blindly and copy all the bugs
in it.

> > +static inline int
> > +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> > +                             u32 oldval, u32 newval)
> > +{
> > +       u32 val;
> > +
> > +       if (unlikely(get_user(val, uaddr) != 0))
> > +               return -EFAULT;
> > +
> > +       if (val == oldval && unlikely(put_user(newval, uaddr) != 0))
> > +               return -EFAULT;
> > +
> > +       *uval = val;
> > +
> > +       return 0;
> > +}

Care to explain how this works reliably and resembles proper cmpxchg
semantics under all circumstances?

Thanks,

	tglx
