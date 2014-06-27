Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaF0Gin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:38:43 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:41641 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbaF0Gim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:38:42 -0400
Date: Fri, 27 Jun 2014 15:38:15 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Jeroen Hofstee <jeroen@myspectrum.nl>
Subject: Re: [U-Boot] [RFC] kbuild.h: workaround for llvm IAS
Cc: u-boot@lists.denx.de, linux-kernel@vger.kernel.org
In-Reply-To: <53A9D326.9060409@myspectrum.nl>
References: <20140624215349.3E89.AA925319@jp.panasonic.com> <53A9D326.9060409@myspectrum.nl>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140627153815.7B85.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeroen,


On Tue, 24 Jun 2014 21:36:06 +0200
Jeroen Hofstee <jeroen@myspectrum.nl> wrote:

> >> KBuild (ab)uses the asm statement to write to a file and
> >> llvm integrated as chokes about these invalid asm statements.
> >> Workaround it by making it look like valid asm code.
> >>
> >> Signed-off-by: Jeroen Hofstee <jeroen@myspectrum.nl>
> > I think Linux has the same problem.
> >
> > Are you willing to this patch to linux-kbuild ML?
> > Or fixing U-Boot only?
> I don't mind in general, but it is just noise for them (cc-ing them to
> create some).  For u-boot (ARM) you actually get a valid binary with
> this patch after clang support has landed, for linux you just get other
> errors as far as I tried (native only), patch below.
> 
> However in linux there seem more spots relying on the format, e.g.
>      arch/ia64/kvm/Makefile
>      arch/ia64/kernel/Makefile
>      arch/um/Makefile
> 
> So if anything, I think this should be made a general rules first
> in the makefiles. It seems stupid to potentially break something
> while it gains nothing.
> 
> So yes, u-boot only afaic, or does that make your syncing more difficult?

I don't think syncing would be difficult.

BTW, do you know how they resolve this build error in other projects,
for example, in llvmlinux ?
http://llvm.linuxfoundation.org/index.php/Main_Page

Linux folks merged Clang support into the top Makefile, but not into ./Kbuild.
I don't know why.


Best Regards
Masahiro Yamada

