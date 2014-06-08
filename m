Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbaFHRTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 13:19:11 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:55586 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaFHRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 13:19:10 -0400
Date: Sun, 8 Jun 2014 19:18:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, gorcunov@openvz.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, luto@amacapital.net,
        mingo@kernel.org, sasha.levin@oracle.com, stefani@seibold.net,
        tglx@linutronix.de, xemul@parallels.com, kbuild@vger.kernel.org
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
Message-ID: <20140608171848.GA19777@ravnborg.org>
References: <201406042235.s54MZgwP020553@terminus.zytor.com>
 <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org>
 <53922D7F.8090601@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53922D7F.8090601@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 02:07:11PM -0700, H. Peter Anvin wrote:
> On 06/06/2014 02:00 PM, Andrew Morton wrote:
> > On Wed, 4 Jun 2014 15:35:42 -0700 "H. Peter Anvin" <hpa@linux.intel.com> wrote:
> > 
> >> Vdso cleanups and improvements largely from Andy Lutomirski.
> > 
> > arch/x86/vdso/vdso2c.h: In function 'go64':
> > arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le64toh'
> > arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le32toh'
> > arch/x86/vdso/vdso2c.h:21: warning: implicit declaration of function 'le16toh'
> > arch/x86/vdso/vdso2c.h:119: warning: implicit declaration of function 'htole16'
> > 
> > My Fedora Core 6 (lol gotcha) test box doesn't have these.
> > 
> > http://www.unix.com/man-page/linux/3/le64toh/ has some details.  I
> > don't appear to have letoh64 and friends either.  
> > 
> 
> OK... so now we have a tools baseline problem.  It isn't that we
> couldn't open-code these functions, but of course we'd also like to not
> *have* to do so... but also we don't want to have the kernel build rely
> on autoconf ;)
> 
> So we have a few options, here:
> 
> 1. We could use the unaligned macros defined in
>    tools/include/tools/*_byteshift.h.
> 
> 2. Open-code it.
> 
> 3. Define a baseline which includes these kinds of functions.
> 
> I guess I would be leaning toward #1, but would also wonder if that also
> means we should add -I$(srctree)/tools/include to the global settings
> ... we are *already* adding it to HOSTCFLAGS_sortextable.o.

I would say that tools/include/tools/* should be considered the baseline
for programs running on the host.
So therefore unconditionally adding -I$(srctree)/tools/include should then
be OK.

	Sam
