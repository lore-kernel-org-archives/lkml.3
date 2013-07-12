Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab3GLK52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:57:28 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55858 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab3GLK50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:57:26 -0400
Date: Fri, 12 Jul 2013 11:57:21 +0100
From: Robert Richter <rric@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, Jan Beulich <JBeulich@suse.com>,
        dt.tangr@gmail.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        James Hogan <james.hogan@imgtec.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "Yaakov (Cygwin/X)" <yselkowitz@users.sourceforge.net>,
        zzs0213@gmail.com,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] kbuild changes for v3.11-rc1
Message-ID: <20130712105721.GF8731@rric.localhost>
References: <20130710133742.GA29368@emu.suse.cz>
 <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
 <20130711135445.GA21500@sepie.suse.cz>
 <CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.13 10:16:18, Linus Torvalds wrote:
> On Thu, Jul 11, 2013 at 6:54 AM, Michal Marek <mmarek@suse.cz> wrote:
> >
> > Yeah. It also reveals another bug that we rewrite the kernel.release
> > file each time.

The odd thing I have in a specific configuration is that depmod is
missing the kernelrelease when I only build install rules, though I
had built everything before and kernelrelease should be there:

 $ make <makeflags>
 $ make <makeflags> modules_install zinstall
 ...
   DEPMOD  
 Usage: .../scripts/depmod.sh /sbin/depmod <kernelrelease>

Note that makeflags include the -j option, INSTALL_MOD_PATH and
INSTALL_PATH variables set, so no root perms required in this case.

I agree, the fix to add a dependency to the kernelrelease file is
wrong here since it rewrites the object tree, which should be readonly
for install rules.

I could reproduce the error above in my setup and will look at it
again, hopefully fixing it more carefully.

Appologize the trouble this made.

Thanks,

-Robert
