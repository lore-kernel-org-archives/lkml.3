Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaGaAKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:10:53 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48642 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbaGaAKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:10:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140730035731.GE16537@localhost>
References: <20140730035731.GE16537@localhost>
Date: Wed, 30 Jul 2014 17:10:50 -0700
Message-ID: <CAPcyv4gSrg310RFqNzERh2dse9HCAfkGLSR5OP04TCMNC8mg9A@mail.gmail.com>
Subject: Re: [xhci] kernel BUG at include/linux/scatterlist.h:115!
From: Dan Williams <dan.j.williams@intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 8:57 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Greetings,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/usb.git td-fragments-v1
> commit 61d9c2ad31b11b87c319bbc2a963040742bac77c
> Author:     Dan Williams <dan.j.williams@intel.com>
> AuthorDate: Tue Jul 22 00:08:51 2014 -0700
> Commit:     Dan Williams <dan.j.williams@intel.com>
> CommitDate: Thu Jul 24 18:12:38 2014 -0700
>
>     xhci: unit test ring enqueue/dequeue routines
>
>     Given the complexity of satisfying xhci 1.0+ host trb boundary
>     constraints, provide a test case that exercises inserting mid-segment
>     links into a ring.
>
>     The linker --wrap= option is used to not pollute the global identifier
>     space and to make it clear which standard xhci driver routines are being
>     mocked-up.  The --wrap= option does not come into play when both
>     xhci-hcd and xhci-test are built-in to the kernel, so namespace
>     collisions are prevented by excluding xhci-test from the build when
>     xhci-hcd is built-in.
>
>     It's unfortunate that this is an in-kernel test rather than userspace
>     and that the infrastructure is custom rather than generic.  That said,
>     it serves its purpose of exercising the corner cases of the scatterlist
>     parsing implementation in xhci.
>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks like I either need specify valid addresses to sg_set_buf(), or
just make the unit test depend on !CONFIG_DEBUG_SG.  I'll go with the
latter since this test is not about scatterlist api correctness and
there's nothing to be gained by unwinding virt_addr_valid()
requirements for this.
