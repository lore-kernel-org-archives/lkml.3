Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbaKPSwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 13:52:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:58520 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaKPSwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 13:52:12 -0500
Date: Sun, 16 Nov 2014 19:52:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
In-Reply-To: <CAE9FiQVAWYdZvq3QDn-=06QX0+H=RynSS+VVmvTyAaU1BECR_g@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411161947540.3909@nanos>
References: <20141114204517.GA24402@www.outflux.net> <CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com> <CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com> <CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
 <CAE9FiQVAWYdZvq3QDn-=06QX0+H=RynSS+VVmvTyAaU1BECR_g@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014, Yinghai Lu wrote:

> On Fri, Nov 14, 2014 at 6:46 PM, Kees Cook <keescook@chromium.org> wrote:
> > On Fri, Nov 14, 2014 at 6:29 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> 
> >> should use attached one instead.
> >>
> >> 1. should use _brk_end instead of &end, as we only use partial of
> >>    brk.
> >> 2. [_brk_end, pm_end) page range is already converted. aka
> >>    is not wasted.
> >
> > Are you sure? For me, _brk_end isn't far enough:
> >
> > [    1.475572] all_end: 0xffffffff82df5000
> > [    1.476736] _brk_end: 0xffffffff82dd6000
> 
> Yes. _brk_end should be small then &_end.

Wrong. _brk_end can move up to _end, i.e. to __brk_limit.
 
But it's safe to use _brk_end when mark_rodata_ro() is called because
extend_brk() is gone already at that point.

Thanks,

	tglx
