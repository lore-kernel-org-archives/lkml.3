Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaG1RcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:32:00 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41020 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaG1Rb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:31:58 -0400
Date: Mon, 28 Jul 2014 10:31:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pramod Gurav <pramod.gurav.etc@gmail.com>
Cc: linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Brown <broonie@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] input: ads7846: Switch to managed version of kzalloc and
 cleanups
Message-ID: <20140728173154.GC8982@core.coreip.homeip.net>
References: <1406537216-25936-1-git-send-email-pramod.gurav@smartplayin.com>
 <20140728164935.GA8982@core.coreip.homeip.net>
 <CAMf-jSmHpRLOOcmmW7qOPbwUv3oCtJMvFcqP2LVObE9qQL+D9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMf-jSmHpRLOOcmmW7qOPbwUv3oCtJMvFcqP2LVObE9qQL+D9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 10:37:18PM +0530, Pramod Gurav wrote:
> Thanks Dmitry for reviewing.
> 
> On Mon, Jul 28, 2014 at 10:19 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Pramod,
> >
> > On Mon, Jul 28, 2014 at 02:16:55PM +0530, pramod.gurav.etc@gmail.com wrote:
> >> From: Pramod Gurav <pramod.gurav@smartplayin.com>
> >>
> >> This switches memory allocations from kzalloc to devm_kzalloc.
> >> This also changes the way return checks were done on failure cases
> >> of three allocations. The checks were clubbed together and hence
> >> must be done seperately to avoid calling kfree on unallocated memory.
> >>
> >> Moreover in case of input_allocate_device failure, we were calling
> >> input_free_device which is not needed.
> >
> > But not hurting either - like kfree() and many other "cleanup" functions
> > in kernel they are happily accept NULL input (so that cleanup code is
> > less branchy).
> >>
> Great. Good to learn.
> >> input device must be released(input_free_device) when ads7846_probe_dt
> >> fails hence adds a fix there as well.
> >
> > That is the real bug, could you send me a patch that fixes just that (by
> > jumping to err_free_mem)?
> Sure I will.
> 
> >
> > The rest I'd like to leave as is unless you can convert _all_ resources
> > to be managed ones: mixing up 2 styles (manual and automatic release) is
> > bound to have issues (like we had with ads7846_probe_dt which assumed
> > that since it was releasing its resources automatically the rest would
> > be released automatically as well.
> 
> I thought I would use a managed input_device allocation in a separate patch.
> I will convert all allocations to managed then.
> 
> This driver also registers a irq. You suggest to convert it to managed as well?
> I was planning to do that?

Yes. And regulators, gpios, sysfs (you might need to have custom action
for that) and chip cleanup. OTOH I do not see much value in these
conversions unless they make the code much more clean.

Thanks,

-- 
Dmitry
