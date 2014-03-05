Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaCEQjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:39:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbaCEQjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:39:13 -0500
Message-ID: <1394037524.5094.35.camel@deneb.redhat.com>
Subject: Re: [PATCH 5/5] arm64: add early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linaro Patches <patches@linaro.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 05 Mar 2014 11:38:44 -0500
In-Reply-To: <CAL_JsqLQ8gj4nkwh+67i58rQBARoh_CgZ+4D9uepdBQm-XBwJA@mail.gmail.com>
References: <1393963738-9210-1-git-send-email-msalter@redhat.com>
	 <1393963738-9210-6-git-send-email-msalter@redhat.com>
	 <CAL_JsqLQ8gj4nkwh+67i58rQBARoh_CgZ+4D9uepdBQm-XBwJA@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 17:31 -0600, Rob Herring wrote:
> On Tue, Mar 4, 2014 at 2:08 PM, Mark Salter <msalter@redhat.com> wrote:
> > Add support for early IO or memory mappings which are needed
> > before the normal ioremap() is usable. This also adds fixmap
> > support for permanent fixed mappings such as that used by the
> > earlyprintk device register region.
> 
> One minor comment:
> 
> > +enum fixed_addresses {
> > +       FIX_EARLYCON,
> 
> Can you align this name with x86 and rename to FIX_EARLYCON_MEM_BASE.
> Doing that will help enable the earlycon driver in 8250_early.c.

Is there any advantage to earlycon=uart8250 vs. earlyprintk=uart8250?
I don't mind using FIX_EARLYCON_MEM_BASE, but CONFIG_FIX_EARLYCON_MEM
is X86 only right now and I think changing that should be a separate
patch.


