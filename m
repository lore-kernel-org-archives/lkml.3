Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbaEMKWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:22:02 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55699 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760245AbaEMKV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:21:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: James Hogan <james.hogan@imgtec.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
Date: Tue, 13 May 2014 12:21:40 +0200
Message-ID: <4465265.lUhYuYrZG4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ58w31gm_z3Y1Q6ZREQPW4F6uVB+vy3X1r_3kLgaEE3O1w@mail.gmail.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <5371EAEB.5030100@imgtec.com> <CAFiDJ58w31gm_z3Y1Q6ZREQPW4F6uVB+vy3X1r_3kLgaEE3O1w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dj0NZQNQMqdlt1T6aFiWWGjC7RscqJVDPnXnj8VIQZK
 LCUIu0MZWFDgWClTurdJJj+lJ4R8lRjZHhS4RGbmivgJRB5lNG
 2kMlTH0CU5Yq/aIjRWzl2v0ODYYJwPk5EkhYz3/ve0zafMJgk6
 iQaITMVawneuCj/2pAMF3iYPX/s7rS/6FTsc2Up6tVrgwtzAHu
 rCP/sXYUQTSD7tnaMW3RQ1bm5TqniHYT10dryg1FpNzHFLJyBC
 hN2HGWkw76lYAq5u9+0kOVcoPMlObXlO/X2Dx9FkboDX39NJVw
 JSwpUxLvlam/p6Aru1AHWhzie/cQQFUeNAE9qDe+hHS2wGkVkB
 vy+DpwNRQ8tHmSpFzDOI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 18:17:40 Ley Foon Tan wrote:
> On Tue, May 13, 2014 at 5:50 PM, James Hogan <james.hogan@imgtec.com> wrote:
> > Hi,
> >
> > On 13/05/14 10:32, Ley Foon Tan wrote:
> >> On Tue, May 13, 2014 at 5:15 PM, James Hogan <james.hogan@imgtec.com> wrote:
> >>> On 13 May 2014 10:02, Ley Foon Tan <lftan@altera.com> wrote:
> >>>>  /*
> >>>> + * Use 64 bit time_t and clock_t as default. 32 bit users can provide an override to
> >>>> + * define these as "long" if needed.
> >>>> + */
> >>>> +#ifndef __kernel_time_t
> >>>> +typedef long long      __kernel_time_t;
> >>>> +#endif
> >>>> +
> >>>> +#ifndef __kernel_clock_t
> >>>> +typedef long long      __kernel_clock_t;
> >>>> +#endif
> >>>
> >>> I think having this as the first patch in the series will break
> >>> bisection for existing 32-bit arches. This needs to be done in such a
> >>> way that at no intermediate commit are __kernel_time_t or
> >>> __kernel_clock_t the wrong size for existing arches, e.g. by having a
> >>> first patch which makes the typedefs conditional but leaves them as
> >>> __kernel_long_t, and a final patch that changes the default after all
> >>> the arches have got their overrides in place.
> >>
> >> Your suggestion is something as below?
> >
> > Yeh, although I like Thomas' idea better, then each existing 32-bit arch
> > can just select the Kconfig symbol to get the smaller type.
> >
> > IIRC Kconfig won't even complain if you select a symbol which doesn't
> > exist yet.
> When we export this posix_types.h file for user software, they need to
> define this config, eg: CONFIG_32BIT_TIME to use 32 bit time. Is this
> what we want to do?

No, this doesn't really work: You can't use CONFIG_* symbols in
user-visible header files.

	Arnd
