Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3DZWBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:01:38 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:40095 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3DZWBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:01:37 -0400
Date: Sat, 27 Apr 2013 00:01:31 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: sedat.dilek@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 26
Message-ID: <20130426220131.GC5100@free.fr>
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au>
 <CA+icZUWt_W5FUQgQ2TFoQU0df+sAbxZZE8AcD16T3f_fiTD9DQ@mail.gmail.com>
 <517A4FC1.3070605@suse.cz>
 <20130426100435.GA28733@sepie.suse.cz>
 <CA+icZUVOfB2JuL1xh1EO1hTP_eOkntYFKsUJ0Zp6VZqn09NABA@mail.gmail.com>
 <CA+icZUWNVEsiTs6u_2R9krb45ub4t-pZj_VEPRmrX2c4DzwfmA@mail.gmail.com>
 <CA+icZUXSsqN1iE3ttQakvpZqG-oOL9NR6RMUezB7LGeUw3d00Q@mail.gmail.com>
 <517A6033.5060103@suse.cz>
 <517A615D.9020400@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517A615D.9020400@suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, Sedat, All,

On Fri, Apr 26, 2013 at 01:13:33PM +0200, Michal Marek wrote:
> On 26.4.2013 13:08, Michal Marek wrote:
> > On 26.4.2013 12:49, Sedat Dilek wrote:
> >> With reverting all kbuild-next commits I was able to build again.
> >>
> >>       Revert "kconfig: implement KCONFIG_PROBABILITY for randconfig"
> >>       Revert "kconfig: allow specifying the seed for randconfig"
> >>       Revert "kconfig: fix randomising choice entries in presence of
> >> KCONFIG_ALLCONFIG"
> >>       Revert "kconfig: do not override symbols already set"
> >>       Revert "kconfig: fix randconfig tristate detection"
> > 
> > I did the same, then applied all the kconfig commits once more and did a
> > git bisect with this script:
> > 
> > #!/bin/sh
> > 
> > cp config-bad .config
> > make silentoldconfig </dev/null
> > 
> > This resulted in
> > 
> > 7ded2624f8988bd22819a60a6000ba6b7091db89 is the first bad commit
> > commit 7ded2624f8988bd22819a60a6000ba6b7091db89
> > Author: Yann E. MORIN <yann.morin.1998@free.fr>
> > Date:   Sun Mar 10 16:34:10 2013 +0100
> > 
> >     kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
> > 
> > The commit id is different, because it is reverted and applied again. Yann?
> 
> Commit 422c809 ("kconfig: fix randomising choice entries in presence of
> KCONFIG_ALLCONFIG") reverts cleanly and reverting it fixes the bug. So
> there is a plan B.

I do not understand how reverting 422c809 could have fixed the
silentoldconfig issue: as I previously reported, it already happens on
Linus' master.

I tried again jsut a few minutes ago against:
    d7d7271: Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
and it is already broken, although 422c809 is not yet in Linus' tree:

    $ make silentoldconfig </dev/null
    scripts/kconfig/conf --silentoldconfig Kconfig
    warning: (IA32_EMULATION) selects COMPAT_BINFMT_ELF which has unmet
    direct dependencies (COMPAT && BINFMT_ELF)
    *
    * Restart config...
    *
    *
    * Paravirtualized guest support
    *
    Paravirtualized guest support (PARAVIRT_GUEST) [N/y/?] (NEW) aborted!

    Console input/output is redirected. Run 'make oldconfig' to update configuration.

    make[1]: *** [silentoldconfig] Error 1
    make: *** [silentoldconfig] Error 2

Or did I miss something?

However, oldconfig just works (with an error for each new symbol):
    $ make oldconfig </dev/null
    [--SNIP--]
      NOP USB Transceiver Driver (NOP_USB_XCEIV) [N/m/?] (NEW)
    Error in reading or end of file.

    #
    # configuration written to .config
    #

(Which does not mean 422c809 can't be reverted for other reasons, more
on that in another mail).

Regards,
Yann E. MORIN.

PS. I'm sad that I do not receive Sedat's emails for some reasons... :-(
YEM.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
