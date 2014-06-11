Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaFKSom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:44:42 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:37188 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbaFKSok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:40 -0400
Date: Wed, 11 Jun 2014 20:44:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86,vdso,kbuild: Fix vdso_install
Message-ID: <20140611184422.GA13296@ravnborg.org>
References: <5398749B.4090209@zytor.com>
 <cover.1402503408.git.luto@amacapital.net>
 <20140611163628.GA12685@ravnborg.org>
 <CA+5PVA5hScqZ3=86aUqot_2ojHhBNa2PuUTyUZfcCH4nYxP2bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5hScqZ3=86aUqot_2ojHhBNa2PuUTyUZfcCH4nYxP2bg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:41:56PM -0400, Josh Boyer wrote:
> On Wed, Jun 11, 2014 at 12:36 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Wed, Jun 11, 2014 at 09:20:05AM -0700, Andy Lutomirski wrote:
> >> This changes kbuild slightly because I didn't want to fight with using
> >> static pattern rules and extra obfuscated fake targets just to write a
> >> loop.
> >
> > What are you trying to fix with this?
> >
> > On my box (32 bit Intel) "make MODLIB=~/mod vdso_install"
> > works as expected.
> > Two *.so files are installed as a copy of the so.dbg files.
> 
> With what tree?
Linus latest - yes.

>  With Linus' latest, I reported an error because
> commit 6f121e548f83674ab4920a4e60afb58d4f61b829 breaks the
> vdso_install target.
This is your bug-report: http://marc.info/?l=linux-kernel&m=140249607823283&w=2

+ make -s ARCH=x86_64
INSTALL_MOD_PATH=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.16.0-0.rc0.git1.1.fc21.x86_64
vdso_install KERNELRELEASE=3.16.0-0.rc0.git1.1.fc21.x86_64
make[1]: *** No rule to make target `arch/x86/vdso/vdso.so.dbg',
needed by `vdso.so'.  Stop.
make: *** [vdso_install] Error 2

I am building for i386 which is why I do not see the bug.

	Sam
