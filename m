Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaIBGeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 02:34:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33464 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaIBGeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:34:07 -0400
Date: Tue, 2 Sep 2014 08:33:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140902063354.GA32105@nazgul.tnic>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140831194548.GA12628@khazad-dum.debian.net>
 <54037C07.8060703@zytor.com>
 <20140831201126.GB12628@khazad-dum.debian.net>
 <20140901051302.GA28402@nazgul.tnic>
 <5404A035.3070707@zytor.com>
 <20140901174322.GA15533@khazad-dum.debian.net>
 <ea40f7c4-ec8d-4be5-8f8c-bbd11ab07252@email.android.com>
 <20140901195921.GA18675@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140901195921.GA18675@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 04:59:21PM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 01 Sep 2014, H. Peter Anvin wrote:
> > No, it is worse to rename it and have older kernels behave differently.
> > Kernel options are basically super obscure to most people anyway.
> 
> Ok, so rename is out, although as long as the rename was accepted for
> 3.16-stable, it would be just 3.16 and 3.16.1 (and maybe 3.16.2) that would
> not have the new name.
> 
> Options left are "keep it as is", or "add new and [optionally] deprecate
> old".  I can't really tell for sure which one you'd prefer from your
> previous answer.

Let me answer to all the concerns here:

* the parameter is not in kernel-parameters.txt for the simple reason
that we don't want people to disable ucode loaders left and right.
The absolutely normal, 99% situation should be loading works fine or
we don't load the ucode at all - this option is only for the very,
very, very! obscure and strange situation where we want to rule out any
microcode interference. Just in case.

This situation should almost never happen.

* The param naming could be argued about - maybe it is ugly and
unreadable for that same reason.

> This can be a very big deal when things go wrong: it is hard for the
> regular user to recover from an initramfs image that crashes the
> system, and the early initramfs has no "disable" trigger.

This maybe is a serious problem but disabling microcode loading is not
the proper solution. If the microcode in the initrd is corrupted, it
should simply not get loaded and system should continue as much as it
can - it *should* *not* be a requirement to disable the ucode loader in
order to workaround corrupted initrds.

And frankly, I'm trying to imagine how a corrupted microcode in an
initrd would ever fail the booting. So Henrique, if you have something
which is *not* hypothetical, please say so. It needs to be fixed
properly and not with disabling the ucode loader.

-- 
Regards/Gruss,
    Boris.
--
